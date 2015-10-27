/*
 @Company: YOUR SL
 @Author: Asritha
 @Creation date: 18/8/2015
 @Ref: xxxx
*/
@isTest
private class TestWebServiceResetPassword {

    static testmethod void doDelete() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'standt', Email = 'pavan.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.r@neradeveloprrrent.demodev');
        insert u;
        RestRequest req1 = new RestRequest();
        req1.requestURI = 'https://eu5.salesforce.com/services/apexrest/ResetPassword';
        req1.addParameter('UserName', u.UserName);
        req1.addParameter('NewPassword', 'password');
        req1.httpMethod = 'Delete';
        RestResponse res1 = new RestResponse();
        RestContext.request = req1;
        RestContext.response = res1;
        String name = WebServiceResetPassword.ForgotPassword();
        System.assertEquals('Success : Successfully changed the password', name);


        RestRequest req2 = new RestRequest();
        req2.requestURI = 'https://eu5.salesforce.com/services/apexrest/ResetPassword';
        req2.httpMethod = 'Delete';
        RestResponse res2 = new RestResponse();
        RestContext.request = req2;
        RestContext.response = res2;
        String responsestring = WebServiceResetPassword.ForgotPassword();
        System.assertEquals('Error : Could not change the passwordList has no rows for assignment to SObject, Please report issue to System Administrator', responsestring);

    }

    static testmethod void doPost() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'standt', Email = 'pavan.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.r@neradeveloprrrent.demodev');
        insert u;
        RestRequest req = new RestRequest();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/ResetPassword';
        req.addParameter('UserName', u.UserName);
        req.addParameter('NewPassword', 'nera123');
        req.httpMethod = 'Post';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String message = WebServiceResetPassword.ResetPassword();
        System.assertEquals('Error : Could not change the passwordINVALID_NEW_PASSWORD: Your password must be at least 8 characters long., Please report issue to System Administrator', message);

        RestRequest req1 = new RestRequest();
        req1.requestURI = 'https://eu5.salesforce.com/services/apexrest/ResetPassword';
        req1.httpMethod = 'Post';
        RestResponse res1 = new RestResponse();
        RestContext.request = req1;
        RestContext.response = res1;
        String message1 = WebServiceResetPassword.ResetPassword();
        System.assertEquals('Error : Could not change the passwordList has no rows for assignment to SObject, Please report issue to System Administrator', message1);
    }
}