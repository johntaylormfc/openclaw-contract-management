page 50106 "Contract Billing Run Log"
{
    ApplicationArea = All;
    Caption = 'Billing Run Log';
    PageType = List;
    SourceTable = "Contract Billing Run Log";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Run ID"; Rec."Run ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Started At"; Rec."Started At")
                {
                    ApplicationArea = All;
                }
                field("Ended At"; Rec."Ended At")
                {
                    ApplicationArea = All;
                }
                field("As of Date"; Rec."As of Date")
                {
                    ApplicationArea = All;
                }
                field("Post Mode"; Rec."Post Mode")
                {
                    ApplicationArea = All;
                }
                field("Groups Created"; Rec."Groups Created")
                {
                    ApplicationArea = All;
                }
                field("Lines Created"; Rec."Lines Created")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field(Success; Rec.Success)
                {
                    ApplicationArea = All;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
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
            action(RunBilling)
            {
                ApplicationArea = All;
                Caption = 'Run Billing Now';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ContractBillingJobQueue: Codeunit "Contract Billing Job Queue";
                begin
                    ContractBillingJobQueue.RunContractBillingJob();
                end;
            }
            action(RunBillingAndPost)
            {
                ApplicationArea = All;
                Caption = 'Run Billing and Post';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ContractBillingJobQueue: Codeunit "Contract Billing Job Queue";
                begin
                    ContractBillingJobQueue.RunContractBillingJobAndPost();
                end;
            }
        }
    }
}
