table 50101 "Contract Line"
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

        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Item,Resource,Comment;
            OptionCaption = 'Item,Resource,Comment';
        }

        field(4; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Item."No." (uncomment when Item table exists)
        }

        field(5; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Billing Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Standard,Usage;
            OptionCaption = 'Standard,Usage';
        }

        field(7; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(8; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(9; Frequency; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Onetime","Daily","Weekly","Monthly","Quarterly","Semiannual","Annual";
            OptionCaption = ' ,Onetime,Daily,Weekly,Monthly,Quarterly,Semiannual,Annual';
        }

        field(10; Interval; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(11; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(12; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(13; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Active,OnHold,"LastBilling",Terminated;
            OptionCaption = 'Active,OnHold,LastBilling,Terminated';
        }

        field(14; "Bill-to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Customer."No." (uncomment when needed)
        }

        field(15; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Payment Terms" (uncomment when needed)
        }

        field(16; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Payment Method" (uncomment when needed)
        }

        field(17; "Next Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(18; "Next Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
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
    var
        ContractBillingMgt: Codeunit "Contract Billing Mgt.";
    begin
        if "Contract No." = '' then
            Error('Contract No. must be specified');

        // Auto-generate line number if not specified
        if "Line No." = 0 then begin
            ContractLine.SetRange("Contract No.", "Contract No.");
            if ContractLine.FindLast() then
                "Line No." := ContractLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;

        // Auto-generate billing details for new active lines
        if Status = Status::Active then
            ContractBillingMgt.GenerateDetailsForLine(Rec);
    end;

    trigger OnModify()
    var
        ContractBillingMgt: Codeunit "Contract Billing Mgt.";
    begin
        // Rebuild unbilled details if relevant fields changed
        if (xRec.Quantity <> Quantity) or
           (xRec."Unit Price" <> "Unit Price") or
           (xRec."Start Date" <> "Start Date") or
           (xRec."End Date" <> "End Date") or
           (xRec.Frequency <> Frequency) or
           (xRec.Interval <> Interval) or
           (xRec.Status <> Status) then
            ContractBillingMgt.RebuildUnbilledDetailsForLine(Rec);
    end;

    trigger OnDelete()
    var
        ContractBilling: Record "Contract Billing";
    begin
        // Delete unbilled billing details when line is deleted
        ContractBilling.SetRange("Contract No.", "Contract No.");
        ContractBilling.SetRange("Contract Line No.", "Line No.");
        ContractBilling.SetRange(Billed, false);
        ContractBilling.DeleteAll();
    end;
}
