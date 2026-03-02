// Table: Contract Billing Line
// Purpose: Payment schedules for contracts
table 50103 "Contract Billing Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Billing Line';

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            NotBlank = true;
            DataClassification = ToBeClassified;
            Caption = 'Contract No.';
            TableRelation = "Contract Header"."No.";

            trigger OnValidate()
            begin
                if ContractHeader.Get("Contract No.") then begin
                    "Currency Code" := ContractHeader."Currency Code";
                end;
            end;
        }

        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }

        field(3; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }

        field(4; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        field(10; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }

        field(11; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount (LCY)';
        }

        field(15; "Invoiced Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced Amount';
            Editable = false;
        }

        field(16; "Invoiced"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced';
            Editable = false;
        }

        field(20; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice No.';
            TableRelation = "Sales Invoice Header"."No.";
            Editable = false;
        }

        field(30; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
            TableRelation = Currency;
        }

        field(40; "Scheduled Payment No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Scheduled Payment No.';
        }

        field(50; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }

        field(60; "Notes"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "Contract No.", "Line No.")
        {
            Clustered = true;
        }
        key(ContractDueDate; "Contract No.", "Due Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then begin
            BillingLine.SetRange("Contract No.", "Contract No.");
            if BillingLine.FindLast() then
                "Line No." := BillingLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;

    procedure CreateInvoice()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ContractLine: Record "Contract Line";
        LineNo: Integer;
    begin
        TestField(Amount);
        TestField("Due Date");
        if Invoiced then
            Error(AlreadyInvoicedErr, "Contract No.", "Line No.");

        // Get contract header
        ContractHeader.Get("Contract No.");
        ContractHeader.TestField("Customer No.");

        // Create sales header
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := '';
        SalesHeader.SetSalesPersonFromUser();
        SalesHeader.Insert(true);

        // Add contract reference
        SalesHeader."Contract No." := "Contract No.";

        // Create sales lines from contract lines
        ContractLine.SetRange("Contract No.", "Contract No.");
        ContractLine.SetFilter(Amount, '<>0');
        if ContractLine.FindSet() then begin
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := LineNo;
                LineNo += 10000;

                SalesLine.Type := SalesLine.Type::Item;
                SalesLine."No." := ContractLine."No.";
                SalesLine.Quantity := ContractLine.Quantity;
                SalesLine."Unit Price" := ContractLine."Unit Price";
                SalesLine."Line Discount %" := ContractLine."Line Discount %";
                SalesLine.Insert(true);
            until ContractLine.Next() = 0;
        end;

        // Mark as invoiced
        Invoiced := true;
        "Invoice No." := SalesHeader."No.";
        "Invoiced Amount" := Amount;
        Modify();

        // Open invoice page
        Page.Run(Page::"Sales Invoice", SalesHeader);
    end;

    var
        ContractHeader: Record "Contract Header";
        BillingLine: Record "Contract Billing Line";
        AlreadyInvoicedErr: Label 'Billing line %1 / %2 has already been invoiced.';
}
