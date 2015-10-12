/*
@Company:Your SL
@Author:Jyothi
@Creation date:22/08/2015
Reference:
*/

trigger Pricebook2Hashkey on Pricebook2 (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('Pricebook2Hashkey').IsActive__c) {
		List<Pricebook2> myO = new List<Pricebook2> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}

}