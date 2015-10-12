/*
@Company:Your SL
@Author:Jyothi
@Creation date:21/08/2015
Reference:
*/

trigger OrganizationPromotionMemberHashkey on OrganizationPromotionMember__c (after insert, after update, after delete, after undelete) {
	if(NeraTriggerCustomSetting__c.getValues('OrganizationPromotionMemberHashkey').IsActive__c) {
		List<OrganizationPromotionMember__c> myO = new List<OrganizationPromotionMember__c> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}
}