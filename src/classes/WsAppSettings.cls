// <summary>
/// Created by Sreenath
/// updated from demodev on 22nd July 2015
/// Rest for Login Page configs and UI controls
/// </summary>
@RestResource(urlMapping = '/AppSettings/*')
global class WsAppSettings implements UcbWs {

//public static string debugVar {get; set;}

public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    public String lStrMobileDeviceName {get; set;}
    public MobileDevice__c lMobileDeviceID {get; set;}
    public AppSettings__c appSettingsID {get; set;} 
    public String appVersion {get; set;}
    static String lStrDebugVar {get; set;}
    public String forUserName {get; set;}
    public User settingsRequestedForUser {get; set;}

    
    public String lStrMobileDeviceId {get; set;}

    /// <summary>
    /// Added by Sreenath
    /// Gets MobileDevice ID based on
    /// </summary>
    /// <returns></returns>
    private void getAppSettingsIdForUser() {
       

        //select user profile based on user name of the user logging into
        List <User> users = ([SELECT Id, Name,ProfileId FROM User WHERE UserName = : this.forUserName limit 1]);
        if (!users.isEmpty()) {
            this.settingsRequestedForUser = users[0];
        }
        
        //changed by Kim
        List<MobileDevice__c> listMobileDevices = [select id from MobileDevice__c where Name = :lStrMobileDeviceName];
        if (listMobileDevices.Size() > 0) {
            this.lMobileDeviceID = listMobileDevices[0];
            Integer id = String.valueof(listMobileDevices[0]).Indexof('=');
            System.debug('Mobile Device Id is ' + lStrMobileDeviceId);
          
        }

        //restrict the AppSettings to match the mobile device and version of the app used by the User.
        //the query returns the app settings for " the various profiles" for the given mobile device and version .
        //match these AppSettings against the ProfileAppSettingMember table to find the correct AppSetting for the Current User Profile
        Map<ID,AppSettings__c> mapAppsettingsRequestedForUserDeviceAndVersion = new Map<Id, AppSettings__c>([select id, hash_key__c,version__c from AppSettings__c where version__c = : this.appVersion and mobileDevice__c = :this.lMobileDeviceID.Id ]);

        System.debug('Map AppsettingsRequestedForUserDeviceAndVersion is ' + mapAppsettingsRequestedForUserDeviceAndVersion.Size() );
            
        
               
        if (mapAppsettingsRequestedForUserDeviceAndVersion.Size() > 0){ 

           //Lookup  the Set of ProfileAppSettingMembers for the given User Profile.
           //Each profile can have multiple entries in the ProfileAppSettingMember for combination of mobile device, appversion
           Set<ProfileAppSettingMember__c> setAppSettingIdsForProfile =new Set<ProfileAppSettingMember__c>([SELECT AppSetting__c FROM ProfileAppSettingMember__c where Profile__c=: this.settingsRequestedForUser.ProfileId ]);
            
            //Iterate over these set of ProfileAppSettingMember for given Profile and 
            //find the match for the current user profile in the mapAppSettings that has appsettings for all profiles based on the current user's mobile device and version 
            for(ProfileAppSettingMember__c appSettingForProfile : setAppSettingIdsForProfile){

                if(mapAppsettingsRequestedForUserDeviceAndVersion.containsKey(appSettingForProfile.AppSetting__c)){
                    appSettingsID = mapAppsettingsRequestedForUserDeviceAndVersion.get(appSettingForProfile.AppSetting__c); 
                    
                    //The AppSetting Id will be unique in the ProfileAppSettingMember Table and will have an associated profile Id.
                    //break once the AppSettingId from the map is matched against one an entry in the ProfileAppSettingMember
                    break;
                } 
              
            }

            System.debug('AppSettings ID in Global Services Dev is ' + appSettingsID );
            
        }

    }
    

    public String createResponse() {
        return JSON.serialize(Globals_Services.getAppSettingsJson(appSettingsID));
        
    }

    @HttpGet
    global static void returnSettings() {



        RestContext.response.addHeader('Content-Type', 'application/json');
        String jsonString = '';
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);

        WsAppSettings lObjServApp = new WsAppSettings();

        

        if(myRequest.resquestedByUser != null){

            //Conditions : Added by Sreenath
            if(RestContext.request.params.get('DeviceType')!=null){
                lObjServApp.lStrMobileDeviceName =  RestContext.request.params.get('DeviceType');
            }
        

            if(RestContext.request.params.get('Version')!=null){
                lObjServApp.appVersion = RestContext.request.params.get('Version');          
            }
        
            //The app User wouldnt have logged in yet, 
            //but we retrieve app settings based on the profile based on his UserName
            //this UserName is the name obtained from decrypting the Hash Key Screen.
            if(RestContext.request.params.get('forUserName')!=null){
                lObjServApp.forUserName = RestContext.request.params.get('forUserName');          
            }
                            
            lObjServApp.getAppSettingsIdForUser();
            jsonString = lObjServApp.createResponse();       
            //System.debug('Json String returned from App Setting Dev Service is ' + jsonString);
            RestContext.response.responseBody = Blob.valueOf(jsonString);

        }else {
            RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }
        RestContext.response.addHeader('Content-Type', 'application/json');


    }
  
 }