@IsTest
public class TestWsEvents {

    //test get kim
    static testMethod void TestWsEventsGet() {
        TestDataUtility.createNeraTriggerCustomSetting();
        List<Account> listAccounts = new List<Account>();
        listAccounts.add(new Account(Name = 'Account 1', 
            Phone = '(111) 222-3344', 
            Website = 'www.account1.com', 
            GeoLocations__Latitude__s = 9.0, 
            BillingCountry = 'india', 
            GeoLocations__Longitude__s = 8.0, 
            BillingPostalCode = '522656', 
            BillingStreet = 'city', 
            BillingState = 'ap', 
            VisitScore__c = 5.0 ));
        insert listAccounts;
        Event myEvent = new Event(
            WhatId = listAccounts[0].Id,
            OwnerId = userInfo.getUserId(),
            ActivityDate = System.today(),
            ActivityDateTime = Datetime.now(),
            IsAllDayEvent = false,
            DurationInMinutes = 30      
            );
        insert myEvent;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://login.salesforce.com/services/apexrest/Events/'; 
        req.httpMethod = 'Get';
        req.addParameter('userId', userInfo.getUserId());
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WsEvents.wsGet();
        Test.stopTest();
        //tobe implemented
        System.assertEquals('','');
    }

    //test delete
    static testMethod void TestWsEventsDelete() {
    TestDataUtility.createNeraTriggerCustomSetting();
        List<Account> listAccounts = new List<Account>();
        listAccounts.add(new Account(Name = 'Account 1', 
            Phone = '(111) 222-3344', 
            Website = 'www.account1.com', 
            GeoLocations__Latitude__s = 9.0, 
            BillingCountry = 'india', 
            GeoLocations__Longitude__s = 8.0, 
            BillingPostalCode = '522656', 
            BillingStreet = 'city', 
            BillingState = 'ap', 
            VisitScore__c = 5.0 ));
        insert listAccounts;
        Event myEvent = new Event(
            WhatId = listAccounts[0].Id,
            OwnerId = userInfo.getUserId(),
            ActivityDate = System.today(),
            ActivityDateTime = Datetime.now(),
            IsAllDayEvent = false,
            DurationInMinutes = 30
            );
        insert myEvent;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://login.salesforce.com/services/apexrest/Events/'; 
        req.httpMethod = 'Get';
        req.addParameter('userId', userInfo.getUserId());
        req.addParameter('eventIds', '["' + myEvent.Id + '"]');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WsEvents.wsDelete();
        Test.stopTest();
        //tobe implemented
        System.assertEquals('','');
        //test delete
    }
    //test update
    static testMethod void TestWsEventsPost() {
        TestDataUtility.createNeraTriggerCustomSetting();
        List<Account> listAccounts = new List<Account>();
        listAccounts.add(new Account(Name = 'Account 1', 
            Phone = '(111) 222-3344', 
            Website = 'www.account1.com', 
            GeoLocations__Latitude__s = 9.0, 
            BillingCountry = 'india', 
            GeoLocations__Longitude__s = 8.0, 
            BillingPostalCode = '522656', 
            BillingStreet = 'city', 
            BillingState = 'ap', 
            VisitScore__c = 5.0 ));
        insert listAccounts;
        Event myEvent = new Event(
            WhatId = listAccounts[0].Id,
            OwnerId = userInfo.getUserId(),
            ActivityDate = System.today(),
            ActivityDateTime = Datetime.now(),
            IsAllDayEvent = false,
            DurationInMinutes = 30,
            isTimeNeeded__c = true    
            );
        insert myEvent;

       RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://login.salesforce.com/services/apexrest/Events/'; 
        req.httpMethod = 'Get';
        req.addParameter('userId', userInfo.getUserId());
        req.addParameter('events', '[ { "OwnerId": "'+userInfo.getUserId()+'", "AccountId": "'+listAccounts[0].Id+'", "WhoId": null, "WhatId": "'+listAccounts[0].Id+'", "ActivityDate": "2015-07-09", "StartDateTime": "2015-07-09 12:35:06", "isTimeNeeded" : true, "ActivityDateTime": "2015-07-09 12:35:06", "EndDateTime": "2015-07-09 14:35:06", "Subject": "Create Test Appointment", "Description": "Description", "Status": "completed", "CrmType": 0, "LastModifiedDateTime": "2015-08-06T12:52:50.6418887+05:30", "CreatedDateTime": "2015-08-06T12:52:50.6418887+05:30", "IsDeleted": false } ]');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WsEvents.wsPost();
        Test.stopTest();
        //tobe implemented
        System.assertEquals('','');
    }

    //test update
    static testMethod void TestWsEventsPut() {
        TestDataUtility.createNeraTriggerCustomSetting();
        List<Account> listAccounts = new List<Account>();
        listAccounts.add(new Account(Name = 'Account 1', 
            Phone = '(111) 222-3344', 
            Website = 'www.account1.com', 
            GeoLocations__Latitude__s = 9.0, 
            BillingCountry = 'india', 
            GeoLocations__Longitude__s = 8.0, 
            BillingPostalCode = '522656', 
            BillingStreet = 'city', 
            BillingState = 'ap', 
            VisitScore__c = 5.0 ));
        insert listAccounts;
        
        Event myEvent = new Event(
            WhatId = listAccounts[0].Id,
            OwnerId = userInfo.getUserId(),
            ActivityDate = System.today(),
            ActivityDateTime = Datetime.now(),
            IsAllDayEvent = false,
            DurationInMinutes = 30,
            isTimeNeeded__c = true
            );
        insert myEvent;
        
       RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://login.salesforce.com/services/apexrest/Events/'; 
        req.httpMethod = 'Get';
        req.addParameter('userId', userInfo.getUserId());
        req.addParameter('events', '[ { "OwnerId": "'+userInfo.getUserId()+'" ,"AccountId": "'+listAccounts[0].Id+'", "WhoId": null, "WhatId": "'+listAccounts[0].Id+'", "ActivityDate": "2015-07-09","isTimeNeeded" : true, "StartDateTime": "2015-07-09 12:35:06", "ActivityDateTime": "2015-07-09 12:35:06", "EndDateTime": "2015-07-09 14:35:06", "Subject": "Create Test Appointment", "Description": "Description", "Status": "completed","Id": "'+myEvent.Id+'", "CrmType": 0, "LastModifiedDateTime": "2015-08-06T12:52:50.6418887+05:30", "CreatedDateTime": "2015-08-06T12:52:50.6418887+05:30", "IsDeleted": false} ]');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WsEvents.wsPut();
        Test.stopTest();
        //tobe implemented
        System.assertEquals('','');
    }
}