// Page: Contract List
// Purpose: List page for contracts
page 50120 "Contract List"
{
    ApplicationArea = All;
    Caption = 'Contracts';
    CardPageId = "Contract Card";
    Editable = false;
    PageType = List;
    SourceTable = "Contract Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract number.';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Contract Type"; "Contract Type")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
                field("Total Contract Value"; "Total Contract Value")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ApprovedContracts)
            {
                ApplicationArea = All;
                Caption = 'Approved';
                RunObject = page "Contract List";
                RunPageLink = "Approval Status" = const(Approved);
            }
            action(PendingApproval)
            {
                ApplicationArea = All;
                Caption = 'Pending Approval';
                RunObject = page "Contract List";
                RunPageLink = "Approval Status" = const(Pending);
            }
            action(ActiveContracts)
            {
                ApplicationArea = All;
                Caption = 'Active';
                RunObject = page "Contract List";
                RunPageLink = Status = const(Active);
            }
        }
    }
}
