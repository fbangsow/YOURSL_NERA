/*
@Company:Your SL
@Author:Jyothi
@Creation date:21/08/2015
Reference:
*/

trigger PromotionHashkey on Promotion__c (after insert, after update, after delete, after undelete) {
	if(NeraTriggerCustomSetting__c.getValues('PromotionHashkey').IsActive__c) {
		List<Promotion__c> myO = new List<Promotion__c> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}

}