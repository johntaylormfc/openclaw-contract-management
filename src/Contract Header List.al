page 50100 "Contract Header List"
{
    ApplicationArea = All;
    Caption = 'Contract Headers';
    PageType = List;
    SourceTable = "Contract Header";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract number.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field(Frequency; Rec.Frequency)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Next Invoice Amount"; Rec."Next Invoice Amount")
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
            action(ContractLines)
            {
                ApplicationArea = All;
                Caption = 'Contract Lines';
                RunObject = page "Contract Line List";
                RunPageLink = "Contract No." = field("Contract No.");
                Image = Lines;
            }
            action(ContractBilling)
            {
                ApplicationArea = All;
                Caption = 'Billing Details';
                RunObject = page "Contract Billing List";
                RunPageLink = "Contract No." = field("Contract No.");
                Image = Entries;
            }
        }
    }
}
