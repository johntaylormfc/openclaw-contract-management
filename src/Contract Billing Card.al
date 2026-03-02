page 50105 "Contract Billing Card"
{
    ApplicationArea = All;
    Caption = 'Contract Billing Detail';
    PageType = Card;
    SourceTable = "Contract Billing";

    layout
    {
        area(Content)
        {
            group(Identification)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Contract Line No."; Rec."Contract Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Billing Line No."; Rec."Billing Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group("Billing Period")
            {
                field("Billing Start Date"; Rec."Billing Start Date")
                {
                    ApplicationArea = All;
                }
                field("Billing End Date"; Rec."Billing End Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Amounts)
            {
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
                    Importance = Promoted;
                }
            }
            group(Invoice)
            {
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    ApplicationArea = All;
                }
                field(Billed; Rec.Billed)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
