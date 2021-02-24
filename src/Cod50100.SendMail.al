codeunit 50112 SendMail
{

    procedure GenerateBarCode(QRRec: record "QR Code"; QRCodeText: text)
    var
        Token: Label '2CuyVoMChUGjbrwbP6ajSU618U9mNYmhmzhNm2oc';
        URL: Label 'https://api.beyondbarcodes.de/v1/qr/%1?height=600';
        HttpClient: HttpClient;
        HttpH: HttpHeaders;
        ResMsg: HttpResponseMessage;
        ReqMsg: HttpRequestMessage;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ReadASText: Text;
        Instr: InStream;
        Outstr: OutStream;
        URLT: Text;
    //https://api.beyondbarcodes.de/v1/barcode/CODE128/beyondbarcodes?token=YOUR-TOKEN&height=100
    begin
        // Request.
        //  URLT := 'https://api.beyondbarcodes.de/v1/qr/1234?height=300';
        //  HttpH.Add('Accept', 'image/png');
        Request.GetHeaders(HttpH);
        HttpH.Add('token', Token);

        //Request.SetRequestUri(URLT);
        Request.SetRequestUri(StrSubstNo(URL, QRCodeText));
        Request.Method('GET');

        if not HttpClient.send(Request, Response) then
            Error('Call failed');

        response.content.ReadAs(Instr);
      //  Response.Content.ReadAs(ReadASText);
        //  Message(Format(ReadASText));
        //  clear(TenantMedia);
        if Response.IsSuccessStatusCode then begin
            QRRec."QR Code".CreateOutStream(Outstr);
            CopyStream(Outstr, Instr);
            QRRec.Modify();
        end

        //TenantMedia.Content.CreateOutStream(Outstr);
        //copystream(outstr, Instr);


    end;

    /*        [EventSubscriber(ObjectType::Table, 38, 'OnBeforeValidateEvent', 'Location Code', false, false)]
        local procedure SetValidationtohide(var xRec: Record "Purchase Header"; var Rec: Record "Purchase Header"; CurrFieldNo: Integer)
        var

            Location: Record Location;
        begin
            //   Message(format(CurrFieldNo));
            // if CurrFieldNo <> 0 then begin
            if CurrFieldNo = rec.FieldNo("Location Code") then begin
                Rec.SetHideValidationDialog(true);

            end;
     */




    /* local procedure GenerateBarcode(ItemNo: Text[20])
    var
      ClientHttp: HttpClient;
      Request: HttpRequestMessage;
      Response: HttpResponseMessage;
      Instr: InStream;
      Method: text;
      Outstr: Outstream;
      TypeHelper: Codeunit "Type Helper";
    begin
      Method := (STRSUBSTNO('https://barcode.tec-it.com/barcode.ashx?data='+TypeHelper.UrlEncode(ItemNo)+'&amp;code=Code128&amp;translate- 
      esc=on&amp;imagetype=Jpg'));
      Request.SetRequestUri(Method);

      if not clienthttp.send(Request, Response) then
        Error('Call failed');

      response.content.ReadAs(Instr);
      clear(TenantMedia);
      TenantMedia.Content.CreateOutStream(Outstr);
      copystream(outstr,Instr);
    end;




    procedure CreateBarcode(ItemNo : Text) : Text 
         var 
            Base64Convert: Codeunit "Base64 Convert";  
            TempBlob: Codeunit "Temp Blob";
            TypeHelper: Codeunit "Type Helper";  
            client: HttpClient;  
            response: HttpResponseMessage;  
            InStr: InStream;  

        begin  
            client.Get('https://barcode.tec-it.com/barcode.ashx?data=' + TypeHelper.UrlEncode(BarCode) + '&amp;code=Code128&amp;translate-esc=on&amp;imagetype=Jpg', response);  
            TempBlob.CreateInStream(InStr);  
            response.Content().ReadAs(InStr);  
            BarCode := Base64Convert.ToBase64(InStr);  
            exit(BarCode); 
        end; 


     */









    //https://www.waldo.be/2020/10/28/upgrade-to-business-central-v17-part-1-the-workflow/
    //https://tisski.com/updates/business-central-enhanced-email-capabilities/
    //
    procedure SendSMTPmail()
    var
        AttachmentFilePathLocal: Text[1024];
        CCList: List of [Text];
        Ins: InStream;
        Receiver: List of [Text];
        Pos: Integer;
        SubStrCheck: Code[20];
        TLen: Integer;
        ToRecipient: Text[1020];
        Recipient: Text[1020];
        StrPos: Integer;
        EmailID: Text;
        SMTPMail: Codeunit "SMTP Mail";
        Smtp: Record "SMTP Mail Setup";
        hyperlinkText: Text;
        RecRef: RecordRef;
        Link2: Text;
        SH: Record "Sales Header";

    begin
        Smtp.get;
        // EmailID := 'a.pandey@direction.biz;avnishpandey329@gmail.com;s.bharti@direction.biz;s.masurekar@direction.biz';
        EmailID := 'avnishpandey329@gmail.com';

        Receiver.Add(EmailID);
        Recipient := EmailID;
        SubStrcheck := ';';
        TLen := STRLEN(Recipient);
        Pos := STRPOS(Recipient, SubStrcheck);
        //  IF Pos <> 0 THEN begin
        //    WHILE Pos <> 0 DO BEGIN
        //      ToRecipient := COPYSTR(Recipient, 1, Pos - 1);
        //       Clear(Receiver);
        //         Receiver.Add(ToRecipient);
        SMTPMail.CreateMessage('Umang', Smtp."User ID", Receiver, 'Test', '');

        //PH.SetRange(CreatedUserId, usersetup."User ID");
        //      SmtpMail.AppendBody('<a href=' + GETURL(CurrentClientType, COMPANYNAME, ObjectType::Page, 9307, PH) + '</a>');
        //  SLEEP(200);
        // PH.SetRange(CreatedUserId, usersetup."User ID");
        //  RecRef.Open(Database::"Purchase Header");
        // RecRef.GetTable(SH);
        Link2 := '<a href=' + GETURL(CurrentClientType, COMPANYNAME, ObjectType::Page, 9305, SH) + '>' + 'Click this link to open Page</a>';
        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody('<br>');
        SmtpMail.AppendBody(Link2);


        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody('<br>');

        //    hyperlinkText := '<a href=' + GETURL(CURRENTCLIENTTYPE, COMPANYNAME) + '?page=9305&personalization=9305&mode=View' + '>' + 'Click this link to open Page</a>';
        // PH.SetRange(CreatedUserId, usersetup."User ID");
        //     SmtpMail.AppendBody(hyperlinkText);

        if SMTPMail.Send() then begin


            COMMIT;   //060920
        end
        else
            Message(GetLastErrorText);
        //      end;
        //    end;
    end;

    [EventSubscriber(ObjectType::Table, database::TEST, 'OnBeforeValidateEvent', 'Entry', false, false)]
    local procedure MyProcedursse(CurrFieldNo: Integer; var Rec: Record TEST)
    begin
        Error('rrrrr');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lines Instruction Mgt.", 'OnAfterSetSalesLineFilters', '', false, false)]
    local procedure MyProcedure(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        // SalesLine.SetRange(Quantity);
        // SalesLine.SetRange(Description, 'Test');
        // exit;
    end;
    /* 
        procedure SendSMTPmail()
        var
            AttachmentFilePathLocal: Text[1024];
            CCList: List of [Text];
            RecList: Text;
            Ins: InStream;
            Receiver: List of [Text];
            SMTPMail: Codeunit "SMTP Mail";
            Smtp: Record "SMTP Mail Setup";
            TestList: List of [Text];
            StrPos: Integer;
            EmailID: Text;
            EmailLength: Integer;
            pOS: Integer;
            ToMail: Text;
            CCEmail: Text;
            i: Integer;
            TotalMailCount: Integer;
            TotalMailCount1: Integer;
            PrevPosition: Integer;
            CurrentPosition: Integer;
        begin



            Clear(CCList);
            Clear(Receiver);

            Smtp.Get();

            i := 1;
            EmailID := 'a.pandey@direction.biz;avnishpandey329@gmail.com;s.bharti@direction.biz;s.masurekar@direction.biz';
            //EmailID :=  'a.pandey@direction.biz;';
            EmailLength := STRLEN(EmailID);
            MESSAGE(FORMAT(EmailLength));
            pOS := STRPOS(EmailID, ';');

            IF EmailID <> '' THEN BEGIN
                IF (pOS <> 0) AND (EmailLength > pOS) THEN BEGIN
                    ToMail := COPYSTR(EmailID, 1, pOS - 1);
                    FOR i := 1 TO EmailLength DO BEGIN
                        IF (COPYSTR(EmailID, i, 1) IN [';']) THEN BEGIN
                            TotalMailCount += 1;
                            MESSAGE('Position %1,Current %2 and Prev %3 and %4', FORMAT(i), CurrentPosition, PrevPosition, TotalMailCount);

                        END;
                    END;
                    FOR i := 1 TO EmailLength DO BEGIN
                        IF (COPYSTR(EmailID, i, 1) IN [';']) THEN BEGIN
                            TotalMailCount1 += 1;
                            IF PrevPosition = 0 THEN
                                PrevPosition := 1
                            ELSE
                                PrevPosition := CurrentPosition + 1;
                            CurrentPosition := i;
                            CLEAR(ToMail);
                            ToMail := COPYSTR(EmailID, PrevPosition, CurrentPosition - PrevPosition);
                            Receiver.Add(ToMail);
                            MESSAGE('Position %1,Current %2 and Prev %3 and %4 and to mail %5', FORMAT(i), CurrentPosition, PrevPosition, TotalMailCount1, ToMail);
                            IF (TotalMailCount1 = TotalMailCount) AND (STRLEN(EmailID) > CurrentPosition) THEN BEGIN
                                ToMail := COPYSTR(EmailID, CurrentPosition + 1, STRLEN(EmailID));
                                Receiver.Add(ToMail);
                                MESSAGE('Position %1,Current %2 and Prev %3 and %4 and to mail %5', FORMAT(i), i + 1, PrevPosition, TotalMailCount1, ToMail);
                            END;
                        END;

                    END;
                END
                ELSE begin
                    ToMail := EmailID;
                    Receiver.Add(ToMail);
                end;
            END;
            //  MESSAGE('To %1 and CC Mail %2', ToMail, CCEmail);



            //  Receiver.AddRange(RecList);
            //SMTPMail.CreateMessage(eMailSetup."Default Sender Name", eMailSetup."Default Sender Email Address", Receiver, eMailQueueHeader.Subject, '');

            SMTPMail.CreateMessage('Umang', Smtp."User ID", Receiver, 'Test', '');


            //  SLEEP(200);
            if CCEmail <> '' then
                CCList.Add(CCEmail);
            SMTPMail.AddCC(CCList);


            if SMTPMail.Send() then begin


                COMMIT;   //060920
            end
            else
                Message(GetLastErrorText);

        end; */

    /* 
        local procedure SendSMTPmail(eMailQueueHeader: Record "eMail Queue Header")
        var
            AttachmentFilePathLocal: Text[1024];
            CCList: List of [Text];
            Ins: InStream;
            Receiver: List of [Text];
            Pos: Integer;
            SubStrCheck: Code[20];
            TLen: Integer;
            ToRecipient: Text[1020];
            Recipient: Text[1020];
        begin
            Clear(CCList);
            Clear(Receiver);
            SubStrCheck := ';';
            Recipient := '';
            TLen := 0;
            Pos := 0;
            ToRecipient := '';




            CCList.Add(eMailQueueHeader.CC);
            Receiver.Add(eMailQueueHeader.Recipient);
            Recipient := eMailQueueHeader.Recipient;
            SubStrcheck := ';';
            TLen := STRLEN(Recipient);
            Pos := STRPOS(Recipient, SubStrcheck);
            IF Pos <> 0 THEN begin
                WHILE Pos <> 0 DO BEGIN
                    ToRecipient := COPYSTR(Recipient, 1, Pos - 1);
                    Clear(Receiver);
                    Receiver.Add(ToRecipient);
                    //

                    END;



                    //
                    Recipient := COPYSTR(Recipient, Pos + 1, TLen - Pos);
                    Pos := STRPOS(Recipient, SubStrcheck);

                    if (Pos = 0) and (Recipient <> '') then begin
                        Clear(Receiver);
                        Receiver.Add(Recipient);

                    end;



                end;
            end;
        end;


    }
     */
}