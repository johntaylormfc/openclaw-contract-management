codeunit 50101 "Contract Invoice Mgt."
{
    procedure CreateSalesDocsFromContractBilling(AsOfDate: Date; PostMode: Enum "Contract Invoice Post Mode")
    var
        ContractBilling: Record "Contract Billing";
        ContractHeader: Record "Contract Header";
        ContractLine: Record "Contract Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        NextBillingLineNo: Integer;
        DocumentNo: Code[20];
        LineNo: Integer;
        TotalAmount: Decimal;
        GroupsCreated: Integer;
        LinesCreated: Integer;
        ErrorsOccurred: Boolean;
        ErrorText: Text;
        CurrentCustomerNo: Code[20];
        CurrentBillToNo: Code[20];
        CurrentCurrency: Code[10];
        CurrentPaymentTerms: Code[10];
        CurrentPaymentMethod: Code[10];
    begin
        // Find eligible unbilled details
        ContractBilling.SetRange(Billed, false);
        ContractBilling.SetFilter("Next Invoice Date", '<=%1', AsOfDate);
        ContractBilling.SetCurrentKey("Contract No.", "Contract Line No.", "Next Invoice Date");
        if ContractBilling.FindSet() then begin
            repeat
                // Check header and line status
                if not ContractHeader.Get(ContractBilling."Contract No.") then
                    continue;
                if not ContractLine.Get(ContractBilling."Contract No.", ContractBilling."Contract Line No.") then
                    continue;

                if not IsEligibleForBilling(ContractHeader, ContractLine) then
                    continue;

                // Simplified grouping: by customer only (as requested)
                if (CurrentCustomerNo <> ContractBilling."Contract No.") or
                   (CurrentCustomerNo = '') then begin
                    // Create new document for new customer
                    if SalesHeader."No." <> '' then begin
                        // Post or save previous document
                        if PostMode = PostMode::"Create and Post" then
                            PostSalesHeader(SalesHeader)
                        else
                            SalesHeader.Insert();
                    end;

                    // Create new sales header
                    Clear(SalesHeader);
                    SalesHeader.Init();
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                    SalesHeader."Sell-to Customer No." := ContractHeader."Sell-to Customer No.";
                    SalesHeader."Bill-to Customer No." := ContractHeader."Bill-to Customer No.";
                    SalesHeader."Currency Code" := ContractHeader."Currency Code";
                    SalesHeader."Payment Terms Code" := ContractHeader."Payment Terms Code";
                    SalesHeader."Payment Method Code" := ContractHeader."Payment Method Code";
                    SalesHeader."Posting Date" := AsOfHeader;
                    SalesHeader."Your Reference" := ContractHeader."Contract No.";
                    SalesHeader.Insert(true);

                    CurrentCustomerNo := ContractHeader."Sell-to Customer No.";
                    CurrentBillToNo := ContractHeader."Bill-to Customer No.";
                    CurrentCurrency := ContractHeader."Currency Code";
                    CurrentPaymentTerms := ContractHeader."Payment Terms Code";
                    CurrentPaymentMethod := ContractHeader."Payment Method Code";
                    LineNo := 0;
                    GroupsCreated += 1;
                end;

                // Add line to sales document
                Clear(SalesLine);
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                LineNo += 10000;
                SalesLine."Line No." := LineNo;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine."No." := ContractLine."Item No.";
                SalesLine.Description := ContractLine.Description;
                SalesLine.Quantity := ContractBilling."Quantity to Invoice";
                SalesLine."Unit Price" := ContractBilling."Unit Price";
                SalesLine.Amount := ContractBilling.Amount;
                SalesLine."VAT Base Amount" := ContractBilling.Amount;
                SalesLine.Insert(true);

                // Mark as billed
                ContractBilling.Billed := true;
                ContractBilling."Invoice No." := SalesHeader."No.";
                ContractBilling.Modify();

                TotalAmount += ContractBilling.Amount;
                LinesCreated += 1;

            until ContractBilling.Next() = 0;

            // Insert last document
            if SalesHeader."No." <> '' then begin
                if PostMode = PostMode::"Create and Post" then
                    PostSalesHeader(SalesHeader)
                else
                    SalesHeader.Insert();
            end;
        end;

        // Refresh summaries
        RefreshAllSummaries();

        // Log results
        Message('Contract billing completed.\nGroups created: %1\nLines created: %2\nTotal amount: %3',
            GroupsCreated, LinesCreated, TotalAmount);
    end;

    local procedure IsEligibleForBilling(ContractHeader: Record "Contract Header"; ContractLine: Record "Contract Line"): Boolean
    begin
        // Check header status
        if ContractHeader.Status <> ContractHeader.Status::Active then
            if ContractHeader.Status <> ContractHeader.Status::"LastBilling" then
                exit(false);

        // Check line status
        if ContractLine.Status <> ContractLine.Status::Active then
            if ContractLine.Status <> ContractLine.Status::"LastBilling" then
                exit(false);

        exit(true);
    end;

    local procedure PostSalesHeader(SalesHeader: Record "Sales Header")
    var
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesPost.Run(SalesHeader);
    end;

    local procedure RefreshAllSummaries()
    var
        ContractLine: Record "Contract Line";
        ContractBillingMgt: Codeunit "Contract Billing Mgt.";
    begin
        // Refresh all line summaries
        if ContractLine.FindSet() then
            repeat
                ContractBillingMgt.RefreshHeaderAndLineSummary(ContractLine."Contract No.", ContractLine."Line No.");
            until ContractLine.Next() = 0;
    end;

    var
        AsOfHeader: Date;
}
