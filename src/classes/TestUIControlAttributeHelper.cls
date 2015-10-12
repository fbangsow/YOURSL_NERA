/*
@Company        :Your SL
@Author         :Jyothi 
@Creation date  :16/06/2015
@Reference      :
*/

@IsTest
private class TestUIControlAttributeHelper {
	
//Method for testing whether attachmentid__c field in UIControl object updated with Attachment id which we uploaded
	static testmethod void uIControlAttributeHelper() {
	    CleanupTestData.createNeraTriggerCustomSetting();
	    
		UIControl__c objUIControl = new UIControl__c (Name = 'Logout', Height__c = 5, YCoordinate__c = 2, AttachmentId__c = null);
		insert objUIControl;
		UIControlAttribute__c objUIControlAttribute = new UIControlAttribute__c(Name = 'FontType', AttachmentId__c = null, UIControlId__c = objUIControl.id);
		insert objUIControlAttribute;
		Attachment attachment = new Attachment(Name ='YourSL_logo.svg', ParentId = objUIControlAttribute.Id , Body = Blob.valueOf('Test Data'));
        insert attachment;
		objUIControlAttribute.AttachmentId__c = attachment.id;
		update objUIControlAttribute;
		System.assertEquals(objUIControlAttribute.AttachmentId__c, attachment.Id);
		UIControlAttributeHelper uicah = new UIControlAttributeHelper ();
	}
}