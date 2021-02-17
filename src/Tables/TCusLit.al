pageextension 50132 MyExtensio33n extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("C&ontact")
        {
            action(ImportJson)
            {
                ApplicationArea = All;
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NVInStream: InStream;
                    NOutstream: OutStream;
                    FileName: Text;
                    TempBlob: Codeunit "Temp Blob";
                    ValueText: Text;
                    Jobject: JsonObject;
                    Jobject1: JsonObject;
                    Jobject2: JsonObject;
                    JToken: JsonToken;
                    JToken1: JsonToken;
                    JValue: JsonValue;
                    JArray: JsonArray;
                    JArray1: JsonArray;
                    i: Integer;
                    RollNo: Code[20];
                    StudentRecord: Record Student;
                    CourseRec: Record Course;

                begin
                    CourseRec.DeleteAll();
                    StudentRecord.DeleteAll();
                    ;
                    UPLOADINTOSTREAM('Import', '', ' All Files (*.*)|*.*', FileName, NVInStream);
                    // CopyStream(NOutstream, NVInStream);

                    if not NVInStream.EOS then begin
                        NVInStream.ReadText(ValueText);
                    end;
                    //   ValueText := NOutstream.Write(ValueText);
                    Message(ValueText);
                    if ValueText <> '' then begin
                        if not Jobject.ReadFrom(ValueText) then
                            Error('Invalid Response');


                        Jobject.ReadFrom(ValueText);
                        Jobject.SelectToken('Student', JToken);
                        Jobject.SelectToken('Course', JToken1);
                        JArray := JToken.AsArray();
                        JArray1 := JToken1.AsArray();
                        for i := 0 to JArray.Count - 1 do begin
                            JArray.Get(i, JToken);
                            Jobject1 := JToken.AsObject();
                            RollNo := ValidateJsonToken(Jobject1, 'Roll No.').AsValue().AsText();
                            StudentRecord.Init();
                            StudentRecord."Roll No." := RollNo;
                            StudentRecord.Name := ValidateJsonToken(Jobject1, 'Name').AsValue().AsText();
                            StudentRecord.Insert();
                        end;

                        for i := 0 to JArray1.Count - 1 do begin
                            JArray1.Get(i, JToken1);
                            Jobject2 := JToken1.AsObject();
                            CourseRec.Init();
                            CourseRec.CourseId := ValidateJsonToken(Jobject2, 'CourseId').AsValue().AsText();
                            CourseRec.CourseName := ValidateJsonToken(Jobject2, 'CourseName').AsValue().AsText();
                            CourseRec.Insert();
                        end;

                        //    temp := SelectJsonToken(JSonobject, '$.main.temp').AsValue().AsDecimal();
                        //   country := SelectJsonToken(JSonobject, '$.sys.country').AsValue().AsText();
                        //  City := SelectJsonToken(JSonobject, 'name').AsValue().AsText();
                        if not StudentRecord.IsEmpty then
                            Page.Run(page::"Student List");

                        if not CourseRec.IsEmpty then
                            Page.Run(Page::"Courses List");

                    end;
                end;
            }
        }
        // Add changes to page actions here
    }
    local procedure ValidateJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find token with key: %1', TokenKey);
    end;
    /* local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find token with key: %1', TokenKey);
    end;


    local procedure SelectJsonToken(JsonObject: JsonObject; path: text) JsonToken: JsonToken
    begin
        if not JsonObject.SelectToken(path, JsonToken) then
            Error('Token not find on the path: %1', path);
    end; */
}