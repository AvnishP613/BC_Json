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



    local procedure CreateTextFile(var SInvH: Record "Sales Invoice Header")
    var
        // Sinvh: Record "Sales Invoice Header";
        sinvline: Record "Sales Invoice Line";
        Outstream1: OutStream;
        Instream1: InStream;
        FileName: Text;
        Ch: Char;
        ChNew: Char;
        Tab: Text[1];
        LineCount: Integer;
        CRLF: Text[2];
        //     CRLF: Text[2];
        TempBLOB: Codeunit "Temp Blob";
        Fileva: File;
        InbSalesDocHeader: Record "Sales Invoice Header";
        InbSalesDocumentLine: Record "Sales Invoice Line";

    begin
        //Fileva.TextMode
        FileName := 'Testing.txt';

        Ch := 9;
        chnew := 13;
        Tab := Format(Ch);
        CRLF[1] := 13;
        CRLF[2] := 10;

        if InbSalesDocHeader.FindFirst() then;


        TempBLOB.CreateOutStream(Outstream1);//, TextEncoding::Windows);
        OutStream1.WriteTexT(InbSalesDocHeader."No." + Tab + InbSalesDocHeader."Sell-to Customer No." + Tab + InbSalesDocHeader."Sell-to Customer Name" + Tab +
           InbSalesDocHeader."Sell-to County");
        //CSA.GS 06/08/2018 write blank line between segments>>
        OutStream1.WriteText(CRLF);
        OutStream1.WriteText(CRLF);
        //   OutStream1.WriteTexT('');
        // OutStream1.WriteTexT('');
        //     //<<
        // InbSalesDocumentLine.SetRange("Document No.", InbSalesDocHeader."No.");
        if InbSalesDocumentLine.FindFirst then
            repeat
                //             // LINES
                OutStream1.WriteTexT(InbSalesDocumentLine."No." + Tab + InbSalesDocumentLine.Description + Tab + InbSalesDocumentLine."Document No." + Tab + format(InbSalesDocumentLine.Quantity));
                // Outstream1.WriteText('');
                // OutStream1.WriteText(CRLF);
                // OutStream1.WriteText(ChNew);
                LineCount := LineCount + 1;

            until InbSalesDocumentLine.Next = 0;

        //     //CSA.GS 06/08/2018>>
        OutStream1.WriteText(CRLF);

        // OutStream1.WriteTexT('');
        //     //<<


        //     // FOOTER
        Outstream1.WriteTexT('F' + Tab + Format(LineCount + 2));   //060920

        TempBLOB.CreateInStream(Instream1);

        DownloadFromStream(Instream1, '', '', '', FileName)










    end;



}



