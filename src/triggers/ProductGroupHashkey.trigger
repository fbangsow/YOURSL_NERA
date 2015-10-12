/*
@Company:Your SL
@Author:Jyothi
@Creation date:21/08/2015
Reference:
*/

trigger ProductGroupHashkey on ProductGroup__c (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('ProductGroupHashkey').IsActive__c) {
		List<ProductGroup__c> myO = new List<ProductGroup__c> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}
}