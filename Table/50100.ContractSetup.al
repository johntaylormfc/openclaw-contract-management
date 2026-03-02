// Table: Contract Setup
// Purpose: Stores No. Series setup for contract numbering
table 50100 "Contract Setup"
{
    DataPerCompany = true;
    Caption = 'Contract Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Contract Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            Caption = 'Contract Nos.';
        }
        field(11; "Contract Archive Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            Caption = 'Contract Archive Nos.';
        }
        field(20; "Default Contract Duration (Months)"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 12;
            Caption = 'Default Contract Duration (Months)';
        }
        field(30; "Require Approval for New Contracts"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;
            Caption = 'Require Approval for New Contracts';
        }
        field(31; "Require Approval for Amendments"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;
            Caption = 'Require Approval for Amendments';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        ContractSetup: Record "Contract Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'CONTRACT';
    end;

    procedure Get(): Boolean
    begin
        if not Get('CONTRACT') then begin
            Init();
            "Primary Key" := 'CONTRACT';
            "Default Contract Duration (Months)" := 12;
            "Require Approval for New Contracts" := true;
            "Require Approval for Amendments" := true;
            Insert();
        end;
        exit(true);
    end;

    procedure ValidateContractNoSeries()
    begin
        NoSeriesMgt.ValidateNoSeries("Contract Nos.", xRec."Contract Nos.");
    end;

    procedure ValidateContractArchiveNoSeries()
    begin
        NoSeriesMgt.ValidateNoSeries("Contract Archive Nos.", xRec."Contract Archive Nos.");
    end;
}
