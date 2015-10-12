/*
@Company:Your SL
@Author:Jyothi
@Creation date:21/08/2015
Reference:
*/

trigger AccountPriceBookMemberHashkey on AccountPriceBookMember__c (after insert, after update, after delete, after undelete) {

	if(NeraTriggerCustomSetting__c.getValues('AccountPriceBookMemberHashkey').IsActive__c) {
		List<AccountPriceBookMember__c> myO = new List<AccountPriceBookMember__c> ();
		UcbHashKey.upsertHashKeyValue(myO);
	}	
}