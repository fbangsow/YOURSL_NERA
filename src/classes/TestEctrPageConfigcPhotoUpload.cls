/*
@Company        :Your SL
@Author         :Jyothi M/Suneetha
@Creation date  :12/06/2015
@Reference      :
*/
@IsTest
private class TestEctrPageConfigcPhotoUpload {

    //This method for covering the code inside If
    static testmethod void PageConfigPhotoUpload() {
        CleanupTestData.createNeraTriggerCustomSetting();
        MobileDevice__c objMobileDevice = new MobileDevice__c(Name = 'IPadAir2', height__c = 1.5, width__c = 1.2);
        insert objMobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(Name = 'IPadAir2', mobileDevice__c = objMobileDevice.Id, AppVersion__c = 123.0);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.Id);
        insert objPageConfig;
        Attachment attach = new Attachment(Name = 'icon_login.svg', ParentId = objPageConfig.Id, Body = blob.valueOf('Test attachment body'));
        insert attach;

        objPageConfig.AttachmentId__c = attach.Id;
        update objPageConfig;

        PageReference p = Page.MobileDevices;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id', objPageConfig.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(objPageConfig);
        EctrPageConfigcPhotoUpload objEctrPageConfigcPhotoUpload = new EctrPageConfigcPhotoUpload(sc);
        objEctrPageConfigcPhotoUpload.uploadPicFile = attach.body;
        objEctrPageConfigcPhotoUpload.attachfilename = attach.Name;
        objEctrPageConfigcPhotoUpload.toggle();
        objEctrPageConfigcPhotoUpload.saveFile();
       system.assertEquals(attach.Id, objPageConfig.AttachmentId__c);
    }

//This Method for covering catch part
    static testmethod void PageConfigPhotoUploadCatch() {
        CleanupTestData.createNeraTriggerCustomSetting();
        MobileDevice__c objMobileDevice = new MobileDevice__c(Name = 'IPadAir2', height__c = 1.5, width__c = 1.2);
        insert objMobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(Name = 'IPadAir2', mobileDevice__c = objMobileDevice.Id, AppVersion__c = 123.0);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.Id);
        insert objPageConfig;
        Attachment attach = new Attachment(Name = 'icon_login.svg', ParentId = objPageConfig.Id, Body = blob.valueOf('Test attachment body'));
        insert attach;

        //objPageConfig.AttachmentId__c = attach.Id;
        update objPageConfig;

        ApexPages.StandardController sc = new ApexPages.StandardController(objPageConfig);
        EctrPageConfigcPhotoUpload objEctrPageConfigcPhotoUpload = new EctrPageConfigcPhotoUpload(sc);
        objEctrPageConfigcPhotoUpload.uploadPicFile = attach.body;
        objEctrPageConfigcPhotoUpload.saveFile();
        system.assertNotEquals(attach.Id, objPageConfig.AttachmentId__c);
    }

}