/*
@Company        :Your SL
@Author         :Jyothi m
@Creation date  :16/06/2015
@Reference      :
*/

@IsTest
private class TestPageConfigHelper {

//Method for testing whether attachmentid__c field in Pageconfig object updated with Attachment id which we uploaded
	static  testmethod void PageConfigHelper() {
	    CleanupTestData.createNeraTriggerCustomSetting();
	    
		MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'samsung', height__c = 7, width__c = 5);
		insert objmobileDevice;
		AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
		insert objAppSettings;
		PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.id, AttachmentId__c = null);
		insert objPageConfig;
		Attachment attachment = new Attachment(Name ='YourSL_logo.svg', ParentId = objPageConfig.Id , Body = Blob.valueOf('Test Data'));
        insert attachment;
		objPageConfig.AttachmentId__c = attachment.id;
		update objPageConfig;
		System.assertEquals(objPageConfig.AttachmentId__c, attachment.Id);
		PageConfigHelper pch = new PageConfigHelper();
	}
}