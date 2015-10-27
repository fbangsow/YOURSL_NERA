/*
 @Company: YOUR SL  
 @Author: Asritha   
 @Creation date: 18/8/2015   
 @Ref: xxxx
*/
@isTest
private class TestWebServiceScreenPermission {
    
    static testmethod void doGet() {
        
        TestDataUtility.createNeraTriggerCustomSetting();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'standt', Email = 'pavan.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.r@neradeveloprrrent.demodev');
        insert u;
        RestRequest req = new RestRequest();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/ScreenPermissions';
        req.addParameter('userId',u.Id);
        req.httpMethod = 'Get';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        WebServiceScreenPermissions.getScreenPermissions();
        
    }
}