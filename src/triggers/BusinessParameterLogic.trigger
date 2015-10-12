/*
@Company:Your SL
@Author:Jyothi.M
@Creation date:22/08/2015
Reference:
*/


trigger BusinessParameterLogic on BusinessProcessParameter__c (after insert, after update, after delete,after undelete) {
	if(NeraTriggerCustomSetting__c.getValues('BusinessParameterLogic').IsActive__c) {
		List<BusinessProcessParameter__c> myO = new List<BusinessProcessParameter__c>();
		UcbHashKey.upsertHashKeyValue(myO);
	}
}