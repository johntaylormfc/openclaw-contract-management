page 50103 "Contract Line Card"
{
    ApplicationArea = All;
    Caption = 'Contract Line';
    PageType = Card;
    SourceTable = "Contract Line";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Billing Type"; Rec."Billing Type")
                {
                    ApplicationArea = All;
                }
            }
            group(Billing)
            {
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(Dates)
            {
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
                field(Interval; Rec.Interval)
                {
                    ApplicationArea = All;
                }
            }
            group(Status)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(Overrides)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
            }
            group("Next Invoice")
            {
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
        area(Processing)
        {
            action(GenerateBilling)
            {
                ApplicationArea = All;
                Caption = 'Generate Billing Details';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ContractBillingMgt: Codeunit "Contract Billing Mgt.";
                begin
                    ContractBillingMgt.GenerateDetailsForLine(Rec);
                    Message('Billing details generated for contract line %1', Rec."Line No.");
                end;
            }
            action(RebuildBilling)
            {
                ApplicationArea = All;
                Caption = 'Rebuild Unbilled Details';
                Image = Refresh;

                trigger OnAction()
                var
                    ContractBillingMgt: Codeunit "Contract Billing Mgt.";
                begin
                    ContractBillingMgt.RebuildUnbilledDetailsForLine(Rec);
                    Message('Unbilled billing details rebuilt for contract line %1', Rec."Line No.");
                end;
            }
        }
    }
}
