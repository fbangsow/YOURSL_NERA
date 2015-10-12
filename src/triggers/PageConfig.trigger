/***********************************************************************************************
 * MoldTek Technologies
 * Copyrights @ 2015
 * File: PageConfigTgr.Tgr
 *
 * Version        Date            Author                        Description
 * --------       ----------      -----------------------       -------------------
 * 1.0            04/18/2015      Srinivasa Reddy Donapati      Initial Creation
 *
 ************************************************************************************************/
 
/************************************************************************************************
 * Trigger on PageConfig__c
 ************************************************************************************************/
Trigger PageConfig on PageConfig__c (after insert, after update)
{
    if(NeraTriggerCustomSetting__c.getValues('PageConfig').IsActive__c) {
    	// populate hash key
    	PageConfigHelper.populateHashKey(Trigger.new, Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
	}
}