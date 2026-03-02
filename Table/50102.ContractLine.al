// Table: Contract Line
// Purpose: Lines for contract details
table 50102 "Contract Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Line';

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            NotBlank = true;
            DataClassification = ToBeClassified;
            Caption = 'Contract No.';
            TableRelation = "Contract Header"."No.";

            trigger OnValidate()
            begin
                if ContractHeader.Get("Contract No.") then begin
                    "Currency Code" := ContractHeader."Currency Code";
                    "Customer No." := ContractHeader."Customer No.";
                    "Vendor No." := ContractHeader."Vendor No.";
                end;
            end;
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

        field(4; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description 2';
        }

        field(10; "Type"; Option)
        {
            OptionMembers = " ","Item","Resource","G/L Account","Comment";
            OptionCaption = ' ,Item,Resource,G/L Account,Comment';
            DataClassification = ToBeClassified;
            Caption = 'Type';

            trigger OnValidate()
            begin
                "No." := '';
                Description := '';
            end;
        }

        field(11; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';

            trigger OnValidate()
            begin
                case Type of
                    Type::Item:
                        begin
                            if Item.Get("No.") then begin
                                Description := Item.Description;
                                "Unit Price" := Item."Unit Price";
                            end;
                        end;
                    Type::Resource:
                        begin
                            if Resource.Get("No.") then begin
                                Description := Resource.Name;
                                "Unit Price" := Resource."Unit Price";
                            end;
                        end;
                    Type::"G/L Account":
                        begin
                            if GLAccount.Get("No.") then
                                Description := GLAccount.Name;
                        end;
                end;
            end;
        }

        field(20; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                ValidateQuantity();
            end;
        }

        field(21; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }

        field(22; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Price';
            DecimalPlaces = 2 : 5;
        }

        field(23; "Line Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
        }

        field(24; "Line Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount Amount';
        }

        field(30; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                Amount := Round(Quantity * "Unit Price" * (1 - "Line Discount %" / 100), 0.01);
            end;
        }

        field(40; "Quantity Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(41; "Amount Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Invoiced';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }

        field(50; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }

        field(51; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }

        field(60; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(PK; "Contract No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then begin
            ContractLine.SetRange("Contract No.", "Contract No.");
            if ContractLine.FindLast() then
                "Line No." := ContractLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;

    procedure ValidateQuantity()
    begin
        Amount := Round(Quantity * "Unit Price" * (1 - "Line Discount %" / 100), 0.01);
    end;

    var
        ContractHeader: Record "Contract Header";
        ContractLine: Record "Contract Line";
        Item: Record Item;
        Resource: Record Resource;
        GLAccount: Record "G/L Account";
}
