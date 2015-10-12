/*
@Company:Your SL
@Author:Jyothi.M
@Creation date:22/08/2015
Reference:
*/

trigger OrganizationAccountMember on OrganizationAccountMember__c (after insert, after update, after delete,after undelete) {
 	if(NeraTriggerCustomSetting__c.getValues('OrganizationAccountMember').IsActive__c) {
 		// Trigger.new
		List<OrganizationAccountMember__c> myO = new List<OrganizationAccountMember__c>();
		UcbHashKey.upsertHashKeyValue(myO);
	}
}