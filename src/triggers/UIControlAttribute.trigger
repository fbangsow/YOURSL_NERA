/*
@Company:Your SL
@Author:pavan kumar 
@Creation Date:6/4/2015
@Reference:
*/
Trigger UIControlAttribute on UIControlAttribute__c(after insert, after update)
{
    if(NeraTriggerCustomSetting__c.getValues('UIControlAttribute').IsActive__c) {	
    	// populate hash key
    	UIControlAttributeHelper.populateHashKey(Trigger.new, Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
	}
}