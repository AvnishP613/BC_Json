table 60000 "My Header"
{
    fields
    {
        field(1; "No."; Code[10]) { }
        field(2; Description; Text[50]) { }
    }

    keys
    {
        key(PK; "No.") { }
    }

    trigger OnInsert()
    var
        MyHeader: Record "My Header";
    begin
        if "No." = '' then
            if MyHeader.FindLast() then
                "No." := IncStr(MyHeader."No.")
            else
                "No." := 'HEADER001';
    end;
}