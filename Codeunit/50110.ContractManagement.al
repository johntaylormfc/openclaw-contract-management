// Codeunit: Contract Management
// Purpose: Business logic for contract operations (delete, archive, status transitions)
codeunit 50110 "Contract Management"
{
    TableNo = "Contract Header";

    trigger OnRun()
    begin
    end;

    procedure DeleteContract(var ContractHeader: Record "Contract Header")
    var
        ContractLine: Record "Contract Line";
        ContractBillingLine: Record "Contract Billing Line";
        ConfirmDelete: Label 'Are you sure you want to delete contract %1?';
    begin
        // Check for invoiced lines
        ContractLine.SetRange("Contract No.", ContractHeader."No.");
        ContractLine.SetFilter("Quantity Invoiced", '>0');
        if not ContractLine.IsEmpty then
            Error(ContractHasInvoicedLinesErr, ContractHeader."No.");

        // Check if active
        if ContractHeader.Status = ContractHeader.Status::Active then
            Error(ContractIsActiveErr, ContractHeader."No.");

        // Confirm delete
        if not Confirm(ConfirmDelete, true, ContractHeader."No.") then
            exit;

        // Delete lines
        ContractLine.SetRange("Contract No.", ContractHeader."No.");
        ContractLine.DeleteAll(true);

        // Delete billing lines
        ContractBillingLine.SetRange("Contract No.", ContractHeader."No.");
        ContractBillingLine.DeleteAll(true);

        // Delete header
        ContractHeader.Delete(true);
    end;

    procedure ArchiveContract(var ContractHeader: Record "Contract Header")
    var
        ContractHeaderArchive: Record "Contract Header Archive";
        ContractLine: Record "Contract Line";
        ContractLineArchive: Record "Contract Line Archive";
        ContractBillingLine: Record "Contract Billing Line";
        ContractBillingLineArchive: Record "Contract Billing Line Archive";
        ContractSetup: Record "Contract Setup";
    begin
        ContractSetup.Get();
        ContractSetup.TestField("Contract Archive Nos.");

        // Create archive header
        ContractHeaderArchive.Init();
        ContractHeaderArchive."No." := '';
        NoSeriesMgt.InitSeries(ContractSetup."Contract Archive Nos.", ContractHeader."No.", 0D, 
            ContractHeaderArchive."No.", ContractSetup."Contract Archive Nos.");
        ContractHeaderArchive.TransferFields(ContractHeader);
        ContractHeaderArchive."Archived No." := ContractHeaderArchive."No.";
        ContractHeaderArchive."Original No." := ContractHeader."No.";
        ContractHeaderArchive."Archived DateTime" := CurrentDateTime;
        ContractHeaderArchive."Archived By" := UserId;
        ContractHeaderArchive.Insert();

        // Archive lines
        ContractLine.SetRange("Contract No.", ContractHeader."No.");
        if ContractLine.FindSet() then begin
            repeat
                ContractLineArchive.Init();
                ContractLineArchive.TransferFields(ContractLine);
                ContractLineArchive."Contract No." := ContractHeaderArchive."No.";
                ContractLineArchive.Insert();
            until ContractLine.Next() = 0;
        end;

        // Archive billing lines
        ContractBillingLine.SetRange("Contract No.", ContractHeader."No.");
        if ContractBillingLine.FindSet() then begin
            repeat
                ContractBillingLineArchive.Init();
                ContractBillingLineArchive.TransferFields(ContractBillingLine);
                ContractBillingLineArchive."Contract No." := ContractHeaderArchive."No.";
                ContractBillingLineArchive.Insert();
            until ContractBillingLine.Next() = 0;
        end;

        // Update original to archived
        ContractHeader.CalcFields("Total Contract Value");
        ContractHeader."Archived No." := ContractHeaderArchive."No.";
        ContractHeader.Status := ContractHeader.Status::Archived;
        ContractHeader.Modify();

        // Delete original
        ContractLine.SetRange("Contract No.", ContractHeader."No.");
        ContractLine.DeleteAll(true);
        ContractBillingLine.SetRange("Contract No.", ContractHeader."No.");
        ContractBillingLine.DeleteAll(true);
        ContractHeader.Delete(true);
    end;

    procedure CancelContract(var ContractHeader: Record "Contract Header")
    var
        ConfirmCancel: Label 'Are you sure you want to cancel contract %1?';
    begin
        if ContractHeader.Status <> ContractHeader.Status::Active then
            Error(CanOnlyCancelActiveErr);

        if not Confirm(ConfirmCancel, true, ContractHeader."No.") then
            exit;

        ContractHeader.Status := ContractHeader.Status::Cancelled;
        ContractHeader."Status Changed Date" := CurrentDateTime;
        ContractHeader.Modify();
    end;

    procedure ReopenContract(var ContractHeader: Record "Contract Header")
    var
        ConfirmReopen: Label 'Are you sure you want to reopen contract %1?';
    begin
        if not (ContractHeader.Status in [
            ContractHeader.Status::Cancelled,
            ContractHeader.Status::Expired
        ]) then
            Error(CanOnlyReopenCancelledOrExpiredErr);

        if not Confirm(ConfirmReopen, true, ContractHeader."No.") then
            exit;

        ContractHeader.Status := ContractHeader.Status::Active;
        ContractHeader."Status Changed Date" := CurrentDateTime;
        ContractHeader.Modify();
    end;

    procedure GenerateBillingSchedule(var ContractHeader: Record "Contract Header")
    var
        ContractBillingLine: Record "Contract Billing Line";
        DueDate: Date;
        LineNo: Integer;
        AmountPerPeriod: Decimal;
        NumPeriods: Integer;
        PeriodIdx: Integer;
    begin
        ContractHeader.TestField("Start Date");
        ContractHeader.TestField("End Date");
        ContractHeader.TestField("Total Contract Value");
        ContractHeader.TestField("Billing Frequency");

        // Clear existing billing lines
        ContractBillingLine.SetRange("Contract No.", ContractHeader."No.");
        ContractBillingLine.DeleteAll(true);

        // Calculate billing periods
        case ContractHeader."Billing Frequency" of
            ContractHeader."Billing Frequency"::Monthly:
                NumPeriods := (ContractHeader."End Date" - ContractHeader."Start Date") / 30;
            ContractHeader."Billing Frequency"::Quarterly:
                NumPeriods := (ContractHeader."End Date" - ContractHeader."Start Date") / 91;
            ContractHeader."Billing Frequency"::"Semi-Annual":
                NumPeriods := (ContractHeader."End Date" - ContractHeader."Start Date") / 182;
            ContractHeader."Billing Frequency"::Annual:
                NumPeriods := (ContractHeader."End Date" - ContractHeader."Start Date") / 365;
        else
            Error(PleaseSetBillingFrequencyErr);
        end;

        if NumPeriods = 0 then
            NumPeriods := 1;

        AmountPerPeriod := ContractHeader."Total Contract Value" / NumPeriods;
        DueDate := ContractHeader."Start Date";

        // Create billing lines
        for PeriodIdx := 1 to NumPeriods do begin
            ContractBillingLine.Init();
            ContractBillingLine."Contract No." := ContractHeader."No.";
            ContractBillingLine."Line No." := PeriodIdx * 10000;
            ContractBillingLine."Scheduled Payment No." := PeriodIdx;
            ContractBillingLine."Due Date" := DueDate;
            ContractBillingLine.Description := StrSubstNo('Payment %1 of %2', PeriodIdx, NumPeriods);
            ContractBillingLine.Amount := AmountPerPeriod;
            ContractBillingLine.Insert();

            // Calculate next due date
            case ContractHeader."Billing Frequency" of
                ContractHeader."Billing Frequency"::Monthly:
                    DueDate := CalcDate('<+1M>', DueDate);
                ContractHeader."Billing Frequency"::Quarterly:
                    DueDate := CalcDate('<+3M>', DueDate);
                ContractHeader."Billing Frequency"::"Semi-Annual":
                    DueDate := CalcDate('<+6M>', DueDate);
                ContractHeader."Billing Frequency"::Annual:
                    DueDate := CalcDate('<+1Y>', DueDate);
            end;
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ContractHasInvoicedLinesErr: Label 'Contract %1 has invoiced lines and cannot be deleted.';
        ContractIsActiveErr: Label 'Contract %1 is still active. Cancel or archive it first.';
        CanOnlyCancelActiveErr: Label 'Only active contracts can be cancelled.';
        CanOnlyReopenCancelledOrExpiredErr: Label 'Only cancelled or expired contracts can be reopened.';
        PleaseSetBillingFrequencyErr: Label 'Please set a billing frequency before generating the billing schedule.';
}
