page 50104 "Contract Billing List"
{
    ApplicationArea = All;
    Caption = 'Contract Billing Details';
    PageType = List;
    SourceTable = "Contract Billing";
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
                field("Contract Line No."; Rec."Contract Line No.")
                {
                    ApplicationArea = All;
                }
                field("Billing Line No."; Rec."Billing Line No.")
                {
                    ApplicationArea = All;
                }
                field("Billing Start Date"; Rec."Billing Start Date")
                {
                    ApplicationArea = All;
                }
                field("Billing End Date"; Rec."Billing End Date")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Quantity to Invoice"; Rec."Quantity to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    ApplicationArea = All;
                }
                field(Billed; Rec.Billed)
                {
                    ApplicationArea = All;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
