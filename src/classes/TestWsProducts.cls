/*
@Company        :Your SL
@Author         :
@Creation date  :12/06/2015
@Reference      :
*/
@IsTest
private class TestWsProducts {
    
    static testmethod void product(){

    Test.startTest();

       String accountPayload;
       Sobject myObject;
       
       CleanupTestData.createNeraTriggerCustomSetting();

       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       
       User u = new User(Alias = 'standt', Email='pavan.r@neradeveloprttment.org',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',  LocaleSidKey='en_US', ProfileId = p.Id, 
       TimeZoneSidKey='America/Los_Angeles', UserName='pavan.r@neradeveloprrrent.demodev');       
       insert u;
       Product2 prod = new Product2(Name ='danone');
       insert prod;
         
       System.runAs(u) {
       System.debug('Current User: ' + UserInfo.getUserName());
       System.debug('Current Profile: ' + UserInfo.getProfileId()); 
       } 

       RestRequest req = new RestRequest();   
       req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Product2'; 
       req.addParameter('userId', u.Id);   
       req.httpMethod = 'GET'; 

       RestResponse res = new RestResponse();
       RestContext.request = req;
       RestContext.response = res;
       UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
       myRequest = new UcbWsRequest(RestContext.request,accountPayload);
       myRequest = new UcbWsRequest(RestContext.request,myObject);
       RestContext.response.responseBody =Blob.valueOf(JSON.serialize(res));      
       WsProducts.doReply(myRequest);
       WsProducts.wsGet();

       Test.stopTest();

    }
    
}