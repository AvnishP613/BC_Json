codeunit 50100 GenerateJson
{






    procedure Format1(var GJson: Record "Generate Json")
    var

        JObject: JsonObject;
        Jarray: JsonArray;
        JBranch: JsonObject;
        JLineObj: JsonObject;
        JsonText: Text;
        Instream: InStream;
        Outstream: OutStream;
        SILine: Record "Sales Line";
        SIHeader: Record "Sales Header";
    begin
        GJson.TestField("Sales Order No");

        Clear(Jobject);
        Clear(JArray);
        Clear(JBranch);
        Clear(JLineObj);
        SIHeader.get(SIHeader."Document Type"::Order, GJson."Sales Order No");
        if SIHeader.FindFirst() then
            Jobject.Add('DocumentNo', SIHeader."No.");
        //Address Branch Details --------Start
        JBranch.Add('Name', SIHeader."Sell-to Customer Name");
        JBranch.Add('Add', SIHeader."Sell-to Address");
        //Address Branch Details ---------End
        SILine.Reset();
        SILine.SetRange("Document No.", SIHeader."No.");
        SILine.FindSet();
        //Line Details --Start
        JLineObj.Add('ItemNo', '');
        JLineObj.Add('Qty', '');
        repeat
            JLineObj.Replace('ItemNo', SILine."No.");
            JLineObj.Replace('Qty', SILine.Quantity);
            JArray.Add(JLineObj);
        //Line Details -------End
        until SILine.Next() = 0;
        //Creating Json ---Start
        Jobject.Add('AddressDetails', JBranch);
        Jobject.Add('ItemDetails', JArray);
        Jobject.WriteTo(JsonText);
        Message('%1', JsonText);
        //Creating Json --END
        GJson.SetFormat1(JsonText);
        //   GJson."Format 1".CreateOutStream(Outstream);
        //  Outstream.WriteText(JsonText);
        // GJson.Modify();
        //        //GJson."Format 1".CreateInStream(Instream);
        //      //Instream.


    end;



    procedure Format2(var GJson: Record "Generate Json")
    var

        JObject: JsonObject;
        Jarray: JsonArray;
        Jarray2: JsonArray;
        JBranch: JsonObject;
        JLineObj: JsonObject;
        JsonText: Text;
        Instream: InStream;
        Outstream: OutStream;
        SILine: Record "Sales Line";
        SIHeader: Record "Sales Header";
    begin
        GJson.TestField("Sales Order No");
        Clear(Jobject);
        Clear(JArray);
        Clear(JBranch);
        Clear(JLineObj);
        SIHeader.get(SIHeader."Document Type"::Order, GJson."Sales Order No");
        if SIHeader.FindFirst() then
            Jobject.Add('DocumentNo', SIHeader."No.");
        //Address Branch Details --------Start
        JBranch.Add('Name', SIHeader."Sell-to Customer Name");
        JBranch.Add('Add', SIHeader."Sell-to Address");
        //Address Branch Details ---------End
        SILine.Reset();
        SILine.SetRange("Document No.", SIHeader."No.");
        SILine.FindSet();
        //Line Details --Start
        JLineObj.Add('ItemNo', '');
        JLineObj.Add('Qty', '');
        repeat
            JLineObj.Replace('ItemNo', SILine."No.");
            JLineObj.Replace('Qty', SILine.Quantity);
            JArray.Add(JLineObj);
        //Line Details -------End
        until SILine.Next() = 0;
        //Creating Json ---Start
        // Jarray.WriteTo()
        Jobject.Add('AddressDetails', JBranch);
        Jobject.Add('ItemDetails', JArray);
        //  Jobject.WriteTo(JsonText);
        Jarray2.Add(JObject);
        Jarray2.WriteTo(JsonText);
        Message('%1', JsonText);
        //Creating Json --END

        GJson.SetFormat2(JsonText);
        //   GJson."Format 2".CreateOutStream(Outstream);
        //   Outstream.WriteText(JsonText);
        //   GJson.Modify();
        //        //GJson."Format 1".CreateInStream(Instream);
        //      //Instream.


    end;

    procedure ShowDataFormat1(var GJson: Record "Generate Json")
    var
        Instream: InStream;
        Outstream: OutStream;
        JsonText: Text;
    begin
        GJson.TestField("Sales Order No");
        if GJson."Format 1".HasValue then
            GJson.CalcFields("Format 1")
        else
            Error('No Data Found');



        GJson."Format 1".CreateInStream(Instream);
        Instream.Read(JsonText);

        message(JsonText);
    end;



    procedure ShowDataFormat2(var GJson: Record "Generate Json")
    var
        myInt: Integer;
        Instream: InStream;
        Outstream: OutStream;
        JsonText: Text;
    begin
        GJson.TestField("Sales Order No");
        if GJson."Format 2".HasValue then
            GJson.CalcFields("Format 2")
        else
            Error('No Data Found');

        GJson."Format 2".CreateInStream(Instream);
        Instream.Read(JsonText);

        message(JsonText);

    end;

}



