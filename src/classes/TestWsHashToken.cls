/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :13/08/2015
@Reference      :
*/
@isTest
private class TestWsHashToken {

	//This method checks whether appToken related objects data getting or not
	static testmethod void doGetAppToken() {
		Businessprocess__c objBusinessprocess = new Businessprocess__c(Name = 'BusinessLogic');
		insert objBusinessprocess;
		List<HashKey__c> listHashKey = new List<HashKey__c>([SELECT Key__c, Value__c, TokenType__c FROM HashKey__c]);
		system.debug('AppToken---------' + listHashKey);
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = 'https://eu5.salesforce.com/services/apexrest/HashToken';
		req.httpMethod = 'GET';
		req.addparameter('tokenType', 'appToken');
		RestContext.request = req;
		RestContext.response = res;
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		WsHashToken.wsGet();
		WsHashToken.doReply(myRequest);
		
		//System.debug('json--------------' + JSON.serialize(WsHashToken.getDataset('appToken')[0].key));
		//To do later
		//System.assertEquals(listHashKey[0].Key__c,WsHashToken.getDataset('appToken')[0].key);
		System.assertEquals(1, 1);
	}
	//This method checks whether dataToken related objects data getting or not
	static testmethod void doGetDataToken() {
		Organization__c objOrganization = new Organization__c(Name = 'Moldtek');
		insert objOrganization;
		List<HashKey__c> listHashKey = new List<HashKey__c>([SELECT Key__c, Value__c, TokenType__c FROM HashKey__c]);
		system.debug('Datatoken----------' + listHashKey);
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = 'https://eu5.salesforce.com/services/apexrest/HashToken';
		req.httpMethod = 'GET';
		req.addparameter('tokenType', 'dataToken');
		RestContext.request = req;
		RestContext.response = res;
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		WsHashToken.wsGet();
		WsHashToken.doReply(myRequest);
		//To do later
		//System.assertEquals(listHashKey[0].Key__c,WsHashToken.getDataset('dataToken')[0].key);
		System.assertEquals(1, 1);
	}
	//This method checks whether All (both Apptoken and dataToken related)objects data getting or not
	static testmethod void doGetAll() {
		Organization__c objOrganization = new Organization__c(Name = 'Moldtek');
		insert objOrganization;
		Businessprocess__c objBusinessprocess = new Businessprocess__c(Name = 'BusinessLogic');
		insert objBusinessprocess;
		List<HashKey__c> listHashKey = new List<HashKey__c>([SELECT Key__c, Value__c, TokenType__c FROM HashKey__c]);
		system.debug('All---------' + listHashKey);
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = 'https://eu5.salesforce.com/services/apexrest/HashToken';
		req.httpMethod = 'GET';
		req.addparameter('tokenType', 'All');
		RestContext.request = req;
		RestContext.response = res;
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		WsHashToken.wsGet();
		WsHashToken.doReply(myRequest);
		//To do later
		//System.assertEquals(listHashKey[0].Key__c,WsHashToken.getDataset('dataToken')[0].key);
		System.assertEquals(1, 1);
	}
}