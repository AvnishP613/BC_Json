codeunit 50007 ApprovalMgtExt
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendVOforApproval(var VO: Record "Variation Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelVOforApproval(var VO: Record "Variation Order")
    begin
    end;

    procedure CheckVOApprovalsWorklfowEnable(var VO: Record "Variation Order"): Boolean
    begin
        IF NOT IsVODocApprovalsWorkflowEnable(VO) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsVODocApprovalsWorkflowEnable(var VO: Record "Variation Order"): Boolean
    begin
        IF VO.Status <> VO.Status::Open then
            EXIT(false);
        EXIT(WorkFlowManagement.CanExecuteWorkflow(VO, WorkflowEventHandlingExt.RunWorkflowOnSendVOApprovalCode));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        VO: Record "Variation Order";
    begin
        case RecRef.Number of
            Database::"Variation Order":
                begin
                    RecRef.SetTable(VO);
                    ApprovalEntryArgument."Document No." := VO."VO No.";
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure DimensionCreateVendor(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        Dimension: Record Dimension;
        DimensionValue: Record "Dimension Value";

    begin
        if Rec."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, 'Vendor');
            if not Dimension.FindFirst() then begin
                Dimension.Init();
                Dimension.validate(Code, 'Vendor');
                Dimension.Insert(true);
            end;

            DimensionValue.Reset();
            DimensionValue.SetRange("Dimension Code", 'Vendor');
            DimensionValue.SetRange(Code, Rec."No.");
            if not DimensionValue.FindFirst() then begin
                DimensionValue.Init();
                DimensionValue."Dimension Code" := 'Vendor';
                DimensionValue.Code := Rec."No.";
                DimensionValue.Name := Rec."No.";
                DimensionValue.Insert(true);


            end;


        end;
    end;




    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure DimensionCreateCustomer(var Rec: Record Customer; var xRec: Record Customer)
    var
        Dimension: Record Dimension;
        DimensionValue: Record "Dimension Value";

    begin
        if Rec."No." <> '' then begin
            Dimension.Reset();
            Dimension.SetRange(Code, 'Customer');
            if not Dimension.FindFirst() then begin
                Dimension.Init();
                Dimension.validate(Code, 'Customer');
                Dimension.Insert(true);
            end;

            DimensionValue.Reset();
            DimensionValue.SetRange("Dimension Code", 'Customer');
            DimensionValue.SetRange(Code, Rec."No.");
            if not DimensionValue.FindFirst() then begin
                DimensionValue.Init();
                DimensionValue."Dimension Code" := 'Customer';
                DimensionValue.Code := Rec."No.";
                DimensionValue.Name := Rec."No.";
                DimensionValue.Insert(true);


            end;


        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Batch", 'OnPostAllocationsOnBeforeCopyFromGenJnlAlloc', '', false, false)]
    local procedure MyProcedure2(var AllocateGenJournalLine: Record "Gen. Journal Line"; var GenJournalLine: Record "Gen. Journal Line"; var Reversing: Boolean)
    begin
        // GenJournalLine.Allocation :=true;
    end;

   



    var
        WorkFlowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit WorkflowEventHandlingExt;
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.';
}