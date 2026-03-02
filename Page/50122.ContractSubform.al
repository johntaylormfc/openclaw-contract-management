// Page: Contract Subform
page 50122 "Contract Subform"
{
    ApplicationArea = All;
    Caption = 'Contract Lines';
    PageType = ListPart;
    SourceTable = "Contract Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    BlankZero = true;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetLines)
            {
                ApplicationArea = All;
                Caption = 'Get Lines';

                trigger OnAction()
                begin
                    // Placeholder for getting lines from items/services
                end;
            }
        }
    }
}
