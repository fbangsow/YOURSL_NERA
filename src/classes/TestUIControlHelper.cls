/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :08/08/2015
@Reference      :
*/
@istest
private class TestUIControlHelper {

//Method for testing whether hashkey field in Appsetting object updated or not after inserting the UIControl
    static  testmethod void uIControlInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;
        UIControl__c objUIControl = new UIControl__c (Name = 'Logout', Height__c = 5, YCoordinate__c = 2, PageConfigName__c = objPageConfig.id, AttachmentId__c = null);
        insert objUIControl;

        AppSettings__c objAppSettings1 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];
        System.assertNotEquals(null, objAppSettings1.Hash_Key__c);
    }
    
    //Method for testing whether hashkey field in Appsetting object updated or not after updating the UIControl
    static  testmethod void uIControlUpdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;
        UIControl__c objUIControl = new UIControl__c (Name = 'Logout', Height__c = 5, YCoordinate__c = 2, PageConfigName__c = objPageConfig.id, AttachmentId__c = null);
        insert objUIControl;
        AppSettings__c objAppSettings1 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];

        Attachment attachment = new Attachment(Name = 'YourSL_logo.svg', ParentId = objUIControl.Id , Body = Blob.valueOf('Test Data'));
        insert attachment;
        objUIControl.AttachmentId__c = attachment.id;
        update objUIControl;

        AppSettings__c objAppSettings2 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];
        System.assertNotEquals(objAppSettings1.Hash_Key__c, objAppSettings2.Hash_Key__c);
    }
}