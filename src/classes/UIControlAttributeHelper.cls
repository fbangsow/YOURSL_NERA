/*
@Company:
@Author:pavan kumar 
@Creation Date:6/4/2015
@Reference:
*/
public class UIControlAttributeHelper{

    // This method is used to populate hash key
    public static void populateHashKey( List<UIControlAttribute__c> newUiControlAttributes, Map<Id, UIControlAttribute__c> oldUiControlAttributesMap, Boolean isInsert, Boolean isUpdate)
    {
        Set<Id> uiControlNameIds  = new Set<Id>();
                       
        for(UIControlAttribute__c newUiControlAttributesRecord : newUiControlAttributes)
        {
            UIControlAttribute__c oldUiControlAttributesRecord;
            if(isUpdate)
            {
                // get old record
                oldUiControlAttributesRecord = oldUiControlAttributesMap.get(newUiControlAttributesRecord.Id);
            }
            // collect ids
            if( isInsert 
                || ( isUpdate
                && ( newUiControlAttributesRecord.Name != oldUiControlAttributesRecord.Name
                     ||   newUiControlAttributesRecord.DataObjectType__c != oldUiControlAttributesRecord.DataObjectType__c
                     ||   newUiControlAttributesRecord.Value__c != oldUiControlAttributesRecord.Value__c
                     ||   newUiControlAttributesRecord.Order__c != oldUiControlAttributesRecord.Order__c                      
                     ||   newUiControlAttributesRecord.UIControlId__c != oldUiControlAttributesRecord.UIControlId__c
                     ||   newUiControlAttributesRecord.UIControlAttributeGroupId__c != oldUiControlAttributesRecord.UIControlAttributeGroupId__c
                     ||   newUiControlAttributesRecord.UIControlAttributeTypeId__c != oldUiControlAttributesRecord.UIControlAttributeTypeId__c
                     ||   newUiControlAttributesRecord.Image__c != oldUiControlAttributesRecord.Image__c
                     ||   newUiControlAttributesRecord.IsHidden__c != oldUiControlAttributesRecord.IsHidden__c
                     ||   newUiControlAttributesRecord.AttachmentId__c !=oldUiControlAttributesRecord.AttachmentId__c
                     ||   newUiControlAttributesRecord.IsDefault__c != oldUiControlAttributesRecord.IsDefault__c 
                     ))  
               )
               
            {
                uiControlNameIds.add(newUiControlAttributesRecord.UIControlId__c);
            }
        }  
        List<UIControl__c> modifiedUiCtrls = new List<UIControl__c>([SELECT Id, Name, PageConfigName__c 
                                                                     FROM UIControl__c 
                                                                     WHERE id IN: uiControlNameIds]);  
         Set<Id> setModifiedPageConfigIds = new Set<Id>();
         
       
       for(UIControl__c modifiedPageConfigId : modifiedUiCtrls)
        {
            setModifiedPageConfigIds.add(modifiedPageConfigId.PageConfigName__c);
        }
                
        List<AppSettings__c> appSettingsToUpdate = new List<AppSettings__c>();
        Set<Id> appSettingIds = new Set<Id>();
        // capture all the appSettings  to be updated
        for(PageConfig__c currentPageConfig :[SELECT id, AppSetting__c 
                                              FROM PageConfig__c 
                                              WHERE id IN: setModifiedPageConfigIds])
        {
            appSettingIds.add(currentPageConfig.AppSetting__c);
        }
        // update the hash key and put it in list for updating
        for(Id currentAppSettingId : appSettingIds)
        {
            String hashKey = UCB_Utility.generateRandomHashKey();
            appSettingsToUpdate.add(new AppSettings__c(Id = currentAppSettingId, Hash_Key__c = hashKey));
        }
        // update AppSettings data
        update appSettingsToUpdate;                                
   }
   
   public static void populateHashKeyOnDelete( List<UIControlAttribute__c> listUiControlAttribute)
    {

        List<AppSettings__c> appSettingsToUpdate = new List<AppSettings__c>();
        List<PageConfig__c> pageConfigs = new List<PageConfig__c>();
        
        List<UIControl__c> listUiControl = [SELECT Id,PageConfigName__c
                                            FROM UIControl__c
                                            LIMIT 50000];
        List<PageConfig__c> listPageConfigs=[SELECT Id,AppSetting__c 
                                             FROM PageConfig__c
                                             LIMIT 50000];

        for(UIControlAttribute__c myUiControlAttribute : listUiControlAttribute)
        {
            for(UIControl__c myUiControl : listUiControl)
            {
                if(myUiControl.Id == myUiControlAttribute.UIControlId__c)
                for(PageConfig__c myPageConfig :listPageConfigs)
                {
                    if(myPageConfig.Id == myUiControl.PageConfigName__c)
                    {
                        pageConfigs.add(myPageConfig);
                        break;
                    }
                }
            }                
        }
        // update the hash key and put it in list for updating     
        for(PageConfig__c myFinalPageConfig : pageConfigs)
        {
            String hashKey = UCB_Utility.generateRandomHashKey();
            appSettingsToUpdate.add(new AppSettings__c(Id = myFinalPageConfig.AppSetting__c, Hash_Key__c = hashKey));
        }       
        // update AppSettings data
        update appSettingsToUpdate;
    }        
}