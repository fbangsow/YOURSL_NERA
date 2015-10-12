/*
@Company:Your SL
@Author:Jyothi 
@Creation date:23/07/2015
Reference:
*/
trigger EventHashKey on Event (after insert, after update, after delete,after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('EventHashKey').IsActive__c) {
    	// Trigger.new
    	List<Event> myO = new List<Event> ();
    	UcbHashKey.upsertHashKeyValue(myO);
    }
}