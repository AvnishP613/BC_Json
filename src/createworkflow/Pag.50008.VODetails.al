page 50008 "VO Details"
{
    PageType = List;
    SourceTable = "Variation Order";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Blanket Order No."; "Blanket Order No.")
                {
                    Editable = false;
                }
                field("VO No."; "VO No.")
                {
                }

                field("VO Description"; "VO Description")
                {

                }
                field("VO Date"; "VO Date")
                {
                    ApplicationArea = All;
                }
                field("VO Amount"; "VO Amount")
                {
                    trigger OnValidate()
                    var
                        BlanketOrderHdr: Record "Purchase Header";
                    begin
                        BlanketOrderHdr.Reset;
                        BlanketOrderHdr.SetRange(BlanketOrderHdr."Document Type", BlanketOrderHdr."Document Type"::"Blanket Order");
                        BlanketOrderHdr.SetRange(BlanketOrderHdr."No.", "Blanket Order No.");
                        IF BlanketOrderHdr.FindFirst then begin
                            BlanketOrderHdr.CalcFields(BlanketOrderHdr."Approved Variations");
                            BlanketOrderHdr."Revised Contract Price" := BlanketOrderHdr."Original Contract Price" - ABS(BlanketOrderHdr."Approved Variations");
                        end;
                    end;
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                }
                field("Creation date"; "Creation date")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Approved By"; "Approved By")
                {
                    Editable = false;
                }
                field("Approved date"; "Approved date")
                {
                    Editable = false;
                }
                field("VO Calculated"; "VO Calculated")
                {
                    Editable = false;
                }
                field("PC No."; "PC No.")
                {
                    Editable = false;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                Visible = OpenApprovalEntriesExistforCurrUser;
                ApplicationArea = "#Suite";
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Approve;

                trigger OnAction()
                begin
                    ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                end;
            }
            action("Send for Approval")
            {
                ApplicationArea = "#Suite";
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = SendApprovalRequest;
                ToolTip = 'Request approval of the document.';
                Visible = false;

                trigger OnAction()
                var
                    BlanketPHdr: Record "Purchase Header";

                begin
                    TestField(Status, Status::Open);
                    IF CONFIRM('Contract will reopen again.Do you wish to send for approval?', TRUE) THEN begin
                        "VO Status" := true;
                        Status := Status::"Pending Approval";
                        Modify;
                        BlanketPHdr.Reset;
                        BlanketPHdr.SetRange(BlanketPHdr."Document Type", BlanketPHdr."Document Type"::"Blanket Order");
                        BlanketPHdr.SetRange(BlanketPHdr."No.", "Blanket Order No.");
                        BlanketPHdr.SetFilter(BlanketPHdr.Status, '%1', BlanketPHdr.Status::Released);
                        IF BlanketPHdr.FindFirst then begin
                            BlanketPHdr.Status := BlanketPHdr.Status::Open;
                            BlanketPHdr.Modify;
                            Page.Run(509, BlanketPHdr);
                        end;
                    end;
                end;
            }
            action("Request Approval")
            {
                Visible = NOT OpenApprovalEntriesExist And CanRequestApprovalforFlow;
                ApplicationArea = "#Suite";
                Promoted = True;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Image = SendApprovalRequest;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                begin
                    IF ApprovalsMgtCut.CheckVOApprovalsWorklfowEnable(Rec) then
                        ApprovalsMgtCut.OnSendVOforApproval(Rec);
                end;
            }
            action("Cancel Approval Re&quest")
            {
                Visible = CanCancelApprovalforRecord OR CanCancelApprovalforFlow;
                ApplicationArea = "#Suite";
                Promoted = True;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CancelApprovalRequest;
                ToolTip = 'Cancel approval of the document.';

                trigger OnAction()
                begin
                    ApprovalsMgtCut.OnCancelVOforApproval(Rec);
                end;
            }
            action("Release VO")
            {
                ApplicationArea = "#Suite";
                Promoted = True;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Image = ReleaseDoc;
                PromotedOnly = true;
                ToolTip = 'Release the Document.';

                trigger OnAction()
                begin
                    // IF ApprovalsMgtCut.CheckVOApprovalsWorklfowEnable(Rec) then
                    //     Error('This document can only be released when the approval process is complete.')
                    // else begin
                    //     Status := Status::Released;
                    //     Modify;
                    //     Commit;
                    // end;
                    IF Status = Status::Released then
                        exit
                    else begin
                        IF (Status <> Status::Open) then
                            Error('This document can only be released when the approval process is complete.')
                        else
                            IF not ApprovalsMgtCut.IsVODocApprovalsWorkflowEnable(Rec) then begin
                                Status := Status::Released;
                                Modify;
                                Commit;
                            end;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        PH: Record "Purchase Header";
    begin
        FilterGroup(2);
        PH.Reset;
        PH.SetRange("Document Type", PH."Document Type"::"Blanket Order");
        PH.SetRange(PH."No.", "Blanket Order No.");
        FilterGroup(0)
    end;

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistforCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalforRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        WorkflowWebhookMgmt.GetCanRequestAndCanCancel(RecordId, CanRequestApprovalforFlow, CanCancelApprovalforFlow);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        TestField(Status, Status::Open);
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgtCut: Codeunit ApprovalMgtExt;
        WorkflowWebhookMgmt: Codeunit "Workflow Webhook Management";
        OpenApprovalEntriesExistforCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalforRecord: Boolean;
        CanCancelApprovalforFlow: Boolean;
        CanRequestApprovalforFlow: Boolean;

}

