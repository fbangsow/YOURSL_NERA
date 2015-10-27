/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :15/06/2015
@Reference      :
*/
@isTest
private class TestMobileDevicesPhotoUpload {

    static MobileDevice__c objmobileDevice;
    static Attachment attach;
    static Attachment attach1;

    private static void testDataForMobileDevice(String deviceName, Integer height, Integer width) {
        objmobileDevice = new MobileDevice__c(Name = deviceName, Height__c = height, Width__c = width);
        insert objmobileDevice;
    }
    private static  void testDataForAttachment(String attachName, String attachBody) {
        attach = new Attachment(Name = attachName, body = Blob.valueOf(attachBody), parentId = objmobileDevice.id);
        insert attach;
    }
    private static  void testData() {
        TestDataUtility.createNeraTriggerCustomSetting();
        testDataForMobileDevice('Samsung', 640, 907);
        testDataForAttachment('iPadAir2vector.svg', 'Unit Test Attachment Body');
    }

    //Method for testing Save functionality
    static testmethod void mobileDevicesPhotoUpload() {
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objmobileDevice);
        MobileDevicesPhotoUpload conEctr = new  MobileDevicesPhotoUpload(sc);
        conEctr.attachfilename = 'iPadAir3_mini_vector1.svg';
        conEctr.Uploadfile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.attachfilename = 'iPadAir3_mini_vector1.svg';
        conEctr.saveFile();
        attach1 = [SELECT body
                   FROM Attachment
                   WHERE parentId = :objmobileDevice.id];
        System.assertEquals('Unit Test Attachment Body1', attach1.body.toString());
    }

    //Method for testing else part without giving attachfilename
    static testmethod void mobileDevicesPhotoUploadElse() {
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objmobileDevice);
        MobileDevicesPhotoUpload conEctr = new  MobileDevicesPhotoUpload(sc);
        conEctr.Uploadfile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.saveFile();
        System.assertNotEquals('Unit Test Attachment Body1', attach.body.toString());
    }
    //Method for testing Toggle functionality
    static testmethod void mobileDevicesPhotoUploadToggle() {
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objmobileDevice);
        MobileDevicesPhotoUpload conEctr = new  MobileDevicesPhotoUpload(sc);
        conEctr.Uploadfile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.attachfilename = 'iPadAir3_mini_vector1.svg';
        conEctr.toggle();
        System.assertEquals(false, conEctr.displaying );
    }
}