// Table: Contract Header
// Purpose: Main contract table with No.Series, status management, and delete validation
table 50101 "Contract Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
            DataClassification = ToBeClassified;
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    ContractSetup.Get();
                    NoSeriesMgt.ValidateManual("No.", ContractSetup."Contract Nos.", Manual, NextNo);
                    Manual := false;
                end;
            end;
        }

        field(2; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        field(3; "Status"; Option)
        {
            OptionMembers = "Draft","Pending Approval","Approved","Active","Expired","Cancelled","Archived";
            OptionCaption = 'Draft,Pending Approval,Approved,Active,Expired,Cancelled,Archived';
            DataClassification = ToBeClassified;
            Caption = 'Status';

            trigger OnValidate()
            begin
                if Status <> xRec.Status then begin
                    // Add status transition validation here if needed
                    "Status Changed Date" := CurrentDateTime;
                end;
            end;
        }

        field(4; "Contract Type"; Option)
        {
            OptionMembers = " ","Sales","Purchase","Service","Subscription";
            OptionCaption = ' ,Sales,Purchase,Service,Subscription';
            DataClassification = ToBeClassified;
            Caption = 'Contract Type';
        }

        field(5; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if "Customer No." <> '' then begin
                    if Customer.Get("Customer No.") then
                        "Customer Name" := Customer.Name;
                end else
                    "Customer Name" := '';
            end;
        }

        field(6; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
            Editable = false;
        }

        field(7; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if "Vendor No." <> '' then begin
                    if Vendor.Get("Vendor No.") then
                        "Vendor Name" := Vendor.Name;
                end else
                    "Vendor Name" := '';
            end;
        }

        field(8; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
            Editable = false;
        }

        field(10; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                if "Start Date" <> xRec."Start Date" then begin
                    if "Start Date" <> 0D then begin
                        if "End Date" = 0D then begin
                            ContractSetup.Get();
                            "End Date" := CalcDate('<+' + Format(ContractSetup."Default Contract Duration (Months)") + 'M>', "Start Date");
                        end;
                    end;
                end;
            end;
        }

        field(11; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }

        field(12; "Duration (Months)"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Duration (Months)';
            Editable = false;
        }

        field(15; "Total Contract Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Contract Value';
        }

        field(16; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
            TableRelation = Currency;
        }

        field(20; "Approval Status"; Option)
        {
            OptionMembers = " ","Pending","Approved","Rejected";
            OptionCaption = ' ,Pending,Approved,Rejected';
            DataClassification = ToBeClassified;
            Caption = 'Approval Status';
        }

        field(21; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Approved By';
            TableRelation = "User Setup"."User ID";
        }

        field(22; "Approved DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Approved DateTime';
        }

        field(25; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Created By';
        }

        field(26; "Created DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Created DateTime';
        }

        field(27; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Last Modified By';
        }

        field(28; "Last Modified DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Last Modified DateTime';
        }

        field(30; "Status Changed Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status Changed Date';
        }

        field(35; "Archived No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Archived No.';
            TableRelation = "Contract Header Archive"."No.";
        }

        field(40; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Document No.';
        }

        field(50; "Billing Frequency"; Option)
        {
            OptionMembers = " ","Monthly","Quarterly","Semi-Annual","Annual";
            OptionCaption = ' ,Monthly,Quarterly,Semi-Annual,Annual';
            DataClassification = ToBeClassified;
            Caption = 'Billing Frequency';
        }

        field(60; "Notes"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer No.")
        {
        }
        key(Vendor; "Vendor No.")
        {
        }
        key(Status; Status)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Customer No.", "Start Date", "End Date", Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ContractSetup.Get();
            NoSeriesMgt.InitSeries(ContractSetup."Contract Nos.", xRec."No.", 0D, "No.", ContractSetup."Contract Nos.");
        end;

        "Created By" := UserId;
        "Created DateTime" := CurrentDateTime;
        "Last Modified By" := UserId;
        "Last Modified DateTime" := CurrentDateTime;

        if Status = Status::"0" then
            Status := Status::Draft;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified DateTime" := CurrentDateTime;
    end;

    trigger OnDelete()
    var
        ContractLine: Record "Contract Line";
        ContractBillingLine: Record "Contract Billing Line";
    begin
        // Business Logic: Check if contract has been invoiced
        ContractLine.SetRange("Contract No.", "No.");
        ContractLine.SetFilter("Quantity Invoiced", '>0');
        if not ContractLine.IsEmpty then
            Error(CannotDeleteContractWithInvoicedLinesErr, "No.");

        // Check if contract is active
        if Status = Status::Active then
            Error(CannotDeleteActiveContractErr, "No.");

        // Delete associated lines
        ContractLine.SetRange("Contract No.", "No.");
        ContractLine.DeleteAll(true);

        // Delete billing lines
        ContractBillingLine.SetRange("Contract No.", "No.");
        ContractBillingLine.DeleteAll(true);
    end;

    procedure AssistEdit(OldContract: Record "Contract Header"): Boolean
    begin
        ContractSetup.Get();
        ContractSetup.TestField("Contract Nos.");
        if NoSeriesMgt.SelectSeries(ContractSetup."Contract Nos.", xRec."No.", "No.") then begin
            NoSeriesMgt.SetSeries("No.");
            copy(OldContract);
            exit(true);
        end;
    end;

    procedure ShowApprovalEntries()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Contract Header");
        ApprovalEntry.SetRange("Document No.", "No.");
        ApprovalEntry.SetRange("Table ID", Database::"Contract Header");
        Page.Run(Page::"Approval Entries", ApprovalEntry);
    end;

    procedure ArchiveContract()
    var
        ContractHeaderArchive: Record "Contract Header Archive";
        ContractLine: Record "Contract Line";
        ContractLineArchive: Record "Contract Line Archive";
        ContractBillingLine: Record "Contract Billing Line";
        ContractBillingLineArchive: Record "Contract Billing Line Archive";
    begin
        ContractSetup.Get();
        ContractSetup.TestField("Contract Archive Nos.");

        // Create archive header
        ContractHeaderArchive.Init();
        ContractHeaderArchive."No." := '';
        NoSeriesMgt.InitSeries(ContractSetup."Contract Archive Nos.", xRec."No.", 0D, ContractHeaderArchive."No.", ContractSetup."Contract Archive Nos.");
        ContractHeaderArchive.TransferFields(Rec);
        ContractHeaderArchive."Archived No." := ContractHeaderArchive."No.";
        ContractHeaderArchive."Original No." := "No.";
        ContractHeaderArchive."Archived DateTime" := CurrentDateTime;
        ContractHeaderArchive."Archived By" := UserId;
        ContractHeaderArchive.Insert();

        // Archive lines
        ContractLine.SetRange("Contract No.", "No.");
        if ContractLine.FindSet() then begin
            repeat
                ContractLineArchive.Init();
                ContractLineArchive.TransferFields(ContractLine);
                ContractLineArchive."Contract No." := ContractHeaderArchive."No.";
                ContractLineArchive.Insert();
            until ContractLine.Next() = 0;
        end;

        // Archive billing lines
        ContractBillingLine.SetRange("Contract No.", "No.");
        if ContractBillingLine.FindSet() then begin
            repeat
                ContractBillingLineArchive.Init();
                ContractBillingLineArchive.TransferFields(ContractBillingLine);
                ContractBillingLineArchive."Contract No." := ContractHeaderArchive."No.";
                ContractBillingLineArchive.Insert();
            until ContractBillingLine.Next() = 0;
        end;

        // Mark original as archived
        "Archived No." := ContractHeaderArchive."No.";
        Status := Status::Archived;
        Modify();

        // Delete original
        Delete(true);
    end;

    var
        ContractSetup: Record "Contract Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Customer: Record Customer;
        Vendor: Record Vendor;
        Manual: Boolean;
        NextNo: Code[20];
        CannotDeleteContractWithInvoicedLinesErr: Label 'Cannot delete contract %1 - it has invoiced lines.';
        CannotDeleteActiveContractErr: Label 'Cannot delete contract %1 - it is still active. Archive it first or cancel it.';
}
