/*
@Company:Your SL
@Author:Jyothi
@Creation date:21/08/2015
Reference:
*/

trigger Product2Hashkey on Product2 (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('Product2Hashkey').IsActive__c) {
		List<Product2> myO = new List<Product2> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}
}