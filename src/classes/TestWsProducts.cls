/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :02/09/2015
@Reference      :
*/
@IsTest
private class TestWsProducts {

  static testmethod void doget() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User u = new User(Alias = 'standt', Email = 'Jyothi.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'Jyothi.r@neradeveloprrrent.demodev');
    insert u;
    system.runAs(u) {
      List <Product2> listProduct2s = new List <Product2>();
      listProduct2s.add(new Product2(Name = 'GenWatt Diesel 1000kW', ProductCode = 'GC1060', IsActive = true,Family='lubricants',Image__c='Attachments'));
      listProduct2s.add(new Product2(Name = 'GenWatt Diesel 10kW', ProductCode = 'GC1020', IsActive = true ,Family='lubricants',Image__c='Attachments'));
      insert listProduct2s;

      Pricebook2 objPricebook2 =new Pricebook2(Name='Standard',IsActive=true);
      insert objPricebook2;
      
    
      PriceBookEntry objPriceBookEntry = new PriceBookEntry(Product2Id=listProduct2s[0].Id,Pricebook2Id = Test.getStandardPricebookId(),IsFreeOfCharge__c = true,IsSampleWare__c = true,IsActive = true,UnitPrice=25000,UseStandardPrice=false);
      insert objPriceBookEntry;

      PriceBookEntry objPriceBookEntry1 = new PriceBookEntry(Product2Id=listProduct2s[0].Id,Pricebook2Id = objPricebook2.Id,IsFreeOfCharge__c = true,IsSampleWare__c = true,IsActive = true,UnitPrice=25000,UseStandardPrice=false);
      insert objPriceBookEntry1;

      RestRequest req = new RestRequest();
      req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Products';
      req.addParameter('userId', u.Id);
      req.httpMethod = 'GET';
      RestResponse res = new RestResponse();
      RestContext.request = req;
      RestContext.response = res;
      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      WsProducts.doReply(myRequest);
      WsProducts.wsGet();
      WsProducts.getPriceBooks();
     
  
      
    }
  }

static testmethod void dogetElse() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User u = new User(Alias = 'standt', Email = 'pavan.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.r@neradeveloprrrent.demodev');
    insert u;
    system.runAs(u) {
      List <Product2> listProduct2s = new List <Product2>();
      listProduct2s.add(new Product2(Name = 'GenWatt Diesel 1000kW', ProductCode = 'GC1060', IsActive = true,Family='lubricants',Image__c='Attachments'));
      listProduct2s.add(new Product2(Name = 'GenWatt Diesel 10kW', ProductCode = 'GC1020', IsActive = true ,Family='lubricants',Image__c='Attachments'));
      insert listProduct2s;

      Pricebook2 objPricebook2 =new Pricebook2(Name='Standard',IsActive=true);
      insert objPricebook2;
      
    
      PriceBookEntry objPriceBookEntry = new PriceBookEntry(Product2Id=listProduct2s[0].Id,Pricebook2Id = Test.getStandardPricebookId(),IsFreeOfCharge__c = true,IsSampleWare__c = true,IsActive = true,UnitPrice=25000,UseStandardPrice=false);
      insert objPriceBookEntry;

      PriceBookEntry objPriceBookEntry1 = new PriceBookEntry(Product2Id=listProduct2s[0].Id,Pricebook2Id = objPricebook2.Id,IsFreeOfCharge__c = true,IsSampleWare__c = true,IsActive = true,UnitPrice=25000,UseStandardPrice=false);
      insert objPriceBookEntry1;

      RestRequest req = new RestRequest();
      req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Products';
      req.addParameter('userId',null);
      req.httpMethod = 'GET';
      RestResponse res = new RestResponse();
      RestContext.request = req;
      RestContext.response = res;
      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      WsProducts.doReply(myRequest);
      WsProducts.wsGet();
      WsProducts.getPriceBooks();
      

  
      
    }
  }
  static testmethod void dogetElse1() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User u = new User(Alias = 'standt', Email = 'pavan.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                      TimeZoneSidKey = 'America/Los_Angeles', UserName = 'pavan.r@neradeveloprrrent.demodev');
    insert u;
    system.runAs(u) {
      List <Product2> listProduct2s = new List <Product2>();
      listProduct2s.add(new Product2(Name = 'GenWatt Diesel 1000kW', ProductCode = 'GC1060', IsActive = true,Family='lubricants',Image__c='Attachments'));
      listProduct2s.add(new Product2(Name = 'GenWatt Diesel 10kW', ProductCode = 'GC1020', IsActive = true ,Family='lubricants',Image__c='Attachments'));
      insert listProduct2s;

      Pricebook2 objPricebook2 =new Pricebook2(Name='Standard',IsActive=true);
      //insert objPricebook2;
      
    
      PriceBookEntry objPriceBookEntry = new PriceBookEntry(Product2Id=listProduct2s[0].Id,Pricebook2Id = Test.getStandardPricebookId(),IsFreeOfCharge__c = true,IsSampleWare__c = true,IsActive = true,UnitPrice=25000,UseStandardPrice=false);
      //insert objPriceBookEntry;

      PriceBookEntry objPriceBookEntry1 = new PriceBookEntry(Product2Id=listProduct2s[0].Id,Pricebook2Id = objPricebook2.Id,IsFreeOfCharge__c = true,IsSampleWare__c = true,IsActive = true,UnitPrice=25000,UseStandardPrice=false);
      //insert objPriceBookEntry1;

      RestRequest req = new RestRequest();
      req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Products';
      req.addParameter('userId',null);
      req.httpMethod = 'GET';
      RestResponse res = new RestResponse();
      RestContext.request = req;
      RestContext.response = res;
      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      WsProducts.doReply(myRequest);
      WsProducts.wsGet();
      WsProducts.getPriceBooks();
      

  
      
    }
  }

}