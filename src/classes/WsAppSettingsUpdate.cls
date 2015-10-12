/***********************************************************************************************
 * MoldTek Technologies
 * Copyrights @ 2015
 * File: UCB_RESTMobileController.Cls
 *
 * Version        Date            Author                        Description
 * --------       ----------      -----------------------       -------------------
 * 1.0            04/17/2015      Srinivasa Reddy Donapati      Initial Creation
 *
 ************************************************************************************************/
 
/************************************************************************************************
 * This class is used to expose REST service for validating Hash Key changes
 ************************************************************************************************/
@RestResource(urlMapping='/AppSettingsUpdate/*')
global with sharing class WsAppSettingsUpdate
{
    // This method is used to validate the HashKey changes
    @HttpGet
    global static void validateApplicationSettings() 
    {
        String jsonResponse='';
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);

        try
        {   
            String hashId = RestContext.request.params.get('hashId');
            String deviceType = RestContext.request.params.get('deviceType');
            String appVersion = RestContext.request.params.get('appVersion');
            
            MobileDevice__c mobileDeviceID;
            AppSettings__c appSettingsID; 
            System.debug('@@@ DeviceType== '+deviceType + ' @@@ AppVersion=='+ appVersion + ' @@@ HashId==' + hashId);

            if( hashId == null || deviceType == null || appVersion == null)
            {
                myRequest.statusCode = 400;
                myRequest.errorMessage = 'Missing Required Parameters';
            }
            else 
            {

                System.debug('Query Paramms @@@ DeviceType== '+deviceType + ' @@@ AppVersion=='+ appVersion + ' @@@ HashId==' + hashId);

                List<MobileDevice__c> listMobileDevices = [select id from MobileDevice__c where Name = :deviceType];
                if (listMobileDevices.Size() > 0) {
                    mobileDeviceID = listMobileDevices[0];
                }

                List<AppSettings__c> listAppSettings = [select id, version__c, Hash_Key__c  from AppSettings__c where version__c = : appVersion and mobileDevice__c = :mobileDeviceID.Id];
                if (listAppSettings.Size() > 0) {
                    appSettingsID =listAppSettings[0];
                }
   
                System.debug('@@@ appSettingsID for update check is ' + appSettingsID);
                // query AppSetting for applicationId passed in the request
                List<AppSettings__c> appSettingRecords = [Select Id, Name, version__c, Hash_Key__c, mobileDevice__c, mobileDevice__r.Name, 
                                                            mobileDevice__r.height__c, mobileDevice__r.operatingSystem__c, mobileDevice__r.width__c  
                                                           From AppSettings__c where id =: appSettingsID.Id];
                    
                System.debug('appSettingRecord-->'+appSettingRecords);
                
                if(appSettingRecords.isEmpty())
                {
                    myRequest.statusCode = 400;
                    myRequest.errorMessage = 'No corresponding AppSettings found';
                }
                else
                {
                    AppSettings__c currentAppSettingRecord = appSettingRecords[0]; 
                    if(hashId == currentAppSettingRecord.Hash_Key__c)
                    {
                        // return 'false' as response if hashKey is not changed
                        System.debug('Hash Key on Server'+ currentAppSettingRecord.Hash_Key__c + ' @@@HashId on App==' + hashId + ' are equal');

                        myRequest.statusCode = 304;
                        myRequest.errorMessage = 'AppSettings have not changed';
                        jsonResponse = JSON.serialize('');
                    }
                    else
                    {
                        myRequest.statusCode = 200;
                        myRequest.errorMessage = 'AppSettings have changed';
                        jsonResponse = JSON.serialize(Globals_Services.getAppSettingsJson(currentAppSettingRecord));
                    }
                }

                System.debug('appSettingRecord--> End of try block ..');

            }
        }
        catch(Exception exceptionData)
        { 
            // handle exceptions
            System.debug('exceptionData-->'+exceptionData);
            myRequest.statusCode = 404;
            myRequest.errorMessage = 'Bad Request';
        }

        System.debug('final jsonResponse-->'+jsonResponse);

        RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);    
        RestContext.response.statusCode = myRequest.statusCode;
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
 
    }
}