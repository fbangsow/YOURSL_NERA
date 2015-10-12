/***********************************************************************************************
 * MoldTek Technologies
 * Copyrights @ 2015
 * File: UIControlTgr.Tgr
 *
 * Version        Date            Author                        Description
 * --------       ----------      -----------------------       -------------------
 * 1.0            04/18/2015      Srinivasa Reddy Donapati      Initial Creation
 *
 ************************************************************************************************/
 
/************************************************************************************************
 * Trigger on UIControl__c
 ************************************************************************************************/
Trigger UIControl on UIControl__c (after insert, after update)
{
    if(NeraTriggerCustomSetting__c.getValues('UIControl').IsActive__c) {
    	// populate hash key
    	UIControlHelper.populateHashKey(Trigger.new, Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
    }
}