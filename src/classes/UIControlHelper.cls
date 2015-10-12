/***********************************************************************************************
 * MoldTek Technologies
 * Copyrights @ 2015
 * File: UIControlTgrHelper.Tgr
 *
 * Version        Date            Author                        Description
 * --------       ----------      -----------------------       -------------------
 * 1.0            04/18/2015      Srinivasa Reddy Donapati      Initial Creation
 *
 ************************************************************************************************/

/************************************************************************************************
 * This is trigger helper class that is used to update the hashkey when UI Control records are modified
 ************************************************************************************************/
public class UIControlHelper
{
    // This method is used to populate hash key
    public static void populateHashKey( List<UIControl__c> newUiControls, Map<Id, UIControl__c> oldUiControlsMap, Boolean isInsert, Boolean isUpdate)
    {

        Set<Id> PageConfigNameIds = new Set<Id>();
       
       
        // capture all the pageConfig ids of UI Controls that were changed
        for(UIControl__c newUiControlRecord : newUiControls)
        {
            UIControl__c oldUiControlRecord;
            if(isUpdate)
            {
                // get old record
                oldUiControlRecord = oldUiControlsMap.get(newUiControlRecord.Id);
            }
            // collect ids
            if( isInsert 
                || ( isUpdate
                     && ( newUiControlRecord.Name != oldUiControlRecord.Name
                        || newUiControlRecord.PageConfigName__c !=oldUiControlRecord.PageConfigName__c
                        || newUiControlRecord.XCoordinate__c != oldUiControlRecord.XCoordinate__c
                        || newUiControlRecord.YCoordinate__c != oldUiControlRecord.YCoordinate__c
                        || newUiControlRecord.Value__c!=oldUiControlRecord.Value__c
                        || newUiControlRecord.Order__c!=oldUiControlRecord.Order__c
                        || newUiControlRecord.IsHidden__c!=oldUiControlRecord.IsHidden__c
                        || newUiControlRecord.Image__c!=oldUiControlRecord.Image__c
                        || newUiControlRecord.AttachmentId__c !=oldUiControlRecord.AttachmentId__c   
                        || newUiControlRecord.Width__c != oldUiControlRecord.Width__c
                        || newUiControlRecord.Type__c != oldUiControlRecord.Type__c
                        || newUiControlRecord.IsDefault__c != oldUiControlRecord.IsDefault__c
                        || newUiControlRecord.FieldName__c != oldUiControlRecord.FieldName__c
                        || newUiControlRecord.FieldType__c != oldUiControlRecord.FieldType__c
                        || newUiControlRecord.Height__c != oldUiControlRecord.Height__c

                        ))
                )
            {
                PageConfigNameIds.add(newUiControlRecord.PageConfigName__c);
            }
        }

        List<PageConfig__c> listPageConfig = [SELECT Id, AppSetting__c 
                                              FROM PageConfig__c 
                                              WHERE id IN: PageConfigNameIds];
                                              
        List<AppSettings__c> appSettingsToUpdate = new List<AppSettings__c>();
        Set<Id> appSettingIds = new Set<Id>();
               
        // capture all the appSettings  to be updated
        for(PageConfig__c currentPageConfig : listPageConfig)
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

    public static void populateHashKeyOnDelete( List<UIControl__c> listUiControl)
    {

        List<AppSettings__c> appSettingsToUpdate = new List<AppSettings__c>();
        List<PageConfig__c> pageConfigs = new List<PageConfig__c>();

        List<PageConfig__c> listPageConfigs=[SELECT Id,AppSetting__c 
                                             FROM PageConfig__c
                                             LIMIT 50000 ];

        for(UIControl__c myUiControl : listUiControl)
        {
            for(PageConfig__c myPageConfig :listPageConfigs)
            {
                if(myPageConfig.Id == myUiControl.PageConfigName__c)
                {
                    pageConfigs.add(myPageConfig);
                    break;
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