/*
@Company:Your SL
@Author:Jyothi 
@Creation date:23/07/2015
Reference:
*/

trigger AccountHashKey on Account (after insert, after update, after delete,after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('AccountHashKey').IsActive__c) {
		// Trigger.new
    	List<Account> myO = new List<Account> ();
    	UcbHashKey.upsertHashKeyValue(myO);
	}

}