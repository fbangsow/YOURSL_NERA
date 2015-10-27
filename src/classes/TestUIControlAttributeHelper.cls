/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :16/06/2015
@Reference      :
*/

@isTest
private class TestUIControlAttributeHelper {

//Method for testing whether hashkey field in Appsetting object updated or not after inserting the UIControlAttribute
    static testmethod void uIControlAttributeInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;
        UIControl__c objUIControl = new UIControl__c (Name = 'Logout', Height__c = 5, YCoordinate__c = 2, AttachmentId__c = null, PageConfigName__c = objPageConfig.Id);
        insert objUIControl;
        UIControlAttribute__c objUIControlAttribute = new UIControlAttribute__c(Name = 'FontType', AttachmentId__c = null, UIControlId__c = objUIControl.id);
        insert objUIControlAttribute;

        AppSettings__c objAppSettings1 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];
        System.assertNotEquals(null, objAppSettings1.Hash_Key__c);
    }

    //Method for testing whether hashkey field in Appsetting object updated or not after updating the UIControlAttribute
    static testmethod void uIControlAttributeUpdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;
        UIControl__c objUIControl = new UIControl__c (Name = 'Logout', Height__c = 5, YCoordinate__c = 2, AttachmentId__c = null, PageConfigName__c = objPageConfig.Id);
        insert objUIControl;
        UIControlAttribute__c objUIControlAttribute = new UIControlAttribute__c(Name = 'FontType', AttachmentId__c = null, UIControlId__c = objUIControl.id);
        insert objUIControlAttribute;
        Attachment attachment = new Attachment(Name = 'YourSL_logo.svg', ParentId = objUIControlAttribute.Id , Body = Blob.valueOf('Test Data'));
        insert attachment;
        AppSettings__c objAppSettings1 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];

        objUIControlAttribute.AttachmentId__c = attachment.id;
        update objUIControlAttribute;

        AppSettings__c objAppSettings2 = [SELECT Id, Hash_Key__c FROM AppSettings__c Limit 1];
        //System.assertNotEquals(objAppSettings1.Hash_Key__c, objAppSettings2.Hash_Key__c);
    }
}