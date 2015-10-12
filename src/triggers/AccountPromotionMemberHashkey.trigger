/*
@Company:Your SL
@Author:Jyothi
@Creation date:21/08/2015
Reference:
*/

trigger AccountPromotionMemberHashkey on AccountPromotionMember__c (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('AccountPromotionMemberHashkey').IsActive__c) {
		List<AccountPromotionMember__c> myO = new List<AccountPromotionMember__c> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}	
}