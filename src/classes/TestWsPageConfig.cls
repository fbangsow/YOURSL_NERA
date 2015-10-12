/*
 @Company: YOUR SL  
 @Author: Asritha   
 @Creation date: 18/8/2015   
 @Ref: xxxx
*/
@isTest
private class TestWsPageConfig {
	
	static testmethod void doGet()	{

		MobileDevice__c mobiledeviceobj = new MobileDevice__c ( Name = 'IPadAir2',operatingSystem__c = 'IOS 8',height__c = 768,width__c = 1024);
		insert mobiledeviceobj;
		AppSettings__c appSettingObj = new AppSettings__c( Name = 'IPadAir2',mobileDevice__c = mobiledeviceobj.Id,version__c = '1.0.0.0');
		insert appsettingObj;
		PageConfig__c pageConfigobj = new PageConfig__c( Name = 'SplashScreen',AppSetting__c = appsettingObj.Id);
		insert pageConfigobj;
		Attachment attach = new Attachment(Name = 'attachName', body = Blob.valueOf('NeraLogo'),parentId = pageConfigobj.id);
		insert attach;
		RestRequest req = new RestRequest();
		req.requestURI = 'https://eu5.salesforce.com/services/apexrest/PageConfig';
		req.httpMethod = 'Get';
		RestResponse res = new RestResponse();
		RestContext.request = req;
		RestContext.response = res;
		// WsPageConfig.WsGet();
	}
	
}