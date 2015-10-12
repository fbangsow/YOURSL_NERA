/*
@Company:Your SL
@Author:Jyothi.M
@Creation date:22/08/2015
Reference:
*/

trigger BusinessLogic on Businessprocess__c (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('BusinessLogic').IsActive__c) {
		// Trigger.new
		List<Businessprocess__c> myO = new List<Businessprocess__c>();
		UcbHashKey.upsertHashKeyValue(myO);
	}
}