page 50101 "Contract Header Card"
{
    ApplicationArea = All;
    Caption = 'Contract Header';
    PageType = Card;
    SourceTable = "Contract Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
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
                field("Align to Month"; Rec."Align to Month")
                {
                    ApplicationArea = All;
                }
                field("Prorate Partial Period"; Rec."Prorate Partial Period")
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
                field("Invoice Separately"; Rec."Invoice Separately")
                {
                    ApplicationArea = All;
                }
            }
            group(Payment)
            {
                field("Currency Code"; Rec."Currency Code")
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
        }
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
                    ContractLine: Record "Contract Line";
                    ContractBillingMgt: Codeunit "Contract Billing Mgt.";
                begin
                    ContractLine.SetRange("Contract No.", Rec."Contract No.");
                    if ContractLine.FindSet() then
                        repeat
                            ContractBillingMgt.GenerateDetailsForLine(ContractLine);
                        until ContractLine.Next() = 0;

                    Message('Billing details generated for contract %1', Rec."Contract No.");
                end;
            }
        }
    }
}
