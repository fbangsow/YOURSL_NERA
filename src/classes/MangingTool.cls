public with sharing class MangingTool {
	 
	 public void insertPushtopic(){
	     PushTopic pushTopic = new PushTopic();
	     pushTopic.Name = 'AppErrorLog';
	     pushTopic.Query = 'SELECT Id, Name,AppVersion__c,DeviceId__c,DeviceOs__c,ExceptionId__c,UserId__c FROM AppErrorLog__c';
	     pushTopic.ApiVersion = 33.0;
     insert pushTopic;  
     }
}