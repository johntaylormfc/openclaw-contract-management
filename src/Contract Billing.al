// OpenClaw Contract Management Extension
// Version: 1.0.0.1 - Updated for BC 27 tenant parameter fix test
// GitHub: johntaylormfc/openclaw-contract-management

table 50102 "Contract Billing"
{
    DataClassification = ToBeClassified;
    TableType = Normal;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Contract Header"."Contract No.";
        }

        field(2; "Contract Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(3; "Billing Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(4; "Billing Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(5; "Billing End Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(7; "Quantity to Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(8; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(9; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(10; "Next Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(11; Billed; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }

        field(12; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(13; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Active,OnHold,"LastBilling",Terminated;
            OptionCaption = 'Active,OnHold,LastBilling,Terminated';
        }
    }

    keys
    {
        key(PK; "Contract No.", "Contract Line No.", "Billing Line No.")
        {
            Clustered = true;
        }
        key("Contract Line Key"; "Contract No.", "Contract Line No.")
        {
        }
        key("Billed Key"; "Contract No.", "Contract Line No.", Billed)
        {
        }
        key("Next Invoice Key"; "Next Invoice Date", Billed)
        {
        }
    }

    trigger OnInsert()
    begin
        if "Contract No." = '' then
            Error('Contract No. must be specified');

        // Auto-calculate Amount
        Amount := "Quantity to Invoice" * "Unit Price";
    end;

    trigger OnModify()
    begin
        // Recalculate Amount if quantities or price changed
        Amount := "Quantity to Invoice" * "Unit Price";
    end;
}
