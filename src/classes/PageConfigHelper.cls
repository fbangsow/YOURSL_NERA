/***********************************************************************************************
 * MoldTek Technologies
 * Copyrights @ 2015
 * File: PageConfigHelper.Tgr
 *
 * Version        Date            Author                        Description
 * --------       ----------      -----------------------       -------------------
 * 1.0            04/18/2015      Srinivasa Reddy Donapati      Initial Creation
 *
 ************************************************************************************************/
public class PageConfigHelper
{
    // This method is used to populate hash key
    public static void populateHashKey(List<PageConfig__c> newPageConfigs, Map<Id, PageConfig__c> oldPageConfigsMap, Boolean isInsert, Boolean isUpdate)
    {
        Set<Id> appSettingIds = new Set<Id>();
        // capture all the appSettings  to be updated
        PageConfig__c oldPageConfigRecord;

        for(PageConfig__c newPageConfigRecord: newPageConfigs)
        {
            if(isUpdate)
            {
                // get old record
                oldPageConfigRecord = oldPageConfigsMap.get(newPageConfigRecord.Id);
            }
            // collect ids
            if(isInsert
                ||(isUpdate  && 
                        ( newPageConfigRecord.Name != oldPageConfigRecord.Name
                            || newPageConfigRecord.AppSetting__c != oldPageConfigRecord.AppSetting__c
                            || newPageConfigRecord.Image__c != oldPageConfigRecord.Image__c
                            || newPageConfigRecord.BackGround_Color__c!=oldPageConfigRecord.BackGround_Color__c
                            || newPageConfigRecord.AttachmentId__c != oldPageConfigRecord.AttachmentId__c
                            || newPageConfigRecord.BackGround_Color__c != oldPageConfigRecord.BackGround_Color__c
                            || newPageConfigRecord.DataBinding__c != oldPageConfigRecord.DataBinding__c
                            || newPageConfigRecord.Height__c != oldPageConfigRecord.Height__c
                            || newPageConfigRecord.Type__c != oldPageConfigRecord.Type__c
                            || newPageConfigRecord.Width__c != oldPageConfigRecord.Width__c
                            || newPageConfigRecord.XCoordinate__c != oldPageConfigRecord.XCoordinate__c
                            || newPageConfigRecord.YCoordinate__c != oldPageConfigRecord.YCoordinate__c
                            || newPageConfigRecord.PageConfigTypeId__c != oldPageConfigRecord.PageConfigTypeId__c
                           
                        ))
               )            

            {
               appSettingIds.add(newPageConfigRecord.AppSetting__c);
            }

        }
        
        List<AppSettings__c> appSettingsToUpdate = new List<AppSettings__c>();
        // update the hash key and put it in list for updating 
        for(Id currentAppSettingId : appSettingIds)
        {
            String hashKey = UCB_Utility.generateRandomHashKey();
            appSettingsToUpdate.add(new AppSettings__c(Id = currentAppSettingId, Hash_Key__c = hashKey));
        }
        // update AppSettings data
        update appSettingsToUpdate;
    }
    public static void populateHashKeyOnDelete(List<PageConfig__c> listconfig)
    {

        List<AppSettings__c> appSettingsToUpdate = new List<AppSettings__c>();
        // update the hash key and put it in list for updating 
        for(PageConfig__c myPageConfig : listconfig)
        {
            String hashKey = UCB_Utility.generateRandomHashKey();
            appSettingsToUpdate.add(new AppSettings__c(Id = myPageConfig.AppSetting__c, Hash_Key__c = hashKey));
        }
        // update AppSettings data
        update appSettingsToUpdate;
    }
    
}