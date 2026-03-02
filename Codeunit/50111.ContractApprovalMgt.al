// Codeunit: Contract Approval Management
// Purpose: Handles approval workflow for contracts
codeunit 50111 "Contract Approval Mgt."
{
    TableNo = "Contract Header";

    trigger OnRun()
    begin
    end;

    procedure SendForApproval(var ContractHeader: Record "Contract Header")
    var
        ApprovalEntry: Record "Approval Entry";
        ContractSetup: Record "Contract Setup";
    begin
        ContractSetup.Get();

        // Check if approval required
        if not ContractSetup."Require Approval for New Contracts" then begin
            ContractHeader.Status := ContractHeader.Status::Approved;
            ContractHeader."Approval Status" := ContractHeader."Approval Status"::Approved;
            ContractHeader."Approved By" := UserId;
            ContractHeader."Approved DateTime" := CurrentDateTime;
            ContractHeader.Modify();
            exit;
        end;

        // Check if already pending
        if ContractHeader."Approval Status" = ContractHeader."Approval Status"::Pending then
            Error(AlreadyPendingApprovalErr);

        // Check if already approved
        if ContractHeader."Approval Status" = ContractHeader."Approval Status"::Approved then
            Error(AlreadyApprovedErr);

        // Create approval entry
        ApprovalEntry.Init();
        ApprovalEntry."Table ID" := Database::"Contract Header";
        ApprovalEntry."Document Type" := ApprovalEntry."Document Type"::" ";
        ApprovalEntry."Document No." := ContractHeader."No.";
        ApprovalEntry."Document Date" := WorkDate();
        ApprovalEntry."Due Date" := WorkDate();
        ApprovalEntry."Sender ID" := UserId;
        ApprovalEntry."Approval Code" := 'CONTRACT';
        ApprovalEntry."Amount" := ContractHeader."Total Contract Value";
        ApprovalEntry."Currency Code" := ContractHeader."Currency Code";
        ApprovalEntry."Pending Approvers" := ContractHeader."Total Contract Value";
        ApprovalEntry.Status := ApprovalEntry.Status::Open;
        ApprovalEntry.Insert(true);

        // Update contract
        ContractHeader."Approval Status" := ContractHeader."Approval Status"::Pending;
        ContractHeader.Status := ContractHeader.Status::"Pending Approval";
        ContractHeader.Modify();
    end;

    procedure CancelApproval(var ContractHeader: Record "Contract Header")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        if ContractHeader."Approval Status" <> ContractHeader."Approval Status"::Pending then
            Error(NoPendingApprovalErr);

        // Cancel approval entries
        ApprovalEntry.SetRange("Table ID", Database::"Contract Header");
        ApprovalEntry.SetRange("Document No.", ContractHeader."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.FindSet() then begin
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry.Modify();
            until ApprovalEntry.Next() = 0;
        end;

        // Update contract
        ContractHeader."Approval Status" := ContractHeader."Approval Status"::" ";
        ContractHeader.Status := ContractHeader.Status::Draft;
        ContractHeader.Modify();
    end;

    procedure ApproveContract(var ContractHeader: Record "Contract Header")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        // Find pending approval
        ApprovalEntry.SetRange("Table ID", Database::"Contract Header");
        ApprovalEntry.SetRange("Document No.", ContractHeader."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID", UserId);
        if ApprovalEntry.IsEmpty() then begin
            ApprovalEntry.SetRange("Approver ID");
            if not ApprovalEntry.FindFirst() then
                Error(NoApprovalEntryFoundErr);
        end else
            ApprovalEntry.FindFirst();

        // Approve
        ApprovalEntry.Status := ApprovalEntry.Status::Approved;
        ApprovalEntry."Approved By" := UserId;
        ApprovalEntry."Approval Date" := WorkDate();
        ApprovalEntry.Modify();

        // Check if all approved
        ApprovalEntry.SetRange("Table ID", Database::"Contract Header");
        ApprovalEntry.SetRange("Document No.", ContractHeader."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.IsEmpty() then begin
            // All approved
            ContractHeader."Approval Status" := ContractHeader."Approval Status"::Approved;
            ContractHeader.Status := ContractHeader.Status::Approved;
            ContractHeader."Approved By" := UserId;
            ContractHeader."Approved DateTime" := CurrentDateTime;
            ContractHeader.Modify();
        end;
    end;

    procedure RejectContract(var ContractHeader: Record "Contract Header")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        // Find pending approval
        ApprovalEntry.SetRange("Table ID", Database::"Contract Header");
        ApprovalEntry.SetRange("Document No.", ContractHeader."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.FindSet() then begin
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
                ApprovalEntry."Approved By" := UserId;
                ApprovalEntry."Approval Date" := WorkDate();
                ApprovalEntry.Modify();
            until ApprovalEntry.Next() = 0;
        end;

        // Update contract
        ContractHeader."Approval Status" := ContractHeader."Approval Status"::Rejected;
        ContractHeader.Status := ContractHeader.Status::Draft;
        ContractHeader.Modify();
    end;

    var
        AlreadyPendingApprovalErr: Label 'Contract is already pending approval.';
        AlreadyApprovedErr: Label 'Contract has already been approved.';
        NoPendingApprovalErr: Label 'There is no pending approval to cancel.';
        NoApprovalEntryFoundErr: Label 'No approval entry found.';
}
