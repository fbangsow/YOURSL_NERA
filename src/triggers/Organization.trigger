/*
@Company:Your SL
@Author:Jyothi .M
@Creation date:22/08/2015
Reference:
*/

trigger Organization on Organization__c (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('Organization').IsActive__c) {
		// Trigger.new
		List<Organization__c> myO = new List<Organization__c>();
		UcbHashKey.upsertHashKeyValue(myO);
	}	
}