/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :04/08/2015
@Reference      :
*/
@IsTest
private class TestWsContacts {

  static testmethod void doget() {
    TestDataUtility.createNeraTriggerCustomSetting();
    String accountPayload;
    String myObject;

    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User u = new User(Alias = 'standt', Email = 'pavan.k@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.k@neradeveloprrrent.demodev');
    insert u;
    System.runAs(u) {
      Account acc  = new Account(Name = 'Gene');
      insert acc;
      List<contact> con = new List<contact>();
      con.add(new contact(LastName = 'john', AccountId = acc.Id));
      con.add(new contact(LastName = 'jyothi', AccountId = acc.Id));
      insert con;

      Contact con1 = new Contact(LastName = 'john', AccountId = acc.Id);
      insert con1;

      // Set up the RestContext object
      RestRequest req = new RestRequest();
      RestResponse res = new RestResponse();
      req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Contacts/';
      req.addParameter('userId', userInfo.getUserId());
      req.httpMethod = 'Get';
      RestContext.request = req;
      RestContext.response = res;

      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      myRequest = new UcbWsRequest(RestContext.request, accountPayload);
      myRequest = new UcbWsRequest(RestContext.request, myObject);

      UcbWsResponse myResponse = new UcbWsResponse();
      WsContacts.doReply(myRequest);
      WsContacts.wsGet();

      WsContacts.myContact result = new WsContacts.myContact(con1);
      System.debug('JSON.serialize(con)-----------------' + JSON.serialize([select LastName, AccountID, OwnerId from Contact]));
      //WsContacts.insertContacts(JSON.serialize([select LastName,AccountID,OwnerId from Contact]));
      //WsContacts.updateContacts(JSON.serialize([select LastName, AccountID, OwnerId from Contact]));
      //WsContacts.updateContacts(JSON.parse(con));
      //WsContacts.insertContacts('[{"LastName":"Pawan","AccountId":"acc.id","OwnerId":"userinfo.getuserid()"}]');
      //WsContacts.deleteContacts('[{"ID":""}]');
    }

  }

  static testmethod void doPost() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User u = new User(Alias = 'standt', Email = 'pavan.k@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.k@neradeveloprrrent.demodev');
    insert u;
    System.runAs(u) {
      Account acc  = new Account(Name = 'Gene');
      insert acc;
      List<contact> con = new List<contact>();
      con.add(new contact(LastName = 'john', AccountId = acc.Id));
      con.add(new contact(LastName = 'jyothi', AccountId = acc.Id));
      insert con;

      Test.startTest();
      // Set up the RestContext object
      RestRequest req = new RestRequest();
      RestResponse res = new RestResponse();
      req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Contacts/';
      req.httpMethod = 'Post';
      req.requestBody = Blob.valueOf(JSON.serialize([select LastName, AccountID, OwnerId from Contact]));
      RestContext.request = req;
      RestContext.response = res;

      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      UcbWsResponse myResponse = new UcbWsResponse();
      WsContacts.doReply(myRequest);
      WsContacts.wsPost();

      Test.stopTest();
    }
  }
  static testmethod void doPatch() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User u = new User(Alias = 'standt', Email = 'pavan.k@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.k@neradeveloprrrent.demodev');
    insert u;
    System.runAs(u) {
      Account acc  = new Account(Name = 'Gene');
      insert acc;
      List<contact> con = new List<contact>();
      con.add(new contact(LastName = 'john', AccountId = acc.Id));
      con.add(new contact(LastName = 'jyothi', AccountId = acc.Id));
      insert con;

      Test.startTest();
      // Set up the RestContext object
      RestRequest req = new RestRequest();
      RestResponse res = new RestResponse();
      req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Contacts/';
      req.addParameter('userId', u.Id);
      req.addParameter('contacts', JSON.serialize([select LastName, AccountID, OwnerId from Contact]));
      req.httpMethod = 'Patch';
      RestContext.request = req;
      RestContext.response = res;

      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      UcbWsResponse myResponse = new UcbWsResponse();
      WsContacts.doReply(myRequest);
      WsContacts.wsPatch();

      Test.stopTest();
    }
  }

  static testmethod void doDelete() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    User u = new User(Alias = 'standt', Email = 'pavan.k@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.k@neradeveloprrrent.demodev');
    insert u;




    Test.startTest();
    // Set up the RestContext object
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Contacts/';
    //req.addParameter('userId',u.Id);
    //req.addParameter('eventIds',u.Id);
    req.httpMethod = 'Delete';
    RestContext.request = req;
    RestContext.response = res;

    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    UcbWsResponse myResponse = new UcbWsResponse();
    WsContacts.doReply(myRequest);
    WsContacts.wsDelete();

    Test.stopTest();
  }

  static testmethod void doDummyDelete() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Contact con = new Contact(LastName = 'wain');
    insert con;

    Test.startTest();
    // Set up the RestContext object
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Contacts/';
    req.httpMethod = 'Get';
    RestContext.request = req;
    RestContext.response = res;

    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    UcbWsResponse myResponse = new UcbWsResponse();
    WsContacts.doReply(myRequest);
    WsContacts.dummyDelete();

    Test.stopTest();
  }



}