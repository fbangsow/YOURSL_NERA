/*
 @Company: YOUR SL
 @Author: KVE
 @Creation date: 14 /06/ 2015
 @Ref: Create for custom settings data
*/
public with sharing class TestDataUtility {

	public static void createNeraTriggerCustomSetting() {
		//Inserting NeraTriggerCustomSetting
		List<NeraTriggerCustomSetting__c> listNeraTriggerCustomSetting = new List<NeraTriggerCustomSetting__c>();
		if(NeraTriggerCustomSetting__c.getValues('AccountHashKey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountHashKey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('AccountPriceBookMemberHashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountPriceBookMemberHashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('AccountPromotionMemberHashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountPromotionMemberHashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('AppsettingPostDeployment')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AppsettingPostDeployment', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('BusinessLogic')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'BusinessLogic', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('BusinessParameterLogic')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'BusinessParameterLogic', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('EventHashKey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'EventHashKey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('Organization')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Organization', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('OrganizationAccountMember')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'OrganizationAccountMember', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('OrganizationPromotionMemberHashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'OrganizationPromotionMemberHashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('PageConfig')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'PageConfig', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('Pricebook2Hashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Pricebook2Hashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('ProductGroupHashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'ProductGroupHashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('Product2Hashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Product2Hashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('PromotionHashkey')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'PromotionHashkey', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('UIControl')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'UIControl', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('UIControlAttribute')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'UIControlAttribute', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('ValidateOverlapping')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'ValidateOverlapping', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('VisitFrequency')==null)
			listNeraTriggerCustomSetting.add(new NeraTriggerCustomSetting__c(Name = 'VisitFrequency', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('OrgPotentialAvailability')==null)
			listNeraTriggerCustomSetting.add(new NeraTriggerCustomSetting__c(Name = 'OrgPotentialAvailability', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('ValidateStorm')==null)
			listNeraTriggerCustomSetting.add(new NeraTriggerCustomSetting__c(Name = 'ValidateStorm', IsActive__c = True));

		//if(NeraTriggerCustomSetting__c.getValues('AppsettingPostDeployment')==null)
			//listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AppsettingPostDeployment', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('CampaignMember')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'CampaignMember', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('Poitypeimageupdate')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Poitypeimageupdate', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('UpdatePoIIconimageId')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'UpdatePoIIconimageId', IsActive__c = True));
		if(NeraTriggerCustomSetting__c.getValues('VisitScoreupdate')==null)
			listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'VisitScoreupdate', IsActive__c = True));

		insert listNeraTriggerCustomSetting;
	}
}