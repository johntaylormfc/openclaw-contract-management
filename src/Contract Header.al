table 50100 "Contract Header"
{
    DataClassification = ToBeClassified;
    TableType = Normal;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(2; "Sell-to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }

        field(3; "Bill-to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }

        field(4; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(7; Frequency; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Onetime","Daily","Weekly","Monthly","Quarterly","Semiannual","Annual";
            OptionCaption = 'Onetime,Daily,Weekly,Monthly,Quarterly,Semiannual,Annual';
        }

        field(8; Interval; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 1;
        }

        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending,Active,OnHold,"LastBilling",Terminated;
            OptionCaption = 'Pending,Active,OnHold,LastBilling,Terminated';
        }

        field(10; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }

        field(11; "Align to Month"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }

        field(12; "Prorate Partial Period"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }

        field(13; "Invoice Separately"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }

        field(14; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }

        field(15; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }

        field(16; "Next Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(17; "Next Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Contract No.")
        {
            Clustered = true;
        }
    }

    var
        ContractLine: Record "Contract Line";

    trigger OnInsert()
    begin
        if "Contract No." = '' then
            Error('Contract No. must be specified');
    end;

    trigger OnModify()
    begin
        // Trigger rebuild of unbilled details if relevant fields changed
    end;
}
