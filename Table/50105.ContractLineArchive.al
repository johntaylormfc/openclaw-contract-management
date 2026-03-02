// Table: Contract Line Archive
table 50105 "Contract Line Archive"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Line Archive';

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

        field(3; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        field(10; "Type"; Option)
        {
            OptionMembers = " ","Item","Resource","G/L Account","Comment";
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }

        field(11; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
        }

        field(20; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';
        }

        field(21; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit of Measure Code';
        }

        field(22; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Price';
        }

        field(23; "Line Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount %';
        }

        field(30; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
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
