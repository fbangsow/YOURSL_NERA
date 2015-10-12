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
trigger Poitypeimageupdate on POIType__c (after update) 
{

if(NeraTriggerCustomSetting__c.getValues('Poitypeimageupdate').IsActive__c) {

//List<UiControls__c> ListUicontol = new List<UiControls__c>();
Set<Id> setPOIids = new Set<Id>();
for(POIType__c Poitypeupdate : trigger.new)
{
setPOIids.add(Poitypeupdate.id);
 //Uicontol.add(Poitypeupdate.Attachmentid__C);
}

Map<Id,UIControl__c> mapUiControls = new Map<Id,UIControl__c>([SELECT Id,PoiIconImageId__c FROM UIControl__c WHERE POIType__c IN:setPOIids]);

If(!mapUiControls.values().isEmpty())
    update mapUiControls.values();
}
}