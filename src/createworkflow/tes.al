codeunit 50004 GenerateMastersFromCRM
{
    trigger OnRun()
    begin
        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("Customer Template");
        GeneralLedgerSetup.TestField("Vendor Template");
        CODEUNIT.RUN(CODEUNIT::"CRM Integration Management");
        //UpdateContactsCRMDetails();
        GenerateMasters();
    end;

    local procedure GenerateMasters()
    var

    begin
        //Ask CRM to give detail
        //Generate Brokers  Start
        CrmContactNew.Reset();
        CrmContactNew.SetFilter(lvt_ContactID, '<>%1', '');
        CrmContactNew.SetFilter(lvt_primaryroletext, '<>%1', '');
        //CrmContactNew.SetFilter(lvt_ContactID, '%1', 'CON00000221');//, 'CON00000295', 'CON00000429', 'CON00000466');
        if CrmContactNew.FindSet() then
            repeat
                //IF (CrmContactNew.lvt_primaryroletext = 'Customer') OR (CrmContactNew.lvt_primaryroletext = 'Corporate Customer') then
                //GenerateCutomerMastersfromRcpts(CrmContactNew);
                //GenerateCutomerMasters();
                IF (CrmContactNew.lvt_primaryroletext = 'Broker') OR (CrmContactNew.lvt_primaryroletext = 'Broker - Individual') OR (CrmContactNew.lvt_primaryroletext = 'Broker - Corporate') OR (CrmContactNew.lvt_primaryroletext = 'VP Sales') OR (CrmContactNew.lvt_primaryroletext = 'Senior Sales Manager') OR (CrmContactNew.lvt_primaryroletext = 'Sales Director') OR (CrmContactNew.lvt_primaryroletext = 'Senior Sales Director') OR (CrmContactNew.lvt_primaryroletext = 'Sales Manager') OR (CrmContactNew.lvt_primaryroletext = 'Employee') OR (CrmContactNew.lvt_primaryroletext = 'Sales Promoter') OR (CrmContactNew.lvt_primaryroletext = 'Sales Executive') then
                    GenerateVendorMasters();
                //IF (CrmContactNew.lvt_primaryroletext = 'VP Sales') OR (CrmContactNew.lvt_primaryroletext = 'Senior Sales Manager') OR (CrmContactNew.lvt_primaryroletext = 'Sales Director') OR (CrmContactNew.lvt_primaryroletext = 'Senior Sales Director') OR (CrmContactNew.lvt_primaryroletext = 'Sales Manager') OR (CrmContactNew.lvt_primaryroletext = 'Employee') OR (CrmContactNew.lvt_primaryroletext = 'Sales Promoter') OR (CrmContactNew.lvt_primaryroletext = 'Sales Executive') then
                // GenerateEmpMasters();
            until CrmContactNew.Next = 0;

    end;//new

    //masters to be created through receipts start
    procedure GenerateMastersFromReceipts(CRMRcpt: Record "CRM Receipts")
    var

    begin
        CrmContactNew.Reset();
        CrmContactNew.SetFilter(lvt_ContactID, '<>%1', '');
        CrmContactNew.SetFilter(lvt_primaryroletext, '%1|%2', 'Customer', 'Corporate Customer');
        CrmContactNew.SetFilter(lvt_ContactID, '%1', CRMRcpt.lvt_contactid);
        if CrmContactNew.FindFirst then
            GenerateCutomerMastersfromRcpts(CrmContactNew);
    end;

    procedure GenerateCutomerMastersfromRcpts(CRMContNew: Record "CRM ContactNew")
    var

    begin
        //Mapping of Country and Region Code is needed.
        Customer.Reset();
        Customer.SetRange("Contact ID CRM", CRMContNew.lvt_ContactID);
        //----------------------------------------Creating Customer  --Start
        if not Customer.FindFirst() then begin
            Customer.Reset();
            Customer.Init();
            Customer."No." := CRMContNew.lvt_ContactID;
            Customer.Name := copystr(CRMContNew.FullName, 1, 100);
            if StrLen(CRMContNew.FullName) > 100 then
                Customer."Name 2" := copystr(CRMContNew.FullName, 101, 150);
            Customer."Contact ID CRM" := CRMContNew.lvt_ContactID;
            Customer.Address := copystr(CRMContNew.Address1_Line1, 1, 100);
            //if StrLen(CrmContactNew.Address1_Line1) > 100 then
            Customer."Address 2" := CopyStr((CRMContNew.Address1_Line1 + CRMContNew.Address1_Line2 + CRMContNew.Address1_Line3), 101, 150);
            Customer."E-Mail" := CRMContNew.EMailAddress1;
            Customer."CRM ID" := CRMContNew.ContactId;

            Customer.Insert(true);

            //Dimension Values Insert-START-22.11.19
            DimValue.Reset();
            DimValue.Init();
            DimValue.Validate("Dimension Code", 'CUSTOMER');
            DimValue.Validate(Code, Customer."No.");
            DimValue.Name := CopyStr(Customer.Name, 1, 50);     //changed from No. to Name
            //DimValue."CRM Code" := Customer."No.";
            DimValue.Insert();
            //Dimension Values Insert-END-22.11.19

            //Default Dimension Insert-START-22.11.19
            DefaultDim.Reset();
            DefaultDim.Init();
            DefaultDim.Validate("Dimension Code", 'CUSTOMER');
            DefaultDim.Validate("Dimension Value Code", Customer."No.");
            DefaultDim.Validate("Table ID", 18);
            DefaultDim.Validate("No.", Customer."No.");
            DefaultDim.Validate("Value Posting", DefaultDim."Value Posting"::"Same Code");
            DefaultDim.Insert();
            //Default Dimension Insert-END-22.11.19

            UpdateCustomerFromTemplateDSS(Customer);
            countryReg.Reset;
            countryReg.SetRange("CRM Country Name", CRMContNew.lvt_countryname);
            if countryReg.FindFirst then begin
                Customer."Country/Region Code" := countryReg.Code;
                Customer.validate(Customer."Country/Region Code");
            end;
            IF CRMContNew.lvt_citytext <> '' then begin
                PostCode.Reset;
                PostCode.SetFilter(PostCode."CRM City", '%1', CRMContNew.lvt_citytext);
                IF PostCode.FindFirst then begin
                    Customer.City := PostCode.City;
                    Customer."Post Code" := PostCode.Code;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CRMContNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        Customer."Country/Region Code" := countryReg.Code;
                    end;
                end else begin
                    PostCode.Reset;
                    PostCode.init;
                    PostCode.Code := Copystr(CRMContNew.lvt_citytext, 1, 20);
                    PostCode.City := Copystr(CRMContNew.lvt_citytext, 1, 30);
                    PostCode."CRM City" := CRMContNew.lvt_citytext;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CRMContNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        PostCode."Country/Region Code" := countryReg.Code;
                    end;
                    PostCode.insert;

                    PostCodeNew.reset;
                    PostCodeNew.SetRange("CRM City", CRMContNew.lvt_citytext);
                    if PostCodeNew.FindFirst then begin
                        Customer."Post Code" := PostCodeNew.Code;
                        Customer.City := PostCodeNew.City;
                        Customer."Country/Region Code" := PostCodeNew."Country/Region Code";
                    end;
                end;
            end;

            //251119 START
            IF Customer."Country/Region Code" <> '' then begin
                CustPostingGroup.Reset();
                CustPostingGroup.SetRange(CustPostingGroup.Code, Customer."Country/Region Code");
                IF CustPostingGroup.FindFirst then
                    Customer."Customer Posting Group" := CustPostingGroup.Code
                ELSE
                    Customer."Customer Posting Group" := 'OTH';
                Customer.Validate(Customer."Customer Posting Group");
            end;
            //  else begin
            //     Customer."Customer Posting Group" := 'OTH';
            //     Customer.Validate(Customer."Customer Posting Group");
            // end;
            //251119 END

            Customer.crm := true;
            Customer.Modify(true);
            Commit();   //new code
        end;
        //----------------------------------------Creating Customer  --End
        //Message('total is %1', CrmContactNew.Count);
        //
    end;
    //masters to be created through receipts end

    local procedure GenerateCutomerMasters()
    var

    begin
        //Mapping of Country and Region Code is needed.
        Customer.Reset();
        Customer.SetRange("Contact ID CRM", CrmContactNew.lvt_ContactID);
        //Customer.SetRange("CRM ID", CrmContactNew.ContactId);
        //----------------------------------------Creating Customer  --Start
        if not Customer.FindFirst() then begin
            Customer.Reset();
            Customer.Init();
            //Customer."No." := '';
            Customer."No." := CrmContactNew.lvt_ContactID;
            Customer.Name := copystr(CrmContactNew.FullName, 1, 100);
            if StrLen(CrmContactNew.FullName) > 100 then
                Customer."Name 2" := copystr(CrmContactNew.FullName, 101, 150);
            Customer."Contact ID CRM" := CrmContactNew.lvt_ContactID;
            Customer.Address := copystr(CrmContactNew.Address1_Line1, 1, 100);
            //if StrLen(CrmContactNew.Address1_Line1) > 100 then
            Customer."Address 2" := CopyStr((CrmContactNew.Address1_Line1 + CrmContactNew.Address1_Line2 + CrmContactNew.Address1_Line3), 101, 150);
            Customer."E-Mail" := CrmContactNew.EMailAddress1;
            Customer."CRM ID" := CrmContactNew.ContactId;
            Customer.Insert(true);

            UpdateCustomerFromTemplateDSS(Customer);
            IF CrmContactNew.lvt_citytext <> '' then begin
                PostCode.Reset;
                PostCode.SetFilter("CRM City", '%1', CrmContactNew.lvt_citytext);
                IF PostCode.FindFirst then begin
                    Customer.City := PostCode.City;
                    Customer."Post Code" := PostCode.Code;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CrmContactNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        Customer."Country/Region Code" := countryReg.Code;
                    end;
                end else begin
                    PostCode.Reset;
                    PostCode.init;
                    PostCode.Code := Copystr(CrmContactNew.lvt_citytext, 1, 20);
                    PostCode.City := Copystr(CrmContactNew.lvt_citytext, 1, 30);
                    PostCode."CRM City" := CrmContactNew.lvt_citytext;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CrmContactNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        PostCode."Country/Region Code" := countryReg.Code;
                    end;
                    PostCode.insert;

                    PostCodeNew.reset;
                    PostCodeNew.SetRange("CRM City", CrmContactNew.lvt_citytext);
                    if PostCodeNew.FindFirst then begin
                        Customer."Post Code" := PostCodeNew.Code;
                        Customer.City := PostCodeNew.City;
                        Customer."Country/Region Code" := PostCodeNew."Country/Region Code";
                    end;
                end;
            end;
            Customer.crm := true;
            Customer.Modify(true);
        end;
        //----------------------------------------Creating Customer  --End
        //Message('total is %1', CrmContactNew.Count);
        //
    end;

    //create vendor start
    local procedure GenerateVendorMasters()
    var

    begin
        //Mapping of Country and Region Code is needed.
        Vendor.Reset();
        Vendor.SetRange("Contact ID CRM", CrmContactNew.lvt_ContactID);
        //----------------------------------------Creating Vendor  --Start
        if not Vendor.FindFirst then begin
            Vendor.Reset();
            Vendor.Init();
            //Customer."No." := '';
            Vendor."No." := CrmContactNew.lvt_ContactID;
            Vendor.Name := copystr(CrmContactNew.FullName, 1, 100);
            if StrLen(CrmContactNew.FullName) > 100 then
                Vendor."Name 2" := copystr(CrmContactNew.FullName, 101, 150);
            Vendor."Contact ID CRM" := CrmContactNew.lvt_ContactID;
            Vendor.Address := copystr(CrmContactNew.Address1_Line1, 1, 100);
            //if StrLen(CrmContactNew.Address1_Line1) > 100 then
            Vendor."Address 2" := CopyStr((CrmContactNew.Address1_Line1 + CrmContactNew.Address1_Line2 + CrmContactNew.Address1_Line3), 101, 150);
            Vendor."E-Mail" := CrmContactNew.EMailAddress1;
            Vendor."CRM ID" := CrmContactNew.ContactId;
            Vendor.Insert(true);

            UpdateVendorFromTemplateDSS(Vendor);
            IF CrmContactNew.lvt_citytext <> '' then begin
                PostCode.Reset;
                PostCode.SetFilter("CRM City", '%1', CrmContactNew.lvt_citytext);
                IF PostCode.FindFirst then begin
                    Vendor.City := PostCode.City;
                    Vendor."Post Code" := PostCode.Code;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CrmContactNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        Vendor."Country/Region Code" := countryReg.Code;
                    end;
                end else begin
                    PostCode.Reset;
                    PostCode.init;
                    PostCode.Code := Copystr(CrmContactNew.lvt_citytext, 1, 20);
                    PostCode.City := Copystr(CrmContactNew.lvt_citytext, 1, 30);
                    PostCode."CRM City" := CrmContactNew.lvt_citytext;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CrmContactNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        PostCode."Country/Region Code" := countryReg.Code;
                    end;
                    PostCode.insert;

                    PostCodeNew.reset;
                    PostCodeNew.SetRange("CRM City", CrmContactNew.lvt_citytext);
                    if PostCodeNew.FindFirst then begin
                        Vendor."Post Code" := PostCodeNew.Code;
                        Vendor.City := PostCodeNew.City;
                        Vendor."Country/Region Code" := PostCodeNew."Country/Region Code";
                    end;
                end;
            end;
            Vendor.crm := true;
            Vendor.Modify(true);
        end;
        //----------------------------------------Creating Vendor  --End
    end;
    //create vendor end

    //create employee start
    local procedure GenerateEmpMasters()
    var

    begin
        //Mapping of Country and Region Code is needed.
        employee.Reset();
        employee.SetRange("Contact ID CRM", CrmContactNew.lvt_ContactID);
        if not employee.FindFirst then begin
            employee.Reset();
            employee.Init();
            employee."No." := CrmContactNew.lvt_ContactID;
            employee."First Name" := copystr(CrmContactNew.FirstName, 1, 30);
            employee."Last Name" := CopyStr(CrmContactNew.LastName, 1, 30);
            employee."Contact ID CRM" := CrmContactNew.lvt_ContactID;
            employee.Address := copystr(CrmContactNew.Address1_Line1, 1, 100);
            employee."Address 2" := CopyStr((CrmContactNew.Address1_Line1 + CrmContactNew.Address1_Line2 + CrmContactNew.Address1_Line3), 101, 150);
            employee."E-Mail" := CrmContactNew.EMailAddress1;
            employee."CRM ID" := CrmContactNew.ContactId;
            employee.Insert(true);

            //UpdateCustomerFromTemplateDSS(Customer);
            IF CrmContactNew.lvt_citytext <> '' then begin
                PostCode.Reset;
                PostCode.SetFilter("CRM City", '%1', CrmContactNew.lvt_citytext);
                IF PostCode.FindFirst then begin
                    employee.City := PostCode.City;
                    employee."Post Code" := PostCode.Code;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CrmContactNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        employee."Country/Region Code" := countryReg.Code;
                    end;
                end else begin
                    PostCode.Reset;
                    PostCode.init;
                    PostCode.Code := Copystr(CrmContactNew.lvt_citytext, 1, 20);
                    PostCode.City := Copystr(CrmContactNew.lvt_citytext, 1, 30);
                    PostCode."CRM City" := CrmContactNew.lvt_citytext;
                    countryReg.Reset;
                    countryReg.SetRange("CRM Country Name", CrmContactNew.lvt_countryname);
                    if countryReg.FindFirst then begin
                        PostCode."Country/Region Code" := countryReg.Code;
                    end;
                    PostCode.insert;

                    PostCodeNew.reset;
                    PostCodeNew.SetRange("CRM City", CrmContactNew.lvt_citytext);
                    if PostCodeNew.FindFirst then begin
                        employee."Post Code" := PostCodeNew.Code;
                        employee.City := PostCodeNew.City;
                        employee."Country/Region Code" := PostCodeNew."Country/Region Code";
                    end;
                end;
            end;
            employee.crm := true;
            employee.Modify(true);
        end;
    end;
    //create employee end

    procedure UpdateCustomerFromTemplateDSS(VAR Customer: Record Customer)
    var

    begin
        GeneralLedgerSetup.GET;
        //IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Customer);
        ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
        ConfigTemplateHeader.SetRange(Code, GeneralLedgerSetup."Customer Template");
        IF ConfigTemplateHeader.FindFirst() then begin
            //ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
            //  ConfigTemplates.LOOKUPMODE(TRUE);
            //  IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
            //    ConfigTemplates.GETRECORD(ConfigTemplateHeader);
            CustomerRecRef.GETTABLE(Customer);
            ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, CustomerRecRef);
            DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
            CustomerRecRef.SETTABLE(Customer);
            Customer.FIND;
        END;
        //END;
    END;




    procedure UpdateVendorFromTemplateDSS(VAR Vendor: Record Vendor)
    var

    begin
        IF GUIALLOWED THEN BEGIN
            ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Vendor);
            ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
            ConfigTemplateHeader.SetRange(Code, GeneralLedgerSetup."Vendor Template");
            IF ConfigTemplateHeader.FindFirst() then begin
                //ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
                //ConfigTemplates.LOOKUPMODE(TRUE);
                //  IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
                //  ConfigTemplates.GETRECORD(ConfigTemplateHeader);
                VendorRecRef.GETTABLE(Vendor);
                ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, VendorRecRef);
                DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Vendor."No.", DATABASE::Vendor);
                VendorRecRef.SETTABLE(Vendor);
                Vendor.FIND;
            END;
        END;
    END;



    local procedure UpdateContactsCRMDetails()
    var

    begin
        // CRMIntegrationRecord.RESET;
        // CRMIntegrationRecord.SETRANGE("Table ID", 5050);
        // IF CRMIntegrationRecord.FINDSET THEN
        //     REPEAT
        //         IntegrationRecord.RESET;
        //         IntegrationRecord.SETRANGE("Integration ID", CRMIntegrationRecord."Integration ID");
        //         IntegrationRecord.SETRANGE("Table ID", CRMIntegrationRecord."Table ID");
        //         IntegrationRecord.SETRANGE("Deleted On", 0DT);
        //         IF IntegrationRecord.FINDFIRST THEN BEGIN
        //             //            CRMContact.RESET;
        //             //          CRMContact.SETRANGE(ContactId, CRMIntegrationRecord."CRM ID");
        //             //        IF CRMContact.FINDFIRST THEN BEGIN
        //             //          Contact.RESET;
        //             Contact.SETRANGE(Type, Contact.Type::Person);
        //             IF Contact.FINDSET THEN
        //                 REPEAT
        //                     IF FORMAT(Contact.RECORDID) = FORMAT(IntegrationRecord."Record ID") THEN
        //                     //    MESSAGE('iNTE rECORD FIELD %1 AND Record ID OF i %2 CONTACT %3 JOB %4', IntegrationRecord."Record ID", IntegrationRecord.RECORDID, Contact.RECORDID, CRMContact.JobTitle)
        //                   UNTIL Contact.NEXT = 0;
        //         END
        //         //END;
        //     UNTIL CRMIntegrationRecord.NEXT = 0;
    end;




    var



        Vendor: Record Vendor;
        Customer: Record Customer;
        VendorRecRef: RecordRef;
        MiniCustomerTemplate: Record "Mini Customer Template";
        IntegrationRecord: Record 5151;
        Bank: Record "Bank Account";
        CRMIntegrationRecord: Record 5331;
        ConfigTemplateHeader: Record "Config. Template Header";
        CustomerRecRef: RecordRef;
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        DimensionsTemplate: Record "Dimensions Template";
        Contact: Record 5050;
        Contact1: Record Contact;
        GeneralLedgerSetup: Record "General Ledger Setup";

        SalespersonPurchaser: Record 13;

        CrmContactNew: Record "CRM ContactNew";
        CrmContactNew1: Record "CRM ContactNew";
        PostCode: Record "Post Code";
        PostCodeNew: Record "Post Code";
        countryReg: Record "Country/Region";
        employee: Record Employee;
        DimValue: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
        CustPostingGroup: Record "Customer Posting Group";

}















// codeunit 50004 GenerateMastersFromCRM
// {
//     trigger OnRun()
//     begin
//         GeneralLedgerSetup.Get();
//         GeneralLedgerSetup.TestField("Customer Template");
//         GeneralLedgerSetup.TestField("Vendor Template");
//         CODEUNIT.RUN(CODEUNIT::"CRM Integration Management");
//         //UpdateContactsCRMDetails();
//         GenerateMasters();
//     end;

//     local procedure GenerateMasters()
//     var

//     begin
//         Contact.Reset();
//         Contact.SetRange(Type, Contact.Type::Person);
//         Contact.SetFilter("Contact ID CRM", '<>%1', '');
//         Contact.SetRange(CRM, false);
//         Contact.SetFilter(Pager, '<>%1', '');
//         if Contact.FindSet() then begin
//             repeat

//                 //----------------------------------------Creating Customer  --Start
//                 if Contact.Pager = 'Customer' then begin
//                     Customer.Reset();
//                     Customer.Init();
//                     Customer."No." := '';
//                     Customer.Insert(true);
//                     UpdateCustomerFromTemplateDSS(Customer);
//                     // Customer."Contact ID CRM" := 
//                     Customer."CRM ID" := Contact."CRM ID";
//                     Customer.crm := true;
//                     Customer.Modify();
//                     Contact.crm := true;
//                     Contact.Modify();
//                 end;
//                 //----------------------------------------Creating Customer  --End
//                 //----------------------------------------Creating Vendor  --Start
//                 if Contact.Pager = 'Broker' then begin
//                     vendor.Reset();
//                     vendor.Init();
//                     vendor."No." := '';
//                     vendor.Insert(true);
//                     UpdateVendorFromTemplateDSS(Vendor);
//                     // vendor."Contact ID CRM" := 
//                     Vendor.crm := true;
//                     vendor.Modify();
//                     Contact.crm := true;
//                     Contact.Modify();
//                 end;
//                 //----------------------------------------Creating Vendor  --End

//             until Contact.Next() = 0;
//         end

//     end;


//     procedure UpdateCustomerFromTemplateDSS(VAR Customer: Record Customer)
//     var

//     begin
//         IF GUIALLOWED THEN BEGIN
//             ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Customer);
//             ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
//             ConfigTemplateHeader.SetRange(Code, GeneralLedgerSetup."Customer Template");
//             IF ConfigTemplateHeader.FindFirst() then begin
//                 //ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
//                 //  ConfigTemplates.LOOKUPMODE(TRUE);
//                 //  IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                 //    ConfigTemplates.GETRECORD(ConfigTemplateHeader);
//                 CustomerRecRef.GETTABLE(Customer);
//                 ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, CustomerRecRef);
//                 DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
//                 CustomerRecRef.SETTABLE(Customer);
//                 Customer.FIND;
//             END;
//         END;
//     END;




//     procedure UpdateVendorFromTemplateDSS(VAR Vendor: Record Vendor)
//     var

//     begin
//         IF GUIALLOWED THEN BEGIN
//             ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Vendor);
//             ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
//             ConfigTemplateHeader.SetRange(Code, GeneralLedgerSetup."Vendor Template");
//             IF ConfigTemplateHeader.FindFirst() then begin
//                 //ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
//                 //ConfigTemplates.LOOKUPMODE(TRUE);
//                 //  IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                 //  ConfigTemplates.GETRECORD(ConfigTemplateHeader);
//                 VendorRecRef.GETTABLE(Vendor);
//                 ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, VendorRecRef);
//                 DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Vendor."No.", DATABASE::Vendor);
//                 VendorRecRef.SETTABLE(Vendor);
//                 Vendor.FIND;
//             END;
//         END;
//     END;



//     local procedure UpdateContactsCRMDetails()
//     var

//     begin
//         CRMIntegrationRecord.RESET;
//         CRMIntegrationRecord.SETRANGE("Table ID", 5050);
//         IF CRMIntegrationRecord.FINDSET THEN
//             REPEAT
//                 IntegrationRecord.RESET;
//                 IntegrationRecord.SETRANGE("Integration ID", CRMIntegrationRecord."Integration ID");
//                 IntegrationRecord.SETRANGE("Table ID", CRMIntegrationRecord."Table ID");
//                 IntegrationRecord.SETRANGE("Deleted On", 0DT);
//                 IF IntegrationRecord.FINDFIRST THEN BEGIN
//                     CRMContact.RESET;
//                     CRMContact.SETRANGE(ContactId, CRMIntegrationRecord."CRM ID");
//                     IF CRMContact.FINDFIRST THEN BEGIN
//                         Contact.RESET;
//                         Contact.SETRANGE(Type, Contact.Type::Person);
//                         IF Contact.FINDSET THEN
//                             REPEAT
//                                 IF FORMAT(Contact.RECORDID) = FORMAT(IntegrationRecord."Record ID") THEN
//                                     MESSAGE('iNTE rECORD FIELD %1 AND Record ID OF i %2 CONTACT %3 JOB %4', IntegrationRecord."Record ID", IntegrationRecord.RECORDID, Contact.RECORDID, CRMContact.JobTitle)
//                               UNTIL Contact.NEXT = 0;
//                     END
//                 END;
//             UNTIL CRMIntegrationRecord.NEXT = 0;
//     end;




//     var
//         Vendor: Record Vendor;
//         Customer: Record Customer;
//         PaymentCRM: Record "Payments CRM";
//         CRMReceipt: Record "CRM Receipts";
//         VendorRecRef: RecordRef;
//         MiniCustomerTemplate: Record "Mini Customer Template";
//         IntegrationRecord: Record 5151;
//         Bank: Record "Bank Account";
//         CRMIntegrationRecord: Record 5331;
//         ConfigTemplateHeader: Record "Config. Template Header";
//         CustomerRecRef: RecordRef;
//         ConfigTemplateManagement: Codeunit "Config. Template Management";
//         DimensionsTemplate: Record "Dimensions Template";
//         Contact: Record 5050;
//         Contact1: Record Contact;
//         GeneralLedgerSetup: Record "General Ledger Setup";
//         CRMContact: Record 5342;
//         SalespersonPurchaser: Record 13;

//         CrmContactNew:Record "CRM ContactNew";
// }