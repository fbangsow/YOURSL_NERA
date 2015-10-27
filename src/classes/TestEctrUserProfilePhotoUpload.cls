/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :15/06/2015
@Reference      :
*/
@isTest
private class TestEctrUserProfilePhotoUpload{

    static Profile profle;
    static User usr;
    static UserProfile__c objUserProfile;
    static Attachment attach;
    static Attachment attach1;

    private static void testDataForProfile(){
        profle = [SELECT id
                  FROM Profile
                  WHERE Name = 'Standard User'];
    }
    private static  void testDataForUser(String userName, String alias, String email, String emailEncodingKey, String lastName, String languageLocaleKey,
                                         String timeZoneSidKey, String localeSidKey) {
        usr = new User(UserName = userName, Alias = alias, Email = email, EmailEncodingKey = emailEncodingKey, LastName = lastName, LanguageLocaleKey = languageLocaleKey,
                       ProfileId = profle.Id, TimeZoneSidKey = timeZoneSidKey, LocaleSidKey = localeSidKey);
        insert usr;
    }
    private static  void testDataUserProfile() {
        objUserProfile = new UserProfile__c(User__c = usr.id);
        insert objUserProfile;
    }
    private static  void testDataForAttachment(String attachName, String attachBody) {
        attach = new Attachment(Name = attachName, body = Blob.valueOf(attachBody), parentId = objUserProfile.id);
        insert attach;
    }
    private static  void testData() {
        TestDataUtility.createNeraTriggerCustomSetting();
        testDataForProfile();
        testDataForUser('jyothi.m@neradevelopment.org', 'jmora', 'jyothi.m@neradevelopment.org', 'ISO-8859-1', 'Moravapalli', 'de',
                        'Europe/Berlin', 'de');
        testDataUserProfile();
        testDataForAttachment('iPadAir2vector.svg', 'Unit Test Attachment Body');
    }

    //Method for testing Save functionality
    static testmethod void userProfilePhotoUpload(){
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objUserProfile);
        EctrUserProfilePhotoUpload conEctr = new EctrUserProfilePhotoUpload(sc);
        conEctr.attachfilename = 'iPadAir2vector.svg';
        conEctr.profilePicFile = Blob.valueOf('Test Attachment Body');
        conEctr.SaveFile();
        attach1 = [SELECT body
                   FROM Attachment
                   WHERE parentId = :objUserProfile.id];
        System.assertEquals('Test Attachment Body', attach1.body.toString());
    }

    //Method for testing else part without giving attachfilename
    static testmethod  void userProfilePhotoUploadElse(){
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objUserProfile);
        EctrUserProfilePhotoUpload conEctr = new EctrUserProfilePhotoUpload(sc);
        conEctr.profilePicFile = Blob.valueOf('Test Attachment Body');
        conEctr.SaveFile();
        System.assertNotEquals('Test Attachment Body',attach.body.toString());
    }

    //Method for testing Toggle functionality
    static testmethod  void userProfilePhotoUploadToggle(){
        testData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objUserProfile);
        EctrUserProfilePhotoUpload conEctr = new EctrUserProfilePhotoUpload(sc);
        conEctr.attachfilename = 'iPadAir2vector.svg';
        conEctr.profilePicFile = Blob.valueOf('Unit Test Attachment Body1');
        conEctr.toggle();
        System.assertEquals(false,conEctr.displaying);
        
    }
}