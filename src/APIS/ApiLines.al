page 60001 MyAPILines
{
    PageType = ListPart;
    SourceTable = "My Line";
    DelayedInsert = true;
    AutoSplitKey = true;
    PopulateAllFields = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field(id; Format(SystemId, 0, 4).ToLower()) { }
                field(headerNo; "Header No.") { }
                field(headerId; "Header Id") { }
                field(lineNo; "Line No.") { }
                field(description; Description) { }
            }
        }
    }

    var
        IsDeepInsert: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        MyHeader: Record "My Header";
        MyLine: Record "My Line";
    begin
        if IsDeepInsert then begin
            MyHeader.GetBySystemId("Header Id");
            "Header No." := MyHeader."No.";
            MyLine.SetRange("Header No.", "Header No.");
            if MyLine.FindLast() then
                "Line No." := MyLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        MyHeader: Record "My Header";
    begin
        IsDeepInsert := IsNullGuid("Header Id");
        if not IsDeepInsert then begin
            MyHeader.GetBySystemId("Header Id");
            "Header No." := MyHeader."No.";
        end;
    end;
}