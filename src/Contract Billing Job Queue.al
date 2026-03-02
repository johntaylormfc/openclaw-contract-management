codeunit 50102 "Contract Billing Job Queue"
{
    procedure RunContractBillingJob()
    var
        ContractInvoiceMgt: Codeunit "Contract Invoice Mgt.";
        AsOfDate: Date;
    begin
        // Default: run for today
        AsOfDate := Today;
        
        // Run in "Create Only" mode - user can manually post
        ContractInvoiceMgt.CreateSalesDocsFromContractBilling(AsOfDate, ContractInvoiceMgt.GetPostModeCreateOnly());
    end;

    procedure RunContractBillingJobAndPost()
    var
        ContractInvoiceMgt: Codeunit "Contract Invoice Mgt.";
        AsOfDate: Date;
    begin
        // Default: run for today
        AsOfDate := Today;
        
        // Run in "Create and Post" mode
        ContractInvoiceMgt.CreateSalesDocsFromContractBilling(AsOfDate, ContractInvoiceMgt.GetPostModeCreateAndPost());
    end;

    procedure RunContractBillingJobForDate(AsOfDate: Date; CreateAndPost: Boolean)
    var
        ContractInvoiceMgt: Codeunit "Contract Invoice Mgt.";
    begin
        if CreateAndPost then
            ContractInvoiceMgt.CreateSalesDocsFromContractBilling(AsOfDate, ContractInvoiceMgt.GetPostModeCreateAndPost())
        else
            ContractInvoiceMgt.CreateSalesDocsFromContractBilling(AsOfDate, ContractInvoiceMgt.GetPostModeCreateOnly());
    end;
}
