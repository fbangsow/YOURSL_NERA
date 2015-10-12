/*
@Company        :Your SL
@Author         :Imran Shaik
@Creation date  :07/08/2015
@Reference      :
*/
@isTest
global class TestWsBusinessProcess {
	
	static testMethod void testWsBusinessProcessIf() {
		CleanupTestData.createNeraTriggerCustomSetting();
	    
		Test.startTest();
			List<BusinessProcess__c> listBusinessProcess = new List<BusinessProcess__c>();
				listBusinessProcess.add(new BusinessProcess__c(Name='test1',IsDefault__c=true));
				listBusinessProcess.add(new BusinessProcess__c(Name='test2',IsDefault__c=true));
			Insert listBusinessProcess;
			List<BusinessProcessParameter__c> listBusinessProcessPar = new List<BusinessProcessParameter__c>();
				listBusinessProcessPar.add(new BusinessProcessParameter__c(Name='testParaMeter',BusinessprocessId__c=listBusinessProcess[0].Id,Values__c='data'));
				listBusinessProcessPar.add(new BusinessProcessParameter__c(Name='testParaMeter1',BusinessprocessId__c=listBusinessProcess[1].Id,Values__c='data1'));
			Insert listBusinessProcessPar;

			RestRequest req = new RestRequest();
				req.requestURI = 'https://eu5.salesforce.com/services/apexrest/BusinessProcess';
				req.httpMethod = 'GET';
			RestResponse res = new RestResponse();

			RestContext.request = req;
        	RestContext.response = res;
        	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        	WsBusinessProcess.doReply(myRequest);
        	WsBusinessProcess.wsGet();

        	System.assertEquals('200', RestContext.response.headers.get('statusCode'));       	
		Test.stopTest();
	}
	static testMethod void testWsBusinessProcessElse(){
		RestRequest req = new RestRequest();
			req.requestURI = 'https://eu5.salesforce.com/services/apexrest/BusinessProcess';
			req.httpMethod = 'GET';
		RestResponse res = new RestResponse();

		RestContext.request = req;
    	RestContext.response = res;
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	WsBusinessProcess.doReply(myRequest);
    	WsBusinessProcess.wsGet();

    	System.assertEquals('400', RestContext.response.headers.get('statusCode'));
	}
}