/*
 @Company: YOUR SL
 @Author: KVE
 @Creation date: 14 /06/ 2015
 @Ref: Create dashboard for editing app settings
*/
public with sharing class CleanupTestData {

    public static void run(boolean defaultValue) {
        //Deleting stringCatalogItems
        List<StringCatalogItem__c> stringCatalogItemsList = [SELECT Id
                                                        FROM StringCatalogItem__c
                                                        WHERE IsDefault__c != : defaultValue];
        if (!stringCatalogItemsList.isEmpty()) {
            delete  stringCatalogItemsList;
            System.debug('stringCatalogItemsList -->' + stringCatalogItemsList.size());
        }
        
        //Deleting uiControlAttribute
        List<UIControlAttribute__c> uiControlAttribute = [SELECT Id
                                                        FROM UIControlAttribute__c
                                                        WHERE IsDefault__c != : defaultValue];
        if (!uiControlAttribute.isEmpty()) {
            delete  uiControlAttribute;
            System.debug('uiControlAttribute -->' + uiControlAttribute.size());
        }
        //Deleting uiControlAttributeType
        List<UIControlAttributeType__c> uiControlAttributeType = [SELECT Id
                                                                    FROM UIControlAttributeType__c
                                                                    WHERE IsDefault__c != : defaultValue];
        if (!uiControlAttributeType.isEmpty()) {
            delete  uiControlAttributeType;
            System.debug('uiControlAttributeType -->' + uiControlAttributeType.size());
        }

        //Deleting uiControlAttributeGroup
        List<UIControlAttributeGroup__c> uiControlAttributeGroup = [SELECT Id
                                                                    FROM UIControlAttributeGroup__c
                                                                    WHERE IsDefault__c != : defaultValue];
        if (!uiControlAttributeGroup.isEmpty()) {
            delete  uiControlAttributeGroup;
            System.debug('uiControlAttributeGroup -->' + uiControlAttributeGroup.size());
        }

        //Deleting uiControl
        List<UIControl__c> uiControl = [SELECT Id
                                        FROM UIControl__c
                                        WHERE IsDefault__c != : defaultValue];
        if (!uiControl.isEmpty()) {
            delete  uiControl;
            System.debug('uiControl -->' + uiControl.size());
        }

        //Deleting uiControlType
        List<UIControlType__c> uiControlType = [SELECT Id
                                                FROM UIControlType__c
                                                WHERE IsDefault__c != : defaultValue];
        if (!uiControlType.isEmpty()) {
            delete  uiControlType;
            System.debug('uiControlType -->' + uiControlType.size());
        }

        //Deleting uiControlGroup
        List<UIControlGroup__c> uiControlGroup = [SELECT Id
                                                FROM UIControlGroup__c
                                                WHERE IsDefault__c != : defaultValue];
        if (!uiControlGroup.isEmpty()) {
            delete  uiControlGroup;
            System.debug('uiControlGroup -->' + uiControlGroup.size());
        }

        //Deleting pageConfig
        List<PageConfig__c> pageConfig = [SELECT Id
                                          FROM PageConfig__c
                                          WHERE IsDefault__c != : defaultValue];
        if (!pageConfig.isEmpty()) {
            delete  pageConfig;
            System.debug('pageConfig -->' + pageConfig.size());
        }

        //Deleting pageConfigTypes
        List<PageConfigType__c> pageConfigType = [SELECT Id
                                                FROM PageConfigType__c
                                                WHERE IsDefault__c != : defaultValue];
        if (!pageConfigType.isEmpty()) {
            delete  pageConfigType;
            System.debug('pageConfigType -->' + pageConfigType.size());
        }

        //Deleting appSetting
        List<AppSettings__c> appSettings = [SELECT Id
                                            FROM AppSettings__c
                                            WHERE IsDefault__c != : defaultValue];
        if (!appSettings.isEmpty()) {
            delete  appSettings ;
            System.debug('appSettings -->' + appSettings.size());
        }

        //Deleting mobileDevices
        List<MobileDevice__c> mobileDevice = [SELECT Id
                                              FROM MobileDevice__c
                                              WHERE IsDefault__c != : defaultValue];
        if (!mobileDevice.isEmpty()) {
            delete  mobileDevice;
            System.debug('mobileDevice -->' + mobileDevice.size());
        }

        List<Attachment> listAttachment = [SELECT Id
                                              FROM Attachment
                                              ];
        if (!listAttachment.isEmpty()) {
            delete  listAttachment;
            System.debug('mobileDevice -->' + mobileDevice.size());
        }
        
        List<Businessprocess__c> listBusinessprocess = [SELECT Id FROM Businessprocess__c];
        if(!listBusinessprocess.isEmpty()){
            delete listBusinessprocess;
            System.debug('Businessprocess----------------'+listBusinessprocess.size());
        }
        
        List<BusinessProcessParameter__c> listBusinessProcessParameter = [SELECT Id FROM BusinessProcessParameter__c];
        if(!listBusinessProcessParameter.isEmpty()){
            delete listBusinessProcessParameter;
            System.debug('listBusinessProcessParameter----------------'+listBusinessProcessParameter.size());
        }
        
        List<Product2>  listProduct2 = [SELECT Id FROM Product2];       
        if(!listProduct2.isEmpty()){
            delete listProduct2;
            system.debug('listProduct2---------------'+listProduct2.size());
        }
        
        List<ProductGroup__c> listProductGroup = [SELECT Id FROM ProductGroup__c];
        if(!listProductGroup.isEmpty()){
            delete listProductGroup;
            system.debug('listProductGroup---------------------'+listProductGroup.size());
        }
        List<ProductGroupMember__c> listProductGroupMember = [SELECT Id FROM ProductGroupMember__c];
        if(!listProductGroupMember.isEmpty()){
            delete listProductGroupMember;
            system.debug('listProductGroupMember--------------'+listProductGroupMember.size());
        }
        List<Pricebook2> listPriceBook2 = [SELECT Id FROM Pricebook2 WHERE isStandard=false];
        if(!listPriceBook2.isEmpty()){
            delete listPriceBook2;
            system.debug('listPriceBook2-------------'+listPriceBook2.size());
        }
        List<PricebookEntry> listPricebookEntry = [SELECT Id FROM PricebookEntry];
        if(!listPricebookEntry.isEmpty()){
            delete listPricebookEntry;
            system.debug('listPricebookEntry-----------------'+listPricebookEntry.size());
        }
        List<Account> listAccount = [SELECT Id FROM Account where Name NOT IN ('GenePoint','United Oil & Gas, UK','United Oil & Gas, Singapore','Edge Communications','Burlington Textiles Corp of America','Grand Hotels & Resorts Ltd','Express Logistics and Transport','University of Arizona','United Oil & Gas Corp.')];
        if(!listAccount.isEmpty()){
            delete listAccount;
            system.debug('listAccount--------------------'+listAccount.size());
        }
        List<AccountPriceBookMember__c> listAccountPriceBookMember = [SELECT Id FROM AccountPriceBookMember__c];
        if(!listAccountPriceBookMember.isEmpty()){
            delete listAccountPriceBookMember;
            system.debug('listAccountPriceBookMember-----------------'+listAccountPriceBookMember.size());
        }
        
        List<Promotion__c> listPromotion = [SELECT Id FROM Promotion__c];
        if(!listPromotion.isEmpty()){
            delete listPromotion;
            system.debug('listPromotion-----------------'+listPromotion.size());
        }
        List<AccountPromotionMember__c> listAccountPromotionMember = [SELECT Id FROM AccountPromotionMember__c];
        if(!listAccountPromotionMember.isEmpty()){
            delete listAccountPromotionMember;
            system.debug('listAccountPromotionMember--------------'+listAccountPromotionMember.size());
        }
        List<PromotionMember__c> listPromotionMember = [SELECT Id FROM PromotionMember__c];
        if(!listPromotionMember.isEmpty()){
            delete listPromotionMember;
            system.debug('listPromotionMember-------------------'+listPromotionMember.size());
        }
        List<Organization__c> listOrganization = [SELECT Id FROM Organization__c];  
        if(!listOrganization.isEmpty()){
            delete listOrganization;
            system.debug('listOrganization----------------'+listOrganization.size());
        }
        List<OrganizationAccountMember__c> listOrganizationAccountMember = [SELECT Id FROM OrganizationAccountMember__c];
        if(!listOrganizationAccountMember.isEmpty()){
            delete listOrganizationAccountMember;
            system.debug('listOrganizationAccountMember------------------'+listOrganizationAccountMember.size());
        }
        List<OrganizationPriceBookMember__c> listOrganizationPriceBookMember = [SELECT Id FROM OrganizationPriceBookMember__c];
        if(!listOrganizationPriceBookMember.isEmpty()){
            delete listOrganizationPriceBookMember;
            system.debug('listOrganizationPriceBookMember------------------------'+listOrganizationPriceBookMember.size());
        }
        List<OrganizationPromotionMember__c> listOrganizationPromotionMember = [SELECT Id FROM OrganizationPromotionMember__c];
        if(!listOrganizationPromotionMember.isEmpty()){
            delete listOrganizationPromotionMember;
            system.debug('listOrganizationPromotionMember-----------'+listOrganizationPromotionMember.size());
        }
    }
    
    public static void createNeraTriggerCustomSetting(){
        //Inserting NeraTriggerCustomSetting
        List<NeraTriggerCustomSetting__c> listNeraTriggerCustomSetting = new List<NeraTriggerCustomSetting__c>();
        
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountHashKey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountPriceBookMemberHashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AccountPromotionMemberHashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'AppsettingPostDeployment', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'BusinessLogic', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'BusinessParameterLogic', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'EventHashKey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Organization', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'OrganizationAccountMember', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'OrganizationPromotionMemberHashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'PageConfig', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Pricebook2Hashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'ProductGroupHashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'Product2Hashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'PromotionHashkey', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'UIControl', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'UIControlAttribute', IsActive__c = True));
        listNeraTriggerCustomSetting.add( new NeraTriggerCustomSetting__c(Name = 'ValidateOverlapping', IsActive__c = True));
        listNeraTriggerCustomSetting.add(new NeraTriggerCustomSetting__c(Name = 'VisitFrequency', IsActive__c = True));
        listNeraTriggerCustomSetting.add(new NeraTriggerCustomSetting__c(Name = 'OrgPotentialAvailability', IsActive__c = True));
        listNeraTriggerCustomSetting.add(new NeraTriggerCustomSetting__c(Name = 'ValidateStorm', IsActive__c = True));

        insert listNeraTriggerCustomSetting;
    }
}