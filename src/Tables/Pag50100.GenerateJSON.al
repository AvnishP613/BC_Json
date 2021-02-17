page 50100 "Generate JSON"
{

    ApplicationArea = All;
    Caption = 'Generate JSON';
    PageType = List;
    SourceTable = "Generate Json";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sales Order No"; Rec."Sales Order No")
                {
                    ApplicationArea = All;
                }
                field("Input Text"; rec."Input Text")
                {
                    ApplicationArea = All;
                }
                field("Format 1"; Format1Text)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Format 2"; Format2Text)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Format1)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    GJso: Codeunit GenerateJson;
                begin
                    GJso.Format1(Rec);
                end;
            }
            action(Format2)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    GJso: Codeunit GenerateJson;
                begin
                    GJso.Format2(Rec);
                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Format1Text := rec.GetFormat1();
        Format2Text := rec.GetFormat2();

    end;

    var
        Format1Text: Text;
        Format2Text: Text;
}

