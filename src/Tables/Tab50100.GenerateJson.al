table 50100 "Generate Json"
{
    Caption = 'Generate Json';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order No"; Code[20])
        {
            Caption = 'Sales Order No';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = filter(Order));
        }
        field(2; "Format 1"; Blob)
        {
            Caption = 'Format 1';
            DataClassification = CustomerContent;
        }
        field(5; "Input Text"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Format 2"; Blob)
        {
            Caption = 'Format 2';
            DataClassification = CustomerContent;
        }
        field(4; "Format 3"; Blob)
        {
            Caption = 'Format 3';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Sales Order No")
        {
            Clustered = true;
        }
    }

    procedure SetFormat1(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Format 1");
        "Format 1".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetFormat1(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Format 1");
        "format 1".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetFormat2(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Format 2");
        "Format 2".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetFormat2(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Format 2");
        "format 2".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

}
