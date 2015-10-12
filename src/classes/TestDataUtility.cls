/*
 @Company: YOUR SL
 @Author: KVE
 @Creation date: 14 /06/ 2015
 @Ref: Create for custom settings data
*/
public with sharing class TestDataUtility {

   public static void createNeraTriggerCustomSetting(){
		//Inserting NeraTriggerCustomSetting
		List<NeraTriggerCustomSetting__c> listNeraTriggerCustomSetting = new List<NeraTriggerCustomSetting__c>();
		
listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountHashKey', IsActive__c = True));
		
		listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AppsettingPostDeployment', IsActive__c = True));
		listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'CampaignMember', IsActive__c = True));
		listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Poitypeimageupdate', IsActive__c = True));
		listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'UpdatePoIIconimageId', IsActive__c = True));
		listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'VisitScoreupdate', IsActive__c = True));
		
		insert listNeraTriggerCustomSetting;
	}
}