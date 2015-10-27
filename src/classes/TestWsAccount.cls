/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :04/08/2015
@Reference      :
*/

@isTest
global class TestWsAccount {

    static  testMethod void webServiceAccount() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        String accountPayload;
        Sobject myObject;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'jyothi', Email = 'jyothi.m@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'jyothi.m@neradeveloprrrent.org');

        insert u;
        System.runAs(u) {

            List<Account> listAccounts = new List<Account>();
            listAccounts.add(new Account(Name = 'GenePoint', Phone = '(111) 222-3344', Website = 'www.account1.com', Owner = u, GeoLocations__Latitude__s = 9.0, BillingCountry = 'india', GeoLocations__Longitude__s = 8.0, BillingPostalCode = '522656', BillingStreet = 'city', BillingState = 'ap', VisitScore__c = 5.0 ));
            listAccounts.add(new Account(Name = 'jyothi', Phone = '(222) 333-4455', Website = 'www.account1.com'  , Owner = u, GeoLocations__Latitude__s = 9.0, BillingCountry = 'india' , GeoLocations__Longitude__s = 8.0, BillingPostalCode = '5226585', BillingStreet = 'sri', BillingState = 'aps', VisitScore__c = 6.0));
            listAccounts.add(new Account(Name = 'United Oil & Gas Corp.', Phone = '(333) 444-5566', Website = 'www.account1.com', Owner = u, GeoLocations__Latitude__s = 9.0, BillingCountry = 'india' ,  GeoLocations__Longitude__s = 9.4, BillingPostalCode = '522654', BillingStreet = 'srij', BillingState = 'asd', VisitScore__c = 4.0));
            listAccounts.add(new Account(Name = 'United Oil & Gas, UK', Phone = '(444) 555-6677', Website = 'www.account1.com' , Owner = u, GeoLocations__Latitude__s = 9.0, BillingCountry = 'india' , GeoLocations__Longitude__s = 6.0, BillingPostalCode = '522657', BillingStreet = 'sdri', BillingState = 'usd', VisitScore__c = 5.0));
            listAccounts.add(new Account(Name = 'University of Arizona', Phone = '(555) 666-7788', Website = 'www.account1.com' , Owner = u, GeoLocations__Latitude__s = 9.0, BillingCountry = 'india' , GeoLocations__Longitude__s = 5.0, BillingPostalCode = '522655', BillingStreet = 'sdrt', BillingState = 'use', VisitScore__c = 3.0));
            insert listAccounts;


            VisitScoreResult__c  objVisitScoreResult  = new VisitScoreResult__c( Account__c = listAccounts[0].id, Date__c = System.today(), Result__c = 5.0);
            insert objVisitScoreResult;

            BusinessProcess__c objBusinessProcess = new BusinessProcess__c(Name = 'Account custom search');
            insert objBusinessProcess;
            BusinessProcessParameter__c objBusinessProcessParameter = new BusinessProcessParameter__c( Name = 'filter',
                    Values__c = 'AND Type != \'Other\'',
                    BusinessprocessId__c = objBusinessProcess.id);
            insert objBusinessProcessParameter;

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Accounts';
            req.addParameter('userId', u.Id);
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
            myRequest = new UcbWsRequest(RestContext.request, accountPayload);
            myRequest = new UcbWsRequest(RestContext.request, myObject);
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));

            //---------Creating Dumy data for response class-----Start----
            HttpResponse resp = new HttpResponse();
            resp.setStatus('OK');
            resp.setStatusCode(200);
            UcbWsResponse myResponse = new UcbWsResponse(true, 'No Error', '', resp);
            //---------Creating Dumy data for response class-----End----

            WsAccounts.doReply(myRequest);
            WsAccounts.wsGet();
            WsAccounts.getAccounts(u.Id) ;
            WsAccounts.getAccoutIds (listAccounts);
            WsAccounts.AccountWrapper results = new WsAccounts.AccountWrapper();
            results.account = listAccounts[0];
            results.visitScore = objVisitScoreResult.Result__c;
            results.lastVisitDate = objVisitScoreResult.Date__c;
            //system.assertEquals(listAccounts,RestContext.response);

            RestRequest req1 = new RestRequest();
            RestResponse res1 = new RestResponse();
            req1.requestURI = 'https://eu5.salesforce.com/services/apexrest/Accounts';
            req1.httpMethod = 'GET';
            RestContext.request = req1;
            RestContext.response = res1;
            UcbWsRequest myRequest1 = new UcbWsRequest(RestContext.request);
            WsAccounts.wsGet();
            Test.stopTest();
        }
    }


}