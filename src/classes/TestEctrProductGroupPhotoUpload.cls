@IsTest
private class TestEctrProductGroupPhotoUpload {

	static ProductGroup__c  objproductGroup;
	static Attachment attach;
	static Attachment attach1;
	private static void testDataForProductGroup(String productName ) {
		objproductGroup = new ProductGroup__c(Name = productName);
		insert  objproductGroup;
	}
	private static  void testDataForAttachment(String attachName, String attachBody) {
		attach = new Attachment(Name = attachName, body = Blob.valueOf(attachBody), parentId = objproductGroup.id);
		insert attach;
	}
	private static  void testData() {
		testDataForProductGroup( 'Danone water');
		testDataForAttachment('iPadAir2vector.svg', 'Attachment Body');
	}
	//Method for testing Save functionality
	static testmethod void productGroupPhotoUpload() {
	    CleanupTestData.createNeraTriggerCustomSetting();
		testData();
		ApexPages.StandardController sc = new ApexPages.StandardController(objproductGroup);
		EctrProductGroupPhotoUpload objEctrProductGroupPhotoUpload = new EctrProductGroupPhotoUpload(sc);
		objEctrProductGroupPhotoUpload.attachfilename = 'iPadAir2vector.svg';
		objEctrProductGroupPhotoUpload.profilePicFile = Blob.valueOf('Test Attachment Body1');
		objEctrProductGroupPhotoUpload.SaveFile();
		attach1 = [SELECT Name, body
		           FROM Attachment
		           WHERE parentId = : objproductGroup.id ];
		System.assertEquals('Test Attachment Body1', attach1.body.toString());
	}
	//Method for testing else part without giving attachfilename
	static testmethod void productGroupPhotoUploadElse() {
		CleanupTestData.createNeraTriggerCustomSetting();
		testData();
		ApexPages.StandardController sc = new ApexPages.StandardController(objproductGroup);
		EctrProductGroupPhotoUpload objEctrProductGroupPhotoUpload = new EctrProductGroupPhotoUpload(sc);
		objEctrProductGroupPhotoUpload.profilePicFile = Blob.valueOf('Test Attachment Body1');
		objEctrProductGroupPhotoUpload.SaveFile();
		System.assertNotEquals('Test Attachment Body1', attach.body.toString());
	}
	//Method for testing Toggle functionality
	static testmethod void productGroupPhotoUploadToggle() {
		CleanupTestData.createNeraTriggerCustomSetting();
		testData();
		ApexPages.StandardController sc = new ApexPages.StandardController(objproductGroup);
		EctrProductGroupPhotoUpload objEctrProductGroupPhotoUpload = new EctrProductGroupPhotoUpload(sc);
		objEctrProductGroupPhotoUpload.attachfilename = 'iPadAir2vector.svg';
		objEctrProductGroupPhotoUpload.profilePicFile = Blob.valueOf('Test Attachment Body1');
		objEctrProductGroupPhotoUpload.toggle();

	}
}