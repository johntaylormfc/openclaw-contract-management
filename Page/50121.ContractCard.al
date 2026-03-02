// Page: Contract Card
// Purpose: Card page for contract management
page 50121 "Contract Card"
{
    ApplicationArea = All;
    Caption = 'Contract';
    PageType = Card;
    SourceTable = "Contract Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Contract Type"; "Contract Type")
                {
                    ApplicationArea = All;
                }
            }
            group(CustomerVendor)
            {
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Dates)
            {
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Duration (Months)"; "Duration (Months)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Billing Frequency"; "Billing Frequency")
                {
                    ApplicationArea = All;
                }
            }
            group(Financials)
            {
                field("Total Contract Value"; "Total Contract Value")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approved DateTime"; "Approved DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(System)
            {
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created DateTime"; "Created DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Modified By"; "Last Modified By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(ContractLines; "Contract Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Contract No." = field("No.");
            }
            part(BillingLines; "Contract Billing Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Contract No." = field("No.");
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
            action(ApprovalEntries)
            {
                ApplicationArea = All;
                Caption = 'Approval Entries';
                Image = Approval;
                RunObject = page "Approval Entries";
                RunPageLink = "Document No." = field("No.");
                RunPageLink = "Table ID" = const(50101);
            }
        }
        area(Processing)
        {
            action(SendForApproval)
            {
                ApplicationArea = All;
                Caption = 'Send for Approval';
                Image = SendApprovalRequest;
                Enabled = "Approval Status" = "Approval Status"::" ";

                trigger OnAction()
                var
                    ContractApprovalMgt: Codeunit "Contract Approval Mgt.";
                begin
                    ContractApprovalMgt.SendForApproval(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;

                trigger OnAction()
                var
                    ContractApprovalMgt: Codeunit "Contract Approval Mgt.";
                begin
                    ContractApprovalMgt.ApproveContract(Rec);
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;

                trigger OnAction()
                var
                    ContractApprovalMgt: Codeunit "Contract Approval Mgt.";
                begin
                    ContractApprovalMgt.RejectContract(Rec);
                end;
            }
            separator(S1)
            {
            }
            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;

                trigger OnAction()
                var
                    ContractMgt: Codeunit "Contract Management";
                begin
                    ContractMgt.ArchiveContract(Rec);
                end;
            }
            action(Delete)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;

                trigger OnAction()
                var
                    ContractMgt: Codeunit "Contract Management";
                begin
                    ContractMgt.DeleteContract(Rec);
                end;
            }
            separator(S2)
            {
            }
            action(GenerateBilling)
            {
                ApplicationArea = All;
                Caption = 'Generate Billing Schedule';
                Image = SuggestPaymentTerms;

                trigger OnAction()
                var
                    ContractMgt: Codeunit "Contract Management";
                begin
                    ContractMgt.GenerateBillingSchedule(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if "No." <> '' then begin
            if Status = Status::"0" then
                Status := Status::Draft;
        end;
    end;

    trigger OnNewRecord(xRec: Record "Contract Header")
    begin
        if "No." = '' then begin
            Status := Status::Draft;
        end;
    end;
}
