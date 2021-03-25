codeunit 50008 WorkflowEventHandlingExt
{
    trigger OnRun()
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        SendVOReq: TextConst ENU = 'Approval Request for Variation Order is requested', ENG = 'Approval Request for Variation Order is requested';
        CancelVOReq: TextConst ENU = 'Approval Request for Variation Order is cancelled', ENG = 'Approval Request for Variation Order is cancelled';
        AppReqVO: TextConst ENU = 'Approval Request for Variation Order is approved', ENG = 'Approval Request for Variation Order is approved';
        RejReqVO: TextConst ENU = 'Approval Request for Variation Order is rejected', ENG = 'Approval Request for Variation Order is rejected';
        DelReqVO: TextConst ENU = 'Approval Request for Variation Order is delegated', ENG = 'Approval Request for Variation Order is delegated';
        SendForPendAppTxt: TextConst ENU = 'Status of Variation Order changed to Pending approval', ENG = 'Status of Variation Order changed to Pending approval';
        ReleaseVOTxt: TextConst ENU = 'Release Variation Order', ENG = 'Release Variation Order';
        ReOpenVOTxt: TextConst ENU = 'ReOpen Variation Order', ENG = 'ReOpen Variation Order';
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowFlowEventHandlingCust: Codeunit WorkflowEventHandlingExt;
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.';
        VOWorkflowCategorytxt: TextConst ENU = 'VO';
        VOWorkflowCategoryDesctxt: TextConst ENU = 'Variation Order';
        VOApprWorkflowCodeTxt: TextConst ENU = 'VO Document';
        VOApprWorkflowDescTxt: TextConst ENU = 'VO Approval Workflow';

    procedure RunWorkflowOnSendVOApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendVOApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ApprovalMgtExt, 'OnSendVOforApproval', '', true, true)]
    procedure RunWorkflowOnSendVOApproval(var VO: Record "Variation Order")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendVOApprovalCode, VO);
    end;

    //Canacellation start
    procedure RunWorkflowOnCancelVOApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelVOApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ApprovalMgtExt, 'OnCancelVOforApproval', '', true, true)]
    procedure RunWorkflowOnCancelVOApproval(var VO: Record "Variation Order")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelVOApprovalCode, VO);
    end;
    //cancellation end

    procedure RunWorkflowOnApproveVOApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveVOApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    procedure RunWorkflowOnApproveVOApproval(var ApprovalEntry: Record "Approval Entry")
    var
        VO1: Record "Variation Order";
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveVOApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        // VO1.Reset;
        // VO1.SetRange(VO1."VO No.", ApprovalEntry."Document No.");
        // IF VO1.FindFirst then begin
        //     VO1."Approved By" := ApprovalEntry."Approver ID";
        //     VO1."Approved date" := Today;
        //     VO1.Modify;
        // end;
    end;

    procedure RunWorkflowOnRejectVOApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectVOApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    procedure RunWorkflowOnRejectVOApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectVOApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure RunWorkflowOnDelegateVOApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateVOApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    procedure RunWorkflowOnDelegateVOApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateVOApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure SetStatusToPendingApprovalCodeVO(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApprovalVO'));
    end;

    procedure SetStatusToPendingApprovalVO(var Variant: Variant)
    var
        RecRef: RecordRef;
        VO: Record "Variation Order";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Variation Order":
                begin
                    RecRef.SetTable(VO);
                    VO.Validate(VO.Status, VO.Status::"Pending Approval");
                    VO.Modify();
                    Variant := VO;
                end;
        end;
    end;

    procedure ReleaseVOCode(): Code[128]
    begin
        exit(UpperCase('ReleaseVO'));
    end;

    procedure ReleaseVO(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        VO: Record "Variation Order";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReleaseVO(Variant);
                end;
            DATABASE::"Variation Order":
                begin
                    RecRef.SetTable(VO);
                    VO.Validate(VO.Status, VO.Status::Released);
                    VO.Validate("Approved date", Today);
                    VO.Validate("Approved By", UserId);
                    VO.Modify();
                    Variant := VO;
                end;
        end;
    end;

    procedure ReOpenVOCode(): Code[128]
    begin
        exit(UpperCase('ReOpenVO'));
    end;

    procedure ReOpenVO(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        VO: Record "Variation Order";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpenVO(Variant);
                end;
            DATABASE::"Variation Order":
                begin
                    RecRef.SetTable(VO);
                    VO.Validate(VO.Status, VO.Status::Open);
                    VO.Modify();
                    Variant := VO;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddVOEventToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendVOApprovalCode(), Database::"Variation Order", SendVOReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelVOApprovalCode(), Database::"Variation Order", CancelVOReq, 0, false);   //Cancellation
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveVOApprovalCode(), Database::"Approval Entry", AppReqVO, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectVOApprovalCode(), Database::"Approval Entry", RejReqVO, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegateVOApprovalCode(), Database::"Approval Entry", DelReqVO, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    procedure AddVORespToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodeVO(), 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseVOCode(), 0, ReleaseVOTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenVOCode(), 0, ReOpenVOTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForVO(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of
                SetStatusToPendingApprovalCodeVO():
                    begin
                        SetStatusToPendingApprovalVO(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseVOCode():
                    begin
                        ReleaseVO(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenVOCode():
                    begin
                        ReOpenVO(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;

    //Setup VO workflow
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(VOWorkflowCategorytxt, VOWorkflowCategoryDesctxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(Database::"Variation Order", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    //create company error hence commented start
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    // local procedure OnInsertWorkflowTemplates()
    // var
    //     ApprovalEntry: Record "Approval Entry";
    // begin
    //     InsertVOApprovalWorkflowTemplate();
    // end;
    //create company error hence commented end

    local procedure InsertVOApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, VOApprWorkflowCodeTxt, VOApprWorkflowDescTxt, VOWorkflowCategorytxt);
        InsertVOApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertVOApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingExt: Codeunit WorkflowEventHandlingExt;
        WorkflowResponseHandlingExt: Codeunit "Workflow Response Handling";
        VO: Record "Variation Order";
    begin
        WorkflowSetup.PopulateWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildVOTypeConditions(VO.Status::Open),
            WorkflowEventHandlingExt.RunWorkflowOnSendVOApprovalCode,
            BuildVOTypeConditions(VO.Status::"Pending Approval"),
            WorkflowEventHandlingExt.RunWorkflowOnCancelVOApprovalCode,
            WorkflowStepArgument, true);
    end;

    local procedure BuildVOTypeConditions(status: Integer): Text
    var
        VO: Record "Variation Order";
        VOTypeConditionTxt: Text[100];
    begin
        VO.Setrange(VO.Status, status);
        EXIT(StrSubstNo(VOTypeConditionTxt, WorkflowSetup.Encode(VO.GetView(false))))
    end;


}