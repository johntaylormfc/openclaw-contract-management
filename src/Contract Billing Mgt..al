codeunit 50100 "Contract Billing Mgt."
{
    procedure GenerateDetailsForLine(ContractLine: Record "Contract Line")
    var
        ContractHeader: Record "Contract Header";
        ContractBilling: Record "Contract Billing";
        BillingDate: Date;
        EndDate: Date;
        BillingLineNo: Integer;
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
        EffectiveFrequency: Option;
        EffectiveInterval: Integer;
    begin
        // Get header for inherited values
        ContractHeader.Get(ContractLine."Contract No.");

        // Resolve effective values (line override or header default)
        EffectiveStartDate := ResolveEffectiveDate(ContractLine."Start Date", ContractHeader."Start Date");
        EffectiveEndDate := ResolveEffectiveDate(ContractLine."End Date", ContractHeader."End Date");
        EffectiveFrequency := ResolveEffectiveFrequency(ContractLine.Frequency, ContractHeader.Frequency);
        EffectiveInterval := ResolveEffectiveInterval(ContractLine.Interval, ContractHeader.Interval);

        // Validate
        if EffectiveStartDate = 0D then
            Error('Start Date is required');
        if EffectiveEndDate = 0D then
            Error('End Date is required');
        if EffectiveStartDate > EffectiveEndDate then
            Error('End Date cannot be before Start Date');

        // Delete existing unbilled details for this line
        ContractBilling.SetRange("Contract No.", ContractLine."Contract No.");
        ContractBilling.SetRange("Contract Line No.", ContractLine."Line No.");
        ContractBilling.SetRange(Billed, false);
        ContractBilling.DeleteAll();

        // Get last billing line number
        ContractBilling.SetRange("Contract No.", ContractLine."Contract No.");
        ContractBilling.SetRange("Contract Line No.", ContractLine."Line No.");
        if ContractBilling.FindLast() then
            BillingLineNo := ContractBilling."Billing Line No." + 1
        else
            BillingLineNo := 1;

        // Generate billing periods
        BillingDate := EffectiveStartDate;
        while BillingDate <= EffectiveEndDate do begin
            // Calculate end of billing period
            EndDate := CalcPeriodEndDate(BillingDate, EffectiveFrequency, EffectiveInterval, ContractHeader."Align to Month");

            if EndDate > EffectiveEndDate then
                EndDate := EffectiveEndDate;

            // Create billing detail
            Clear(ContractBilling);
            ContractBilling."Contract No." := ContractLine."Contract No.";
            ContractBilling."Contract Line No." := ContractLine."Line No.";
            ContractBilling."Billing Line No." := BillingLineNo;
            ContractBilling."Billing Start Date" := BillingDate;
            ContractBilling."Billing End Date" := EndDate;
            ContractBilling.Quantity := ContractLine.Quantity;
            ContractBilling."Quantity to Invoice" := ContractLine.Quantity;
            ContractBilling."Unit Price" := ContractLine."Unit Price";
            ContractBilling.Amount := ContractBilling."Quantity to Invoice" * ContractBilling."Unit Price";
            ContractBilling."Next Invoice Date" := BillingDate;
            ContractBilling.Billed := false;
            ContractBilling.Status := ContractLine.Status;
            ContractBilling.Insert();

            // Move to next period
            BillingDate := CalcNextPeriodStartDate(EndDate, EffectiveFrequency, EffectiveInterval);
            BillingLineNo += 1;

            if BillingDate = 0D then
                break;
        end;

        // Refresh header and line summaries
        RefreshHeaderAndLineSummary(ContractLine."Contract No.", ContractLine."Line No.");
    end;

    procedure RebuildUnbilledDetailsForLine(ContractLine: Record "Contract Line")
    var
        ContractBilling: Record "Contract Billing";
    begin
        // Delete unbilled details
        ContractBilling.SetRange("Contract No.", ContractLine."Contract No.");
        ContractBilling.SetRange("Contract Line No.", ContractLine."Line No.");
        ContractBilling.SetRange(Billed, false);
        ContractBilling.DeleteAll();

        // Regenerate if line is active
        if ContractLine.Status = ContractLine.Status::Active then
            GenerateDetailsForLine(ContractLine);
    end;

    procedure RefreshHeaderAndLineSummary(ContractNo: Code[20]; LineNo: Integer)
    var
        ContractHeader: Record "Contract Header";
        ContractLine: Record "Contract Line";
        ContractBilling: Record "Contract Billing";
        NextInvoiceDate: Date;
        NextInvoiceAmount: Decimal;
    begin
        // Refresh line summary
        ContractLine.Get(ContractNo, LineNo);
        ContractBilling.SetRange("Contract No.", ContractNo);
        ContractBilling.SetRange("Contract Line No.", LineNo);
        ContractBilling.SetRange(Billed, false);
        ContractBilling.SetCurrentKey("Next Invoice Date");
        ContractBilling.SetAscending("Next Invoice Date", true);
        if ContractBilling.FindFirst() then begin
            NextInvoiceDate := ContractBilling."Next Invoice Date";
            NextInvoiceAmount := ContractBilling.Amount;
        end else begin
            NextInvoiceDate := 0D;
            NextInvoiceAmount := 0;
        end;

        ContractLine."Next Invoice Date" := NextInvoiceDate;
        ContractLine."Next Invoice Amount" := NextInvoiceAmount;
        ContractLine.Modify();

        // Refresh header summary
        if ContractHeader.Get(ContractNo) then begin
            ContractBilling.SetRange("Contract Line No.");
            ContractBilling.SetRange(Billed, false);
            if ContractBilling.FindFirst() then begin
                ContractHeader."Next Invoice Date" := ContractBilling."Next Invoice Date";
                // Sum all unbilled amounts
                ContractBilling.SetRange("Contract Line No.");
                ContractBilling.SetRange(Billed, false);
                ContractBilling.CalcSums(Amount);
                ContractHeader."Next Invoice Amount" := ContractBilling.Amount;
            end else begin
                ContractHeader."Next Invoice Date" := 0D;
                ContractHeader."Next Invoice Amount" := 0;
            end;
            ContractHeader.Modify();
        end;
    end;

    local procedure ResolveEffectiveDate(LineDate: Date; HeaderDate: Date): Date
    begin
        if LineDate <> 0D then
            exit(LineDate);
        exit(HeaderDate);
    end;

    local procedure ResolveEffectiveFrequency(LineFrequency: Option; HeaderFrequency: Option): Option
    begin
        if LineFrequency <> LineFrequency::" " then
            exit(LineFrequency);
        exit(HeaderFrequency);
    end;

    local procedure ResolveEffectiveInterval(LineInterval: Integer; HeaderInterval: Integer): Integer
    begin
        if LineInterval <> 0 then
            exit(LineInterval);
        if HeaderInterval <> 0 then
            exit(HeaderInterval);
        exit(1);
    end;

    local procedure CalcPeriodEndDate(StartDate: Date; Frequency: Option; Interval: Integer; AlignToMonth: Boolean): Date
    var
        EndDate: Date;
    begin
        case Frequency of
            Frequency::Daily:
                EndDate := CalcDate(StrSubstNo('<+%1D>', Interval), StartDate);
            Frequency::Weekly:
                EndDate := CalcDate(StrSubstNo('<+%1W>', Interval), StartDate);
            Frequency::Monthly:
                if AlignToMonth then
                    EndDate := CalcDate('<CM>', CalcDate(StrSubstNo('<+%1M>', Interval), StartDate))
                else
                    EndDate := CalcDate(StrSubstNo('<+%1M-1D>', Interval), StartDate);
            Frequency::Quarterly:
                if AlignToMonth then
                    EndDate := CalcDate('<CM>', CalcDate(StrSubstNo('<+%1M>', 3 * Interval), StartDate))
                else
                    EndDate := CalcDate(StrSubstNo('<+%1M-1D>', 3 * Interval), StartDate);
            Frequency::Semiannual:
                if AlignToMonth then
                    EndDate := CalcDate('<CM>', CalcDate(StrSubstNo('<+%1M>', 6 * Interval), StartDate))
                else
                    EndDate := CalcDate(StrSubstNo('<+%1M-1D>', 6 * Interval), StartDate);
            Frequency::Annual:
                if AlignToMonth then
                    EndDate := CalcDate('<CM>', CalcDate(StrSubstNo('<+%1Y>', Interval), StartDate))
                else
                    EndDate := CalcDate(StrSubstNo('<+%1Y-1D>', Interval), StartDate);
            Frequency::"Onetime":
                EndDate := StartDate;
        end;
        exit(EndDate);
    end;

    local procedure CalcNextPeriodStartDate(PeriodEndDate: Date; Frequency: Option; Interval: Integer): Date
    var
        NextDate: Date;
    begin
        case Frequency of
            Frequency::Daily:
                NextDate := CalcDate('<+1D>', PeriodEndDate);
            Frequency::Weekly:
                NextDate := CalcDate('<+1W>', PeriodEndDate);
            Frequency::Monthly:
                NextDate := CalcDate(StrSubstNo('<+%1M>', Interval), PeriodEndDate);
            Frequency::Quarterly:
                NextDate := CalcDate(StrSubstNo('<+%1M>', 3 * Interval), PeriodEndDate);
            Frequency::Semiannual:
                NextDate := CalcDate(StrSubstNo('<+%1M>', 6 * Interval), PeriodEndDate);
            Frequency::Annual:
                NextDate := CalcDate(StrSubstNo('<+%1Y>', Interval), PeriodEndDate);
            Frequency::"Onetime":
                NextDate := 0D;
        end;
        exit(NextDate);
    end;
}
