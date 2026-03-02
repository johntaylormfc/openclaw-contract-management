// Table: Contract Header Archive
// Purpose: Archived contracts
table 50104 "Contract Header Archive"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Header Archive';

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
            DataClassification = ToBeClassified;
            Caption = 'No.';
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
        }

        field(6; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
        }

        field(7; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No.';
        }

        field(8; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
        }

        field(10; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }

        field(11; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
End Date';
        }

        field(12; "Duration (Months)";            Caption = ' Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Duration (Months)';
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
        }

        field(25; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Created By';
        }

        field(35; "Archived No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Archived No.';
        }

        field(36; "Original No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Original No.';
        }

        field(37; "Archived DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Archived DateTime';
        }

        field(38; "Archived By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Archived By';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Original; "Original No.")
        {
        }
    }

    procedure RestoreContract()
    var
        ContractHeader: Record "Contract Header";
    begin
        ContractHeader.Get("Original No.");
        Error(ContractAlreadyExistsErr, "Original No.");
    end;

    var
        ContractAlreadyExistsErr: Label 'Contract %1 already exists. Delete it first before restoring from archive.';
}
