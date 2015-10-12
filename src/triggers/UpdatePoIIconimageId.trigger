/***********************************************************************************************
 * MoldTek Technologies
 * Copyrights @ 2015
 * File: PageConfigTgr.Tgr
 *
 * Version        Date            Author                        Description
 * --------       ----------      -----------------------       -------------------
 * 1.0            07/29/2015      veeranjaneyulu     Initial Creation
 *
 ************************************************************************************************/
 
/************************************************************************************************
 * Trigger on UIcontrol__C
 ************************************************************************************************/

trigger UpdatePoIIconimageId on UIControl__c (before insert,before update) 

{
if(NeraTriggerCustomSetting__c.getValues('UpdatePoIIconimageId').IsActive__c) {	
set<Id> setPOItype = new Set<Id>();
for(UIControl__c uiControl : trigger.new)
{
    setPOItype.add(uiControl.POIType__c);
}

Map<Id,POIType__c> mapPOIs = new Map<Id,POIType__c>([SELECT Id, Name,AttachmentId__c FROM POIType__c WHERE Id IN: setPOItype]);

for(UIControl__c uiControl : trigger.new)
{
    if(mapPOIs!=null && mapPOIs.get(UiControl.PoiType__c)!=null)
    	uiControl.PoiIconImageId__c= mapPOIs.get(UiControl.PoiType__c).AttachmentId__c;
}

}

}