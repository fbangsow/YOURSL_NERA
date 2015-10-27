@isTest
private class TestWsAppErrorLog {

    static testmethod void doPost()  {
        TestDataUtility.createNeraTriggerCustomSetting();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'venkata.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'venkata.r@neradeveloprrrent.demodev');
        insert u;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/AppErrorLog';
        req.addParameter('userId', u.Id);
        req.addParameter('logs', '[{"AppVersion": "1.0","DeviceId": "A1EJK","DeviceOs ": "IOS 8.0","ErrorDump": "Object Reference is not set to an instance of an Object-Error","ExceptionId": "12345","Id": "","UserId": "00524000001J7meAAC"}]');
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        WsAppErrorLog.doReply(myRequest);
        WsAppErrorLog.wsPost();
        System.assertEquals(200, RestContext.response.statusCode);
    }
    static testmethod void doPostElse() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'venkata.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'venkata.r@neradeveloprrrent.demodev');
        insert u;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/AppErrorLog';
        req.addParameter('userId', u.Id);
        req.addParameter('logs', '');
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        WsAppErrorLog.doReply(myRequest);
        WsAppErrorLog.wsPost();
        System.assertEquals(400, RestContext.response.statusCode);
    }





}