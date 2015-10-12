/*
@Company        :Your SL
@Author         :Jyothi 
@Creation date  :08/08/2015
@Reference      :
*/
@Istest
private class TestUIControlHelper {

//Method for testing whether attachmentid__c field in UIControl object updated with Attachment id which we uploaded
    static  testmethod void uIControlHelper() {
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name ='samsung', height__c =7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
        insert objPageConfig;
        UIControl__c objUIControl = new UIControl__c (Name = 'Logout', Height__c = 5, YCoordinate__c = 2, PageConfigName__c = objPageConfig.id, AttachmentId__c = null);
        insert objUIControl;
        Attachment attachment = new Attachment(Name ='YourSL_logo.svg', ParentId = objUIControl.Id , Body = Blob.valueOf('Test Data'));
        insert attachment;
        objUIControl.AttachmentId__c = attachment.id;
        update objUIControl;
        update attachment;
        System.assertEquals(objUIControl.AttachmentId__c, attachment.Id);
        UIControlHelper uich = new UIControlHelper();

    }

}