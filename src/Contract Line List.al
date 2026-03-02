page 50102 "Contract Line List"
{
    ApplicationArea = All;
    Caption = 'Contract Lines';
    PageType = List;
    SourceTable = "Contract Line";
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
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Billing Type"; Rec."Billing Type")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
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
            action(ContractBilling)
            {
                ApplicationArea = All;
                Caption = 'Billing Details';
                RunObject = page "Contract Billing List";
                RunPageLink = "Contract No." = field("Contract No."),
                              "Contract Line No." = field("Line No.");
                Image = Entries;
            }
        }
    }
}
