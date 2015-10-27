/*
@Company        :Your SL
@Author         :Jyothi M/Suneetha
@Creation date  :12/06/2015
@Reference      :
*/
@isTest
private class TestEctrUIControlPhotoUpload{

    static UIControl__c objUIControl;
    static Attachment attach;
    static Attachment attach1;
    
    private static void testDataForUIControl(String uiControlName, Integer height, Integer yCoordinate) {
        objUIControl = new UIControl__c(Name = uiControlName, Height__c = height, YCoordinate__c = yCoordinate);
        insert objUIControl;
    }
    private static  void testDataForAttachment(String attachName, String attachBody) {
        attach = new Attachment(Name = attachName, body = Blob.valueOf(attachBody), parentId = objUIControl.id);
        insert attach;
    }
    private static  void testData() {
        TestDataUtility.createNeraTriggerCustomSetting();
        testDataForUIControl('TitleIcon', 5, 3);
        testDataForAttachment('iPadAir2vector.svg', 'Unit Test Attachment Body');
    }

    //Method for testing Save functionality
    static testmethod void uIControlPhotoUpload(){
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objUIControl);
        EctrUIControlPhotoUpload conEctr = new EctrUIControlPhotoUpload(sc);
        conEctr.attachfilename = 'iPadAir3_mini_vector1.svg';
        conEctr.profilePicFile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.SaveFile();
        attach1 = [SELECT body,Name
                   FROM Attachment
                   WHERE parentId = :objUIControl.id];
                   System.debug('testing.........>'+attach1.Name);
        System.assertEquals('Unit Test Attachment Body1', attach1.body.toString());
    }

    //Method for testing else part without giving attachfilename
    static testmethod  void uIControlPhotoUploadElse(){
         testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objUIControl);
        EctrUIControlPhotoUpload conEctr = new EctrUIControlPhotoUpload(sc);
        conEctr.profilePicFile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.SaveFile();
        System.assertNotEquals('Unit Test Attachment Body1',attach.body.toString());
    }

    //Method for testing Toggle functionality
    static testmethod void uIControlPhotoUploadToggle(){
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objUIControl);
        EctrUIControlPhotoUpload conEctr = new EctrUIControlPhotoUpload(sc);
        conEctr.attachfilename = 'iPadAir3_mini_vector1.svg';
        conEctr.profilePicFile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.toggle();
        System.assertEquals(false, conEctr.displaying);
    }
}