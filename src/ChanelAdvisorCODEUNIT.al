// /* codeunit 50000 "Channel Advisor Integration"
// {
//     trigger OnRun()
//     begin
//         //        webservicecheck();
//     end;

//     local procedure webservicecheck()
//     var
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         HttpsContent: HttpContent;
//         RequestHeader: HttpHeaders;
//     begin//Rest
//         CRLF[1] := 13;
//         CRLF[2] := 10;
//         URL := StrSubstNo('https://api.channeladvisor.com/oauth2/authorize');
//         InputText := Lable1 + CRLF + Lable2 + CRLF + Label3 + CRLF + Label4 + CRLF + Label5;
//         HttpsContent.WriteFrom(InputText);
//         HttpsContent.GetHeaders(RequestHeader);
//         RequestHeader.Remove('Content-Type');
//         RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
//         HttpClient.SetBaseAddress(URL);
//         IF not HttpClient.Post(URL, HttpsContent, ResponseMessage) THEN BEGIN
//             Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//         end
//         else begin
//             if ResponseMessage.IsSuccessStatusCode() then begin
//                 ResponseMessage.Content().ReadAs(InputText);
//                 Message('Success %1', InputText);
//             end;
//             if not ResponseMessage.IsSuccessStatusCode then begin
//                 ResponseMessage.Content.ReadAs(InputText);
//                 error('The web service returned an error message:\\' +
//                       'Status code: %1\' +
//                       'Description: %2\' + 'Reason %3',
//                       ResponseMessage.HttpStatusCode,

//             ResponseMessage.ReasonPhrase, InputText);
//                 Message(InputText);

//             end;
//         end;
//     end;


//     procedure AutheticationRun()
//     var
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         HttpsContent: HttpContent;
//         RequestHeader: HttpHeaders;
//     begin



//         CRLF[1] := 13;
//         CRLF[2] := 10;
//         AuthText2 := NewDocText;
//         InputText := AuthLabel + '&' + 'code = ' + AuthText2 + '&' + Label5;

//         Message('Authentication Text %1', AuthText2);
//         URL := StrSubstNo('https://api.channeladvisor.com/oauth2/token?') + InputText;
//         //  InputText := AuthLabel + CRLF + 'code = ' + AuthText2 + CRLF + Label5;

//         Message(InputText);
//         Message(URL);
//         //        HttpsContent.WriteFrom(InputText);
//         HttpsContent.GetHeaders(RequestHeader);
//         RequestHeader.Remove('Content-Type');
//         HttpClient.DefaultRequestHeaders().Remove('Authorization');
//         RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
//         AuthText := StrSubstNo('%1:%2', ApplicationID, ClientSercret);
//         TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
//         HttpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));
//         HttpClient.SetBaseAddress(URL);
//         IF not HttpClient.Post(URL, HttpsContent, ResponseMessage) THEN BEGIN
//             Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//         end
//         else begin
//             if ResponseMessage.IsSuccessStatusCode() then begin
//                 ResponseMessage.Content().ReadAs(InputText);
//                 Message('Success %1', InputText);
//             end;
//             if not ResponseMessage.IsSuccessStatusCode then
//                 ResponseMessage.Content.ReadAs(InputText);
//             Message('The web service returned an error message:\\' +
//                   'Status code: %1\' +
//                   'Description: %2\' + 'Reason %3',
//                   ResponseMessage.HttpStatusCode,

//         ResponseMessage.ReasonPhrase, InputText);
//             Message(InputText);


//         end;


//     end;

//     procedure RefreshToken()
//     var
//         Base64Text: Text;
//         RefreshToken: Text;
//         JsonObject1: JsonObject;
//         JsonToken1: JsonToken;
//         HttpsContent: HttpContent;
//         RawText: text;
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         RequestHeader: HttpHeaders;
//     begin
//         AutheticationToken := '';


//         //  RefreshToken := 'f_f9YFEYemzyx2n6KI4z917PzUr1lbw4-Zq3YtU04YY';
//         RefreshToken := CAdvisorSetup."Refresh Token";
//         //URL := StrSubstNo('https://api.channeladvisor.com/oauth2/token');
//         URL := StrSubstNo(CAdvisorSetup."Token URL");

//         RawText := 'grant_type=refresh_token&refresh_token=' + RefreshToken;

//         //  URL := 'https://api.channeladvisor.com/oauth2/token?grant_type=refresh_token&refresh_token=f_f9YFEYemzyx2n6KI4z917PzUr1lbw4-Zq3YtU04YY';
//         URL := DelChr(URL, '=', '');
//         HttpsContent.WriteFrom(RawText);
//         HttpsContent.GetHeaders(RequestHeader);
//         RequestHeader.Remove('Content-Type');
//         HttpClient.DefaultRequestHeaders().Remove('Authorization');
//         RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
//         // AuthText := StrSubstNo('%1:%2', 'biocgvilghpyl4rxsmmuiizmpxgiypfc', '3lQGd8bm3EyKxdQKF3Pr2g');
//         AuthText := StrSubstNo('%1:%2', CAdvisorSetup."Application ID", CAdvisorSetup."Shared Secret");

//         //  Base64Text := ConvertTo64.ToBase64(AuthText);
//         // Message('Base 64 :%1', Base64Text);
//         // HttpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Basic %1', Base64Text));
//         //  AuthText := StrSubstNo('%1:%2', ApplicationID, ClientSercret);
//         TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
//         HttpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));

//         HttpClient.SetBaseAddress(URL);
//         IF not HttpClient.Post(URL, HttpsContent, ResponseMessage) THEN BEGIN
//             Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//         end
//         else begin
//             if ResponseMessage.IsSuccessStatusCode() then begin
//                 ResponseMessage.Content().ReadAs(InputText);

//             end;
//             if not ResponseMessage.IsSuccessStatusCode then begin
//                 ResponseMessage.Content.ReadAs(InputText);
//                 Message('The web service returned an error message:\\' +
//                       'Status code: %1\' +
//                       'Description: %2\' + 'Reason %3',
//                       ResponseMessage.HttpStatusCode,

//             ResponseMessage.ReasonPhrase, InputText);
//                 Message(InputText);

//             end;


//         end;
//         JsonObject1.ReadFrom(InputText);
//         JsonObject1.Get('access_token', JsonToken1);
//         AutheticationToken := JsonToken1.AsValue().AsText()

//     end;

//     procedure CreateProduct(var ItemRec: Record Item)
//     var
//         JsonObject1: JsonObject;
//         JsonToken1: JsonToken;
//         ID: Code[30];
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         HttpsContent: HttpContent;
//         RequestHeader: HttpHeaders;

//     begin
//         ItemRec.TestField(Published, false);

//         CAdvisorSetup.FindFirst();
//         GenerateJsonProduct(ItemRec);
//         RefreshToken();
//         // if not Confirm('Auth %1', false, AutheticationToken) then
//         //   exit;
//         if AutheticationToken <> '' then begin
//             URL := StrSubstNo(CAdvisorSetup."Create Product URL") + '?access_token=' + AutheticationToken;
//             HttpsContent.WriteFrom(ItemJson);
//             HttpsContent.GetHeaders(RequestHeader);
//             RequestHeader.Remove('Content-Type');
//             HttpClient.DefaultRequestHeaders().Remove('Authorization');
//             RequestHeader.Add('Content-Type', 'application/json');
//             HttpClient.SetBaseAddress(URL);
//             IF not HttpClient.Post(URL, HttpsContent, ResponseMessage) THEN BEGIN
//                 Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//             end
//             else begin
//                 if ResponseMessage.IsSuccessStatusCode() then begin
//                     ResponseMessage.Content().ReadAs(InputText);
//                     Message('Success %1', InputText);
//                 end;
//                 if not ResponseMessage.IsSuccessStatusCode then
//                     ResponseMessage.Content.ReadAs(InputText);
//                 Message('The web service returned an error message:\\' +
//                       'Status code: %1\' +
//                       'Description: %2\' + 'Reason %3',
//                       ResponseMessage.HttpStatusCode,

//             ResponseMessage.ReasonPhrase, InputText);
//                 Clear(JsonObject1);
//                 Clear(JsonToken1);
//                 JsonObject1.ReadFrom(InputText);
//                 JsonObject1.Get('ID', JsonToken1);

//                 ID := JsonToken1.AsValue().AsText();
//                 if ID <> '' then begin
//                     ItemRec."Product ID" := ID;
//                     ItemRec.Published := true;
//                     ItemRec.Modify();
//                 end;
//             end;
//         end;
//         //   Message(Format(InputText));
//     end;

//     procedure GenerateJsonProduct(var ItemV: Record Item)
//     var

//         JObject: JsonObject;
//         Jarray: JsonArray;
//         JBranch: JsonObject;
//         JLineObj: JsonObject;
//         Manufacturer: Record Manufacturer;

//     begin
//         Clear(Jobject);
//         Clear(JArray);
//         Clear(JBranch);
//         Clear(JLineObj);
//         Clear(ItemJson);

//         Jobject.Add('ProfileID', CAdvisorSetup."Profile ID");
//         //Address Branch Details --------Start
//         Jobject.Add('Sku', ItemV."No.");
//         Jobject.Add('Title', ItemV.Description);
//         Jobject.Add('Brand', ItemV.Brand);
//         if Manufacturer.Get(ItemV."Manufacturer Code") then
//             Jobject.Add('Manufacturer', Manufacturer.Name);
//         Jobject.Add('MPN', ItemV."Vendor Item No.");
//         Jobject.Add('Condition', 'New');
//         Jobject.Add('Description', ItemV.Description);
//         Jobject.Add('UPC', ItemV."Universal Product Code");
//         Jobject.Add('BuyItNowPrice', ItemV."Unit Price");
//         Jobject.Add('RetailPrice', ItemV."Unit Price");
//         //     Jobject.Add('BuyItNowPrice', format(SIHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//         //   Jobject.Add('RetailPrice', format(SIHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>'));

//         //  Jobject.Add('totalamount', format(SIHeader."Amount Including VAT"));
//         // //Address Branch Details ---------End
//         // SILine.Reset();
//         // SILine.SetRange("Document No.", SIHeader."No.");
//         //SILine.SetFilter("No.", '<>%1', '');
//         // SILine.FindSet();
//         //Line Details --Start
//         // JLineObj.Add('partno', '');
//         // JLineObj.Add('Qty', '');
//         // repeat
//         //   JLineObj.Replace('partno', SILine."No.");
//         // // JLineObj.Replace('Qty', SILine.Quantity);
//         // JArray.Add(JLineObj.Clone());
//         // //Line Details -------End
//         // until SILine.Next() = 0;
//         // //Creating Json ---Start
//         //   Jobject.Add('customerdetails', JBranch);
//         //  Jobject.Add('partnumbers', JArray);
//         Jobject.WriteTo(ItemJson);
//         //Creating Json --END
//         // if not Confirm(ItemJson, false) then
//         //   exit;
//         // "ProfileID": "12345678",
//         // 	"Sku": "10000002",
//         // 	"Title": "WingLights Fixed - Direction Indicators for Bicycles/Turning Signals/Blinkers",
//         // 	"Brand": "WingLights",
//         // 	"Manufacturer":"Bike Products Inc.",
//         // 	"MPN": "wlf-di-bikes",
//         // 	"Condition":"New",
//         // 	"Description":"WingLights is not only a direction indicators for bicyles, it is the first of its kind. Produced by a multi-awarded startup, WingLights represents an important improvement for cycling safety accessories. It provides the same visual signal as cars and motocycles do when they are about to turn.<p>Indeed, the tempo and luminosity are the exactly the same as the ones required for cars and motocycles by legislation. You can now exercise or commute safely everywhere, anytime, even in an urban environment.<p>Who said innovation had to be complex?",
//         // 	"UPC": "012345678901",
//         // 	"BuyItNowPrice": 34.99,
//         // 	"RetailPrice": 39.99

//         // {
//         // 	"ProfileID": "53000589",
//         // 	"Sku": "BUNDLESKU_00001",
//         // 	"BundleType": "BundleItem",
//         // 	"Title": "Title for BUNDLESKU_00001",
//         // 	"Brand": "BUNDLESKU_00001 Brand",
//         // 	"Manufacturer":"BUNDLESKU_00001 Manufacturer",
//         // 	"MPN": "BUNDLESKU_00001_ABC123",
//         // 	"Condition":"New",
//         // 	"Description":"Description for BUNDLESKU_00001",
//         // 	"UPC": "123456789102",
//         // 	"BuyItNowPrice": 10.00,
//         // 	"RetailPrice": 11.00,
//         // 	"BundleComponents":[{
//         // 		"ComponentSku":"BUNDLECOMP_00001",
//         // 		"Quantity": 1
//         // 		},{
//         // 		"ComponentSku":"BUNDLECOMP_00002",
//         // 		"Quantity": 2
//         // 		}
//         // 	]
//         // }


//     end;

//     procedure GetProductSingle(var ItemRec: Record Item)
//     var
//         JsonObject1: JsonObject;
//         JsonToken1: JsonToken;
//         ID: Code[30];
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         HttpsContent: HttpContent;
//         RequestHeader: HttpHeaders;

//     begin
//         // ItemRec.TestField(Published, false);

//         CAdvisorSetup.FindFirst();
//         RefreshToken();
//         if not Confirm('Auth %1', false, AutheticationToken) then
//             exit;
//         if AutheticationToken <> '' then begin
//             URL := StrSubstNo(CAdvisorSetup."Get Product URL") + '(' + ItemRec."Product ID" + ')' + '?access_token=' + AutheticationToken;
//             //  HttpsContent.WriteFrom(ItemJson);
//             HttpsContent.GetHeaders(RequestHeader);
//             // RequestHeader.Remove('Content-Type');
//             HttpClient.DefaultRequestHeaders().Remove('Authorization');
//             //  RequestHeader.Add('Content-Type', 'application/json');
//             HttpClient.SetBaseAddress(URL);
//             IF not HttpClient.get(URL, ResponseMessage) THEN BEGIN
//                 Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//             end
//             else begin
//                 if ResponseMessage.IsSuccessStatusCode() then begin
//                     ResponseMessage.Content().ReadAs(InputText);
//                     Message('Success %1', InputText);
//                 end;
//                 if not ResponseMessage.IsSuccessStatusCode then
//                     ResponseMessage.Content.ReadAs(InputText);
//                 Message('The web service returned an error message:\\' +
//                       'Status code: %1\' +
//                       'Description: %2\' + 'Reason %3',
//                       ResponseMessage.HttpStatusCode,

//             ResponseMessage.ReasonPhrase, InputText);
//                 Clear(JsonObject1);
//                 Clear(JsonToken1);
//                 JsonObject1.ReadFrom(InputText);
//                 JsonObject1.Get('ID', JsonToken1);

//                 ID := JsonToken1.AsValue().AsText();
//                 if ID <> '' then begin
//                     ItemRec."Product ID" := ID;
//                     ItemRec.Published := true;
//                     ItemRec.Modify();
//                 end;
//             end;
//         end;
//         //   Message(Format(InputText));
//     end;

//     procedure GetProductAll()
//     var
//         JsonObject1: JsonObject;
//         JsonToken1: JsonToken;
//         ID: Code[30];
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         HttpsContent: HttpContent;
//         RequestHeader: HttpHeaders;
//         JsonArray1: JsonArray;
//         Jobect2: JsonObject;
//         ItemList: Text;
//         JToken1: JsonToken;
//         Jobject: JsonObject;
//         JArray: JsonArray;
//         ProfileId: Code[20];
//         ItemRec: Record Item;
//         Sku: Text[20];
//         DescrText: Text;
//         Length: Integer;
//         Weight: Text;
//         StartPrice: Text;
//         BuyNowPrice: Text;
//         StorePrice: Text;
//         RetailPrice: Text;
//         TotalQty: Text;
//         ProductType: Text;
//         FlagDesc: Text;
//         Cost: Text;
//         Title: Text;
//         UniqP: Code[20];
//         JobjNew: JsonObject;
//         OdataLinkNext: Text;
//         OutStream: OutStream;
//         ShortDescription: Text;
//         SupplierName: Text;
//         SupplierPO: Text;
//         ItemRecRef: RecordRef;
//         ConfigTemplateManagement: Codeunit "Config. Template Management";
//         ConfigTemplateHeader: Record "Config. Template Header";
//         AttrArray: JsonArray;
//         JTokenAttr: JsonToken;
//         JobjectAttr: JsonObject;
//         JValue2: JsonValue;
//         StyleRec: Record Style;
//     begin


//         CAdvisorSetup.FindFirst();
//         RefreshToken();
//         //  if not Confirm('Auth %1', false, AutheticationToken) then
//         //     exit;
//         if AutheticationToken <> '' then begin
//             URL := StrSubstNo(CAdvisorSetup."Get Product URL") + '?access_token=' + AutheticationToken + '&$expand=Attributes';//,Labels,Images,DCQuantities
//             //  HttpsContent.WriteFrom(ItemJson);
//             //HttpsContent.GetHeaders(RequestHeader);
//             //RequestHeader.Remove('Content-Type');
//             //message(URL);
//             HttpClient.DefaultRequestHeaders().Remove('Authorization');
//             //  RequestHeader.Add('Content-Type', 'application/json');
//             HttpClient.SetBaseAddress(URL);
//             IF not HttpClient.get(URL, ResponseMessage) THEN BEGIN
//                 Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//             end
//             else begin
//                 if ResponseMessage.IsSuccessStatusCode() then begin
//                     ResponseMessage.Content().ReadAs(InputText);
//                     //   Message('Success %1', InputText);
//                 end;
//                 if not ResponseMessage.IsSuccessStatusCode then
//                     ResponseMessage.Content.ReadAs(InputText);
//                 /*   Message('The web service returned an error message:\\' +
//                         'Status code: %1\' +
//                         'Description: %2\' + 'Reason %3',
//                         ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase, InputText); */
//                 //Message(InputText);
//                 //exit;
//                 Clear(JsonObject1);
//                 Clear(JsonToken1);
//                 JToken.ReadFrom(InputText);
//                 JToken.SelectToken('value', JsonToken1);

//                 JobjNew.ReadFrom(InputText);
//                 //JobjNew.SelectToken('@odata.nextLink', Jtoken);
//                 // JToken.SelectToken('@odata.nextLink', Jtoken);//odatanextlink
//                 JValue := ValidateJsonToken(JobjNew, '@odata.nextLink').AsValue();//.AsText();
//                 if not JValue.IsNull then
//                     OdataLinkNext := JValue.AsText();
//                 //  Message(OdataLinkNext);
//                 //  Jobject.ReadFrom(InputText);
//                 // Jobject.SelectToken('value', JsonToken1);
//                 JArray := JsonToken1.AsArray();

//                 for i := 0 to JArray.Count - 1 do begin
//                     JArray.Get(i, JToken1);
//                     Jobject := JToken1.AsObject();
//                     //Start ItemInsert
//                     Sku := '';
//                     JValue := ValidateJsonToken(Jobject, 'Sku').AsValue();
//                     if not JValue.IsNull then begin
//                         if StrLen(delchr(JValue.AsText(), '=', '@#$%^&*;,/')) < 20 then
//                             Sku := delchr(JValue.AsText(), '=', '@#$%^&*;,/');

//                     end;
//                     if Sku <> '' then begin
//                         Weight := '';
//                         StartPrice := '';
//                         BuyNowPrice := '';
//                         StorePrice := '';
//                         RetailPrice := '';
//                         TotalQty := '';
//                         ProductType := '';
//                         FlagDesc := '';
//                         Cost := '';
//                         Title := '';
//                         JValue := ValidateJsonToken(Jobject, 'ProductType').AsValue();
//                         if not JValue.IsNull then
//                             ProductType := JValue.AsText();
//                         if UpperCase(ProductType) = 'CHILD' then begin
//                             ItemRec.SetRange("No.", Sku);
//                             if not ItemRec.FindFirst() then begin
//                                 ItemRec.Init();
//                                 ItemRec."No." := Sku;
//                                 ItemRec."Product ID" := ValidateJsonToken(Jobject, 'ID').AsValue().AsText();
//                                 JValue := ValidateJsonToken(Jobject, 'Title').AsValue();
//                                 if not JValue.IsNull then
//                                     DescrText := JValue.AsText();
//                                 if (DescrText <> '') or (DescrText <> 'null') then begin
//                                     if (StrLen(DescrText) <> 0) then begin
//                                         ItemRec.Description := CopyStr(DescrText, 1, 100);
//                                         ItemRec."Description 2" := CopyStr(DescrText, 101, 150);
//                                         ItemRec."Description 3" := CopyStr(DescrText, 151, 200);
//                                     end;

//                                 end;
//                                 //   UniqP := ValidateJsonToken(Jobject, 'UPC').AsValue().AsDecimal();
//                                 //  Message(format(UniqP));
//                                 JValue := ValidateJsonToken(Jobject, 'Brand').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec.Brand := JValue.AsText();

//                                 JValue := ValidateJsonToken(Jobject, 'ParentSku').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Parent SKU" := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Parent SKU"));
//                                 JValue := ValidateJsonToken(Jobject, 'ParentProductID').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Parent Product ID" := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Parent Product ID"));


//                                 JValue := ValidateJsonToken(Jobject, 'ShortDescription').AsValue();
//                                 if not JValue.IsNull then begin
//                                     ShortDescription := JValue.AsText();
//                                     ItemRec."CA Description".CreateOutStream(OutStream, TextEncoding::UTF8);
//                                     OutStream.WriteText(ShortDescription);
//                                 end;
//                                 JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Unit Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierName').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Vendor No." := copystr(JValue.AsText(), 1, 20);

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierPO').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Vendor Item No." := copystr(JValue.AsText(), 1, 20);
//                                 JValue := ValidateJsonToken(Jobject, 'WarehouseLocation').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Warehouse Location" := copystr(JValue.AsText(), 1, 30);

//                                 JValue := ValidateJsonToken(Jobject, 'ParentSku').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Style No." := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Style No."));

//                                 JValue := ValidateJsonToken(Jobject, 'Cost').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Unit Cost" := JValue.AsDecimal();

//                                 Clear(JValue);
//                                 AttrArray := ValidateJsonToken(Jobject, 'Attributes').AsArray();
//                                 for i := 0 to AttrArray.Count - 1 do begin
//                                     Clear(JValue);
//                                     AttrArray.Get(i, JTokenAttr);
//                                     JobjectAttr := JTokenAttr.AsObject();

//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectAttr, 'Name').AsValue();
//                                     if JValue.AsText() = 'Metal' then begin
//                                         clear(JValue2);
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then begin
//                                             if StrPos(JValue2.AsText(), 'Gold') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Gold'), 4);
//                                             if StrPos(JValue2.AsText(), 'Palladium') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Palladium'), 9);
//                                             if StrPos(JValue2.AsText(), 'Platinum') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Platinum'), 8);
//                                             if StrPos(JValue2.AsText(), 'Silver') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Silver'), 6);

//                                             ItemRec."Metal Code" := CopyStr(JValue2.AsText(), 1, 3);


//                                         end;
//                                     end;
//                                     if JValue.AsText() = 'Metal Purity' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             ItemRec."Metal Code" := copystr(JValue2.AsText(), 1, 3);
//                                     end;

//                                     if JValue.AsText() = 'Clarity' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Clarity := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Color' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         ItemRec.Color := copystr(JValue2.AsText(), 1, MaxStrLen(ItemRec.Color));
//                                     end;
//                                     if JValue.AsText() = 'Cut' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Cut := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Right Weight' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             if Evaluate(RightWeight, JValue2.AsText()) then
//                                                 ItemRec."Right Weight" := RightWeight;
//                                     end;
//                                 end;

//                                 Clear(JValue);
//                                 /*ImageArray := ValidateJsonToken(Jobject, 'Images').AsArray();
//                                 AdditionalImages.DeleteAll();
//                                 LineNo := 10000;
//                                 for i := 0 to ImageArray.Count - 1 do begin
//                                     ImageArray.Get(i, JTokenImage);
//                                     JobjectImages := JTokenImage.AsObject();
//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectImages, 'PlacementName').AsValue();
//                                     if not JValue.IsNull then begin
//                                         AdditionalImages.Init();
//                                         AdditionalImages."Item No." := Sku;
//                                         AdditionalImages."Line No." := LineNo;
//                                         AdditionalImages."Image Description" := JValue.AsText();
//                                         AdditionalImages.Insert();
//                                     end;

//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectImages, 'Url').AsValue();
//                                     if not JValue.IsNull then begin
//                                         ImageUrl := InsStr(JValue.AsText(), 's', 5);
//                                         ImageUrl := InsStr(ImageUrl, 'content/', 22);

//                                         ClientImage.Get(JValue.AsText(), ResponseImage);
//                                         ResponseImage.Content().ReadAs(InStrImage);
//                                         AdditionalImages.Picture.ImportStream(InStrImage, ImageUrl);
//                                         AdditionalImages.Modify();
//                                     end;
//                                     LineNo := LineNo + 10000;
//                                 end;*/
//                                 //--Anil
//                                 /*JValue := ValidateJsonToken(Jobject, 'Weight').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Gross Weight" := JValue.AsDecimal();


//                                 JValue := ValidateJsonToken(Jobject, 'UPC').AsValue();
//                                 //   JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Universal Product Code" := JValue.AsText();
//                                 //   Message(UniqP);

//                                 JValue := ValidateJsonToken(Jobject, 'StorePrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Store Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'ReservePrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Reserve Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'BuyItNowPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Buy it Now Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'StartingPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Starting Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'Title').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec.Description := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec.Description));

//                                 /*JValue := ValidateJsonToken(Jobject, 'MPN').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Manufacturer Part No." := JValue.AsText();

//                                 JValue := ValidateJsonToken(Jobject, 'FlagDescription').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Flg Desc" := copystr(JValue.AsText(), 1, MaxStrLen(ItemRec."Flg Desc"));*/

//                                 ItemRec."Received From Channel" := true;

//                                 ItemRec.Insert();
//                                 ItemRecRef.GETTABLE(ItemRec);
//                                 ConfigTemplateHeader.Get('ITEM FIN');
//                                 ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
//                                 ItemRecRef.SETTABLE(ItemRec);
//                                 ItemRec.Modify();

//                                 Commit();
//                             end;
//                         end else begin
//                             StyleRec.Reset();
//                             Sku := CopyStr(sku, 1, 15);
//                             StyleRec.SetRange("No.", Sku);
//                             if not StyleRec.FindFirst() then begin
//                                 StyleRec.Init();
//                                 StyleRec."No." := Sku;
//                                 //StyleRec."Product ID" := ValidateJsonToken(Jobject, 'ID').AsValue().AsText();
//                                 JValue := ValidateJsonToken(Jobject, 'Title').AsValue();
//                                 if not JValue.IsNull then
//                                     DescrText := JValue.AsText();
//                                 if (DescrText <> '') or (DescrText <> 'null') then begin
//                                     if (StrLen(DescrText) <> 0) then begin
//                                         StyleRec.Description := CopyStr(DescrText, 1, 100);
//                                         StyleRec."Description 2" := CopyStr(DescrText, 101, 150);
//                                         StyleRec."Description 3" := CopyStr(DescrText, 151, 200);
//                                     end;

//                                 end;
//                                 //   UniqP := ValidateJsonToken(Jobject, 'UPC').AsValue().AsDecimal();
//                                 //  Message(format(UniqP));
//                                 /*JValue := ValidateJsonToken(Jobject, 'Brand').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec. := JValue.AsText();*/

//                                 JValue := ValidateJsonToken(Jobject, 'ShortDescription').AsValue();
//                                 if not JValue.IsNull then begin
//                                     ShortDescription := JValue.AsText();
//                                     StyleRec."CA Description".CreateOutStream(OutStream, TextEncoding::UTF8);
//                                     OutStream.WriteText(ShortDescription);
//                                 end;
//                                 JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Unit Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierName').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Vendor No." := copystr(JValue.AsText(), 1, 20);

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierPO').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Vendor Item No." := copystr(JValue.AsText(), 1, 20);
//                                 JValue := ValidateJsonToken(Jobject, 'WarehouseLocation').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Warehouse Location" := copystr(JValue.AsText(), 1, 30);

//                                 JValue := ValidateJsonToken(Jobject, 'Cost').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Unit Cost" := JValue.AsDecimal();

//                                 Clear(JValue);
//                                 AttrArray := ValidateJsonToken(Jobject, 'Attributes').AsArray();
//                                 for i := 0 to AttrArray.Count - 1 do begin
//                                     Clear(JValue);
//                                     AttrArray.Get(i, JTokenAttr);
//                                     JobjectAttr := JTokenAttr.AsObject();

//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectAttr, 'Name').AsValue();
//                                     if JValue.AsText() = 'Metal' then begin
//                                         clear(JValue2);
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then begin
//                                             if StrPos(JValue2.AsText(), 'Gold') > 0 then
//                                                 StyleRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Gold'), 4);
//                                             if StrPos(JValue2.AsText(), 'Palladium') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Palladium'), 9);
//                                             if StrPos(JValue2.AsText(), 'Platinum') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Platinum'), 8);
//                                             if StrPos(JValue2.AsText(), 'Silver') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Silver'), 6);

//                                             StyleRec."Metal Code" := CopyStr(JValue2.AsText(), 1, 3);
//                                         end;
//                                     end;
//                                     if JValue.AsText() = 'Metal Purity' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         StyleRec."Metal Code" := copystr(JValue2.AsText(), 1, 3);
//                                     end;

//                                     if JValue.AsText() = 'Clarity' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Clarity := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Color' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             StyleRec.Color := CopyStr(JValue2.AsText(), 1, MaxStrLen(StyleRec.Color));
//                                     end;
//                                     if JValue.AsText() = 'Cut' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Cut := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Right Weight' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             if Evaluate(RightWeight, JValue2.AsText()) then
//                                                 StyleRec."Right Weight" := RightWeight;
//                                     end;
//                                 end;


//                                 StyleRec."Received From Channel" := true;

//                                 StyleRec.Insert();
//                                 Commit();
//                             end;
//                         end;
//                     end;
//                     //EndItemInser
//                     //    ProfileId := ValidateJsonToken(Jobject, 'ProfileID').AsValue().AsText();
//                     //    Message('Profile ID %1 AND Count %2 and ID %3 AND Sku %4', profileid, Format(i), ValidateJsonToken(Jobject, 'ProfileID').AsValue().AsText(), ValidateJsonToken(Jobject, 'Sku').AsValue().AsText());
//                 end;

//             end;
//         end;
//         Commit();
//         Sleep(100);
//         if OdataLinkNext <> '' then
//             IterateAll(OdataLinkNext);
//     end;

//     local procedure ValidateJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken
//     begin
//         if not JsonObject.Get(TokenKey, JsonToken) then
//             Error('Could not find token with key: %1', TokenKey);
//     end;

//     procedure IterateAll(odataNextLink: Text)
//     var
//         JsonObject1: JsonObject;
//         JsonToken1: JsonToken;
//         ID: Code[30];
//         HttpClient: HttpClient;
//         HttpRequest: HttpRequestMessage;
//         ResponseMessage: HttpResponseMessage;
//         HttpsContent: HttpContent;
//         RequestHeader: HttpHeaders;
//         JsonArray1: JsonArray;
//         Jobect2: JsonObject;
//         ItemList: Text;
//         JToken1: JsonToken;
//         Jobject: JsonObject;
//         JArray: JsonArray;
//         ProfileId: Code[20];
//         ItemRec: Record Item;
//         Sku: Text[20];
//         DescrText: Text;
//         Length: Integer;
//         Weight: Text;
//         StartPrice: Text;
//         BuyNowPrice: Text;
//         StorePrice: Text;
//         RetailPrice: Text;
//         TotalQty: Text;
//         ProductType: Text;
//         FlagDesc: Text;
//         Cost: Text;
//         Title: Text;
//         UniqP: Code[20];
//         JobjNew: JsonObject;
//         OdataLinkNext1: Text;
//         OutStream: OutStream;
//         ShortDescription: Text;
//         ItemRecRef: RecordRef;
//         ConfigTemplateManagement: Codeunit "Config. Template Management";
//         ConfigTemplateHeader: Record "Config. Template Header";
//         AttrArray: JsonArray;
//         JTokenAttr: JsonToken;
//         JobjectAttr: JsonObject;
//         JValue2: JsonValue;
//         StyleRec: Record Style;
//     begin
//         Clear(URL);
//         Clear(HttpClient);
//         Clear(ResponseMessage);
//         Clear(HttpsContent);
//         Clear(OdataLinkNext1);
//         Clear(InputText);
//         Clear(Jobect2);
//         Clear(JobjNew);
//         Clear(Jobject);
//         Clear(JToken1);
//         Clear(JToken);
//         Iteration += 1;
//         URL := StrSubstNo(odataNextLink);
//         //  HttpsContent.WriteFrom(ItemJson);
//         //HttpsContent.GetHeaders(RequestHeader);
//         //RequestHeader.Remove('Content-Type');
//         HttpClient.DefaultRequestHeaders().Remove('Authorization');
//         //  RequestHeader.Add('Content-Type', 'application/json');
//         HttpClient.SetBaseAddress(URL);
//         IF not HttpClient.get(URL, ResponseMessage) THEN BEGIN
//             Message('Fail %1', format(ResponseMessage.HttpStatusCode));
//         end
//         else begin
//             if ResponseMessage.IsSuccessStatusCode() then begin
//                 ResponseMessage.Content().ReadAs(InputText);
//                 // Message('Success %1', InputText);
//             end;
//             if not ResponseMessage.IsSuccessStatusCode then
//                 ResponseMessage.Content.ReadAs(InputText);
//             /*    Message('The web service returned an error message:\\' +
//                      'Status code: %1\' +
//                      'Description: %2\' + 'Reason %3',
//                      ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase, InputText); */
//             //   Message(InputText); 
//             Clear(JsonObject1);
//             Clear(JsonToken1);
//             JToken.ReadFrom(InputText);

//             if JToken.SelectToken('value', JsonToken1) then begin
//                 Clear(JValue);
//                 JobjNew.ReadFrom(InputText);

//                 //JobjNew.SelectToken('@odata.nextLink', Jtoken);
//                 // JToken.SelectToken('@odata.nextLink', Jtoken);//odatanextlink
//                 JValue := ValidateJsonToken(JobjNew, '@odata.nextLink').AsValue();//.AsText();
//                 if not JValue.IsNull then
//                     OdataLinkNext1 := JValue.AsText();
//                 //  Message(OdataLinkNext);
//                 //  Jobject.ReadFrom(InputText);
//                 // Jobject.SelectToken('value', JsonToken1);
//                 JArray := JsonToken1.AsArray();

//                 for i := 0 to JArray.Count - 1 do begin
//                     //for i := 0 to 1 do begin
//                     JArray.Get(i, JToken1);
//                     Jobject := JToken1.AsObject();
//                     //Start ItemInsert
//                     Clear(JValue);
//                     Clear(JValue);

//                     Sku := '';
//                     JValue := ValidateJsonToken(Jobject, 'Sku').AsValue();
//                     if not JValue.IsNull then
//                         if StrLen(delchr(JValue.AsText(), '=', '@#$%^&*;,/')) < 20 then
//                             Sku := delchr(JValue.AsText(), '=', '@#$%^&*;,/');
//                     if Sku <> '' then begin
//                         Weight := '';
//                         StartPrice := '';
//                         BuyNowPrice := '';
//                         StorePrice := '';
//                         RetailPrice := '';
//                         TotalQty := '';
//                         ProductType := '';
//                         FlagDesc := '';
//                         Cost := '';
//                         Title := '';

//                         JValue := ValidateJsonToken(Jobject, 'ProductType').AsValue();
//                         if not JValue.IsNull then
//                             ProductType := JValue.AsText();
//                         if UpperCase(ProductType) = 'CHILD' then begin
//                             ItemRec.SetRange("No.", Sku);
//                             if not ItemRec.FindFirst() then begin
//                                 ItemRec.Init();
//                                 ItemRec."No." := Sku;
//                                 ItemRec."Product ID" := ValidateJsonToken(Jobject, 'ID').AsValue().AsText();
//                                 JValue := ValidateJsonToken(Jobject, 'Title').AsValue();
//                                 if not JValue.IsNull then
//                                     DescrText := JValue.AsText();
//                                 if (DescrText <> '') or (DescrText <> 'null') then begin
//                                     if (StrLen(DescrText) <> 0) then begin
//                                         ItemRec.Description := CopyStr(DescrText, 1, 100);
//                                         ItemRec."Description 2" := CopyStr(DescrText, 101, 150)
//                                     end;
//                                 end;


//                                 JValue := ValidateJsonToken(Jobject, 'ParentSku').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Parent SKU" := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Parent SKU"));
//                                 JValue := ValidateJsonToken(Jobject, 'ParentProductID').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Parent Product ID" := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Parent Product ID"));


//                                 JValue := ValidateJsonToken(Jobject, 'ShortDescription').AsValue();
//                                 if not JValue.IsNull then begin
//                                     ShortDescription := JValue.AsText();
//                                     ItemRec."CA Description".CreateOutStream(OutStream, TextEncoding::UTF8);
//                                     OutStream.WriteText(ShortDescription);
//                                 end;
//                                 JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Unit Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierName').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Vendor No." := copystr(JValue.AsText(), 1, 20);

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierPO').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Vendor Item No." := copystr(JValue.AsText(), 1, 20);
//                                 JValue := ValidateJsonToken(Jobject, 'WarehouseLocation').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Warehouse Location" := copystr(JValue.AsText(), 1, 30);

//                                 JValue := ValidateJsonToken(Jobject, 'ParentSku').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Style No." := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Style No."));

//                                 JValue := ValidateJsonToken(Jobject, 'Cost').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Unit Cost" := JValue.AsDecimal();

//                                 Clear(JValue);
//                                 AttrArray := ValidateJsonToken(Jobject, 'Attributes').AsArray();
//                                 for i := 0 to AttrArray.Count - 1 do begin
//                                     Clear(JValue);
//                                     AttrArray.Get(i, JTokenAttr);
//                                     JobjectAttr := JTokenAttr.AsObject();

//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectAttr, 'Name').AsValue();
//                                     if JValue.AsText() = 'Metal' then begin
//                                         clear(JValue2);
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then begin
//                                             if StrPos(JValue2.AsText(), 'Gold') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Gold'), 4);
//                                             if StrPos(JValue2.AsText(), 'Palladium') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Palladium'), 9);
//                                             if StrPos(JValue2.AsText(), 'Platinum') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Platinum'), 8);
//                                             if StrPos(JValue2.AsText(), 'Silver') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Silver'), 6);

//                                             ItemRec."Metal Code" := CopyStr(JValue2.AsText(), 1, 3);
//                                         end;
//                                     end;
//                                     if JValue.AsText() = 'Metal Purity' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             ItemRec."Metal Code" := copystr(JValue2.AsText(), 1, 3);
//                                     end;

//                                     //if JValue.AsText() = 'Clarity' then begin
//                                     //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                     //ItemRec.Clarity := JValue2.AsText();
//                                     //end;
//                                     if JValue.AsText() = 'Color' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             ItemRec.Color := copystr(JValue2.AsText(), 1, MaxStrLen(ItemRec.Color));
//                                     end;
//                                     if JValue.AsText() = 'Cut' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Cut := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Right Weight' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             if Evaluate(RightWeight, JValue2.AsText()) then
//                                                 ItemRec."Right Weight" := RightWeight;
//                                     end;
//                                 end;

//                                 Clear(JValue);
//                                 /*ImageArray := ValidateJsonToken(Jobject, 'Images').AsArray();
//                                 AdditionalImages.DeleteAll();
//                                 LineNo := 10000;
//                                 for i := 0 to ImageArray.Count - 1 do begin
//                                     ImageArray.Get(i, JTokenImage);
//                                     JobjectImages := JTokenImage.AsObject();
//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectImages, 'PlacementName').AsValue();
//                                     if not JValue.IsNull then begin
//                                         AdditionalImages.Init();
//                                         AdditionalImages."Item No." := Sku;
//                                         AdditionalImages."Line No." := LineNo;
//                                         AdditionalImages."Image Description" := JValue.AsText();
//                                         AdditionalImages.Insert();
//                                     end;

//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectImages, 'Url').AsValue();
//                                     if not JValue.IsNull then begin
//                                         ImageUrl := InsStr(JValue.AsText(), 's', 5);
//                                         ImageUrl := InsStr(ImageUrl, 'content/', 22);
//                                         ClientImage.Get(JValue.AsText(), ResponseImage);
//                                         ResponseImage.Content().ReadAs(InStrImage);
//                                         AdditionalImages.Picture.ImportStream(InStrImage, ImageUrl);
//                                         AdditionalImages.Modify();
//                                     end;
//                                     LineNo := LineNo + 10000;
//                                 end;/*
//                                 //   UniqP := ValidateJsonToken(Jobject, 'UPC').AsValue().AsDecimal();
//                                 //  Message(format(UniqP));
//                                 /*JValue := ValidateJsonToken(Jobject, 'Brand').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec.Brand := JValue.AsText();
//                                 // Weight :=ValidateJsonToken(Jobject, 'Brand').AsValue().AsText();
//                                 JValue := ValidateJsonToken(Jobject, 'Weight').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Gross Weight" := JValue.AsDecimal();


//                                 JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Unit Price" := JValue.AsDecimal();
//                                 JValue := ValidateJsonToken(Jobject, 'UPC').AsValue();
//                                 //   JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Universal Product Code" := JValue.AsText();
//                                 //   Message(UniqP);

//                                 JValue := ValidateJsonToken(Jobject, 'StorePrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Store Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'ReservePrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Reserve Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'BuyItNowPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Buy it Now Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'StartingPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Starting Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'Title').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec.Description := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec.Description));
//                                 JValue := ValidateJsonToken(Jobject, 'ParentProductID').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Parent Product ID" := CopyStr(JValue.AsText(), 1, MaxStrLen(ItemRec."Parent Product ID"));


//                                 JValue := ValidateJsonToken(Jobject, 'MPN').AsValue();
//                                 /*if not JValue.IsNull then
//                                     ItemRec."Manufacturer Part No." := JValue.AsText()

//                                 JValue := ValidateJsonToken(Jobject, 'FlagDescription').AsValue();
//                                 if not JValue.IsNull then
//                                     ItemRec."Flg Desc" := copystr(JValue.AsText(), 1, MaxStrLen(ItemRec."Flg Desc"));
//                                 */

//                                 ItemRec."Received From Channel" := true;

//                                 ItemRec.Insert();
//                                 ItemRecRef.GETTABLE(ItemRec);
//                                 ConfigTemplateHeader.Get('ITEM FIN');
//                                 ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
//                                 ItemRecRef.SETTABLE(ItemRec);
//                                 ItemRec.Modify();
//                                 Commit();

//                                 ;
//                             end;
//                         end else begin
//                             StyleRec.Reset();
//                             Sku := CopyStr(Sku, 1, 15);
//                             StyleRec.SetRange("No.", Sku);
//                             if not StyleRec.FindFirst() then begin
//                                 StyleRec.Init();
//                                 StyleRec."No." := Sku;
//                                 //StyleRec."Product ID" := ValidateJsonToken(Jobject, 'ID').AsValue().AsText();
//                                 JValue := ValidateJsonToken(Jobject, 'Title').AsValue();
//                                 if not JValue.IsNull then
//                                     DescrText := JValue.AsText();
//                                 if (DescrText <> '') or (DescrText <> 'null') then begin
//                                     if (StrLen(DescrText) <> 0) then begin
//                                         StyleRec.Description := CopyStr(DescrText, 1, 100);
//                                         StyleRec."Description 2" := CopyStr(DescrText, 101, 150);
//                                         StyleRec."Description 3" := CopyStr(DescrText, 151, 200);
//                                     end;

//                                 end;
//                                 //   UniqP := ValidateJsonToken(Jobject, 'UPC').AsValue().AsDecimal();
//                                 //  Message(format(UniqP));
//                                 /*JValue := ValidateJsonToken(Jobject, 'Brand').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec. := JValue.AsText();*/

//                                 JValue := ValidateJsonToken(Jobject, 'ShortDescription').AsValue();
//                                 if not JValue.IsNull then begin
//                                     ShortDescription := JValue.AsText();
//                                     StyleRec."CA Description".CreateOutStream(OutStream, TextEncoding::UTF8);
//                                     OutStream.WriteText(ShortDescription);
//                                 end;
//                                 JValue := ValidateJsonToken(Jobject, 'RetailPrice').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Unit Price" := JValue.AsDecimal();

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierName').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Vendor No." := copystr(JValue.AsText(), 1, 20);

//                                 JValue := ValidateJsonToken(Jobject, 'SupplierPO').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Vendor Item No." := copystr(JValue.AsText(), 1, 20);
//                                 JValue := ValidateJsonToken(Jobject, 'WarehouseLocation').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Warehouse Location" := copystr(JValue.AsText(), 1, 30);

//                                 JValue := ValidateJsonToken(Jobject, 'Cost').AsValue();
//                                 if not JValue.IsNull then
//                                     StyleRec."Unit Cost" := JValue.AsDecimal();

//                                 Clear(JValue);
//                                 AttrArray := ValidateJsonToken(Jobject, 'Attributes').AsArray();
//                                 for i := 0 to AttrArray.Count - 1 do begin
//                                     Clear(JValue);
//                                     AttrArray.Get(i, JTokenAttr);
//                                     JobjectAttr := JTokenAttr.AsObject();

//                                     Clear(JValue);
//                                     JValue := ValidateJsonToken(JobjectAttr, 'Name').AsValue();
//                                     if JValue.AsText() = 'Metal' then begin
//                                         clear(JValue2);
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then begin
//                                             if StrPos(JValue2.AsText(), 'Gold') > 0 then
//                                                 StyleRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Gold'), 4);
//                                             if StrPos(JValue2.AsText(), 'Palladium') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Palladium'), 9);
//                                             if StrPos(JValue2.AsText(), 'Platinum') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Platinum'), 8);
//                                             if StrPos(JValue2.AsText(), 'Silver') > 0 then
//                                                 ItemRec."Metal Type Code" := CopyStr(JValue2.AsText(), StrPos(JValue2.AsText(), 'Silver'), 6);
//                                             StyleRec."Metal Code" := CopyStr(JValue2.AsText(), 1, 3);
//                                         end;
//                                     end;
//                                     if JValue.AsText() = 'Metal Purity' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             StyleRec."Metal Code" := copystr(JValue2.AsText(), 1, 3);
//                                     end;

//                                     if JValue.AsText() = 'Clarity' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Clarity := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Color' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         if not JValue2.IsNull then
//                                             StyleRec.Color := copystr(JValue2.AsText(), 1, MaxStrLen(StyleRec.Color));
//                                     end;
//                                     if JValue.AsText() = 'Cut' then begin
//                                         //JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();
//                                         //ItemRec.Cut := JValue2.AsText();
//                                     end;
//                                     if JValue.AsText() = 'Right Weight' then begin
//                                         JValue2 := ValidateJsonToken(JobjectAttr, 'Value').AsValue();

//                                         if not JValue2.IsNull then
//                                             if Evaluate(RightWeight, JValue2.AsText()) then
//                                                 StyleRec."Right Weight" := RightWeight;
//                                     end;
//                                 end;


//                                 StyleRec."Received From Channel" := true;

//                                 StyleRec.Insert();
//                                 Commit();
//                             end;
//                         end;
//                     end;
//                     //EndItemInser
//                     //    ProfileId := ValidateJsonToken(Jobject, 'ProfileID').AsValue().AsText();
//                     //    Message('Profile ID %1 AND Count %2 and ID %3 AND Sku %4', profileid, Format(i), ValidateJsonToken(Jobject, 'ProfileID').AsValue().AsText(), ValidateJsonToken(Jobject, 'Sku').AsValue().AsText());
//                 end;
//             end;
//         end;
//         Commit();
//         //     Message(Format(Iteration));
//         Sleep(100);
//         // SelectLatestVersion();
//         if Iteration <= 800 then
//             if OdataLinkNext1 <> '' then
//                 IterateAll(OdataLinkNext1);
//     end;


//     var


//         ResponseText: Text;
//         InputText: Text;
//         AuthText: Text;
//         AutheticationToken: Text;

//         CRLF: Text[2];
//         AuthText2: Text;

//         CAdvisorSetup: Record "Channel Advisor Setup";
//         URL: Text;
//         ItemJson: Text;
//         i: Integer;
//         Iteration: Integer;

//         AuthLabel: Label 'grant_type=authorization_code';
//         //AthLabel1: Label
//         Lable1: Label 'client_id=biocgvilghpyl4rxsmmuiizmpxgiypfc';
//         Lable2: Label 'response_type=code';
//         Label3: Label 'access_type=offline';
//         ApplicationID: Label 'biocgvilghpyl4rxsmmuiizmpxgiypfc';

//         ClientSercret: Label '3lQGd8bm3EyKxdQKF3Pr2g';
//         Label4: Label 'scope=orders inventory';
//         Label5: Label 'redirect_uri=https://www.navapplication.com/oauth2/callback';


//         Jtoken: JsonToken;
//         JValue: JsonValue;

//         TempBlob: Record TempBlob;
//         DocText: Text;
//         DateInput: Date;

//         NewDocText: Text;
//         NewDateInput: Date;
//         RightWeight: Decimal;
//         ImageArray: JsonArray;
//         JobjectImages: JsonObject;
//         JTokenImage: JsonToken;
//         ClientImage: HttpClient;
//         ResponseImage: HttpResponseMessage;
//         InStrImage: InStream;
//         AdditionalImages: Record "Item Additional Picture";
//         LineNo: Integer;
//         ImageUrl: Text;
// }
//  */