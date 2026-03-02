// Page: Contract Billing Subform
page 50123 "Contract Billing Subform"
{
    ApplicationArea = All;
    Caption = 'Billing Schedule';
    PageType = ListPart;
    SourceTable = "Contract Billing Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Scheduled Payment No."; "Scheduled Payment No.")
                {
                    ApplicationArea = All;
                    Width = 5;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    BlankZero = true;
                }
                field("Invoiced Amount"; "Invoiced Amount")
                {
                    ApplicationArea = All;
                }
                field(Invoiced; Invoiced)
                {
                    ApplicationArea = All;
                }
                field("Invoice No."; "Invoice No.")
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
            action(CreateInvoice)
            {
                ApplicationArea = All;
                Caption = 'Create Invoice';
                Image = CreateJournalBatch;
                Enabled = not Invoiced;

                trigger OnAction()
                begin
                    CreateInvoice();
                end;
            }
            action(ViewInvoice)
            {
                ApplicationArea = All;
                Caption = 'View Invoice';
                Image = ViewJournal;
                Enabled = Invoiced;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    if "Invoice No." <> '' then begin
                        SalesInvoiceHeader.Get("Invoice No.");
                        Page.Run(Page::"Sales Invoice", SalesInvoiceHeader);
                    end;
                end;
            }
        }
    }

    local procedure CreateInvoice()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ContractLine: Record "Contract Line";
        LineNo: Integer;
    begin
        TestField(Amount);
        TestField("Due Date");
        if Invoiced then
            Error('Billing line has already been invoiced.');

        // Get contract header
        Rec.CalcFields();
        // ContractHeader.Get("Contract No.");
        
        // Placeholder - would create actual invoice here
        Message('Invoice creation will create sales invoice from contract lines.');
    end;
}
