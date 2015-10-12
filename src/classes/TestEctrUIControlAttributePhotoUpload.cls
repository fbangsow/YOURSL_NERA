/*
@Company        :Your SL
@Author         :Jyothi M/Suneetha
@Creation date  :12/06/2015
@Reference      :
*/
@IsTest
private class TestEctrUIControlAttributePhotoUpload {

	static UIControlAttribute__c objUIControlAttribute;
	static Attachment attach;
	static Attachment attach1;
	private static void testDataForUIControlAttribute(String uiControlAttributeName) {
		objUIControlAttribute = new UIControlAttribute__c(Name = uiControlAttributeName);
		insert objUIControlAttribute;
	}
	private static  void testDataForAttachment(String attachName, String attachBody) {
		attach = new Attachment(Name = attachName, body = Blob.valueOf(attachBody), parentId = objUIControlAttribute.id);
		insert attach;
	}
	private static  void testData() {
		testDataForUIControlAttribute('ForeGroundColor');
		testDataForAttachment('iPadAir2vector.svg', 'Unit Test Attachment Body');
	}

	//Method for testing Save functionality
	static  testmethod void  uIControlAttributePhotoUpload() {
		CleanupTestData.createNeraTriggerCustomSetting();
		testData();
		ApexPages.StandardController sc = new ApexPages.StandardController(objUIControlAttribute);
		EctrUIControlAttributePhotoUpload conEctr = new EctrUIControlAttributePhotoUpload(sc);
		conEctr.attachfilename = 'iPadAir2vector.svg';
		conEctr.uploadPicFile = Blob.valueOf('Unit Test Attachment Body1');
		conEctr.SaveFile();
		attach1 = [SELECT body
		           FROM Attachment
		           WHERE parentId = :objUIControlAttribute.id];
		System.assertEquals('Unit Test Attachment Body1', attach1.body.ToString());
	}

//Method for testing else part without giving attachfilename
	static testmethod  void  uIControlAttributePhotoUploadElse() {
		CleanupTestData.createNeraTriggerCustomSetting();
		testData();
		ApexPages.StandardController sc = new ApexPages.StandardController(objUIControlAttribute);
		EctrUIControlAttributePhotoUpload conEctr = new EctrUIControlAttributePhotoUpload(sc);
		conEctr.uploadPicFile = Blob.valueOf('Unit Test Attachment Body1');
		conEctr.SaveFile();
		System.assertNotEquals('Unit Test Attachment Body1', attach.body.toString());
	}

	//Method for testing Toggle functionality
	static  testmethod void  uIControlAttributePhotoUploadToggle() {
		CleanupTestData.createNeraTriggerCustomSetting();
		testData();
		ApexPages.StandardController sc = new ApexPages.StandardController(objUIControlAttribute);
		EctrUIControlAttributePhotoUpload conEctr = new EctrUIControlAttributePhotoUpload(sc);
		conEctr.attachfilename = 'iPadAir3_mini_vector1.svg';
		conEctr.uploadPicFile = Blob.valueOf('Unit Test Attachment Body1');
		conEctr.toggle();
		System.assertEquals(false,conEctr.displaying );
	}
}