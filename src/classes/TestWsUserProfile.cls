/*
@Company:Your SL
@Author:Asritha
@Creation date:8/8/2014
@Reference: 
*/
@isTest(SeeAllData=true)
private class TestWsUserProfile {

	static testmethod void doGet()	{
		
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'standt', Email = 'venkata.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'venkata.r@neradeveloprrrent.demodev');

        insert u;
		UserProfile__c objUserProfile = new UserProfile__c(User__c = u.id);
		insert objUserProfile;
		Attachment attach = new Attachment(Name = 'attachName',body = Blob.valueOf('attachbody'), parentId = objUserProfile.id);
		insert attach;
		objUserProfile.AttachmentId__c = attach.Id;
		update objUserProfile;
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = 'https://eu5.salesforce.com/services/apexrest/UserProfile';
		req.addParameter('userId', u.Id);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		WsUserProfile.wsGet();
		System.assertEquals(200,RestContext.response.statusCode);
		
	}
	static testmethod void doGetElse()	{
		
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'standt', Email = 'venkata.r@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'venkata.r@neradeveloprrrent.demodev');

        insert u;
		UserProfile__c objUserProfile = new UserProfile__c(User__c = u.id);
		insert objUserProfile;
		Attachment attach = new Attachment(Name = 'attachName',body = Blob.valueOf('attachbody'), parentId = objUserProfile.id);
		insert attach;
		objUserProfile.AttachmentId__c = attach.Id;
		update objUserProfile;
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = 'https://eu5.salesforce.com/services/apexrest/UserProfile';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		WsUserProfile.wsGet();
		System.assertEquals(400,RestContext.response.statusCode);
	}
	
	
	
	
}