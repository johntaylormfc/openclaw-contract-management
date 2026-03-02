// Table: Contract Billing Line Archive
table 50106 "Contract Billing Line Archive"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Billing Line Archive';

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            NotBlank = true;
            DataClassification = ToBeClassified;
            Caption = 'Contract No.';
        }

        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }

        field(3; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }

        field(4; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        field(10; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }

        field(15; "Invoiced Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced Amount';
        }

        field(16; "Invoiced"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced';
        }

        field(20; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice No.';
        }

        field(30; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
        }
    }

    keys
    {
        key(PK; "Contract No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
