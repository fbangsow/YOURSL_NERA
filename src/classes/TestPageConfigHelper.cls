/*
@Company        :Your SL
@Author         :Jyothi m
@Creation date  :16/06/2015
@Reference      :
*/

@isTest
private class TestPageConfigHelper {

//Method for testing whether hashkey field in Appsetting object updated or not after inserting the Pageconfig
    static  testmethod void PageConfigInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;

        AppSettings__c objAppSettings1 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];
        System.assertNotEquals(null, objAppSettings1.Hash_Key__c);
    }

    //Method for testing whether hashkey field in Appsetting object updated or not after updating the Pageconfig
    static  testmethod void PageConfigupdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;
        AppSettings__c objAppSettings1 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];

        Attachment attachment = new Attachment(Name = 'YourSL_logo.svg', ParentId = objPageConfig.Id , Body = Blob.valueOf('Test Data'));
        insert attachment;
        objPageConfig.AttachmentId__c = attachment.id;
        update objPageConfig;

        AppSettings__c objAppSettings2 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];
        System.assertNotEquals(objAppSettings1.Hash_Key__c, objAppSettings2.Hash_Key__c);
    }
}