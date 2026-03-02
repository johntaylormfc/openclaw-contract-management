// Page: Contract Setup
page 50125 "Contract Setup"
{
    ApplicationArea = All;
    Caption = 'Contract Setup';
    PageType = Card;
    SourceTable = "Contract Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Primary Key"; "Primary Key")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Contract Nos."; "Contract Nos.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Contract Archive Nos."; "Contract Archive Nos.")
                {
                    ApplicationArea = All;
                }
                field("Default Contract Duration (Months)"; "Default Contract Duration (Months)")
                {
                    ApplicationArea = All;
                }
            }
            group(Approvals)
            {
                field("Require Approval for New Contracts"; "Require Approval for New Contracts")
                {
                    ApplicationArea = All;
                }
                field("Require Approval for Amendments"; "Require Approval for Amendments")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(NoSeries)
            {
                ApplicationArea = All;
                Caption = 'No. Series';
                Image = NoSeries;
                RunObject = page "No. Series";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Get();
    end;

    trigger OnInsert()
    begin
        Get();
    end;

    var
        ContractSetup: Record "Contract Setup";
}
