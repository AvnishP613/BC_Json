pageextension 50105 VendorList extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Purchases")
        {


            action(RunData)
            {
                ApplicationArea = All;
                Image = ReopenCancelled;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    MyFieldRef: FieldRef;
                    CustomerRecref: RecordRef;
                    i: Integer;
                    AllobJ: Record AllObj;
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

                    i2: Integer;
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
                        AllobJ.SetRange("Object Type", AllobJ."Object Type"::Table);
                        AllobJ.SetFilter("Object Name", 'Student|Course');
                        if AllobJ.FindFirst() then
                            repeat
                                Clear(JToken);
                                Clear(Jobject1);
                                Clear(i2);
                                Clear(JArray);

                                if Jobject.SelectToken(AllobJ."Object Name", JToken) then begin
                                    JArray := JToken.AsArray();
                                    Clear(CustomerRecref);
                                    Clear(MyFieldRef);
                                    CustomerRecref.OPEN(AllobJ."Object ID");
                                    for i := 0 to JArray.Count - 1 do begin
                                        JArray.Get(i, JToken);
                                        Jobject1 := JToken.AsObject();

                                        CustomerRecref.INIT;
                                        FOR i2 := 1 TO CustomerRecref.FIELDCOUNT DO BEGIN
                                            MyFieldRef := CustomerRecref.FIELDINDEX(i2);
                                            Clear(JValue);
                                            JValue := ValidateJsonToken(Jobject1, MyFieldRef.Name).AsValue();
                                            if not JValue.IsNull then
                                                MyFieldRef.Validate(JValue);
                                            //   Message(MyFieldRef.Name);
                                        end;

                                        CustomerRecref.INSERT;

                                    end;
                                    CustomerRecref.Close();
                                end;
                            until AllobJ.Next() = 0;

                        Page.Run(Page::"Student List");
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
}