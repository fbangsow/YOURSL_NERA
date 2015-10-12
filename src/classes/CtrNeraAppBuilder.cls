/*
 @Company: YOUR SL
 @Author: M.Sunny  / V.Veera
 @Creation date: 20/05/2015
 @Ref: Create dashboard for editing app settings and editing UI Control settings.
*/
public without sharing class CtrNeraAppBuilder{

    public List<PageConfig__c> listPageConfig {get; set;}
    public List<AppSettings__c> listAppSettings {get; set;}
    public List<SelectOption> listPage {get; set;}
    public String pageConfigselect {get; set;}
    public String selectedAppSettings {get; set;}
    public String appSettingValue {get; set;}
    public String pageConfigValue {get; set;}
    public AppSettings__c appSett {get; set;}
    public String appSettingImage {get; set;}
    public String pageConfigName {get; set;}
    public static AppSettings__c appsettingsimg {get; set;}
    public static pageConfig__c pageCon {get; set;}

    public Map<String, AppSettings__c> mapStringAppsttings {get; set;}
    // public Map < String, PageConfig__c > mapStringPageConfig = new Map < String, PageConfig__c > ();

    public CtrNeraAppBuilder() {

        appsett = new AppSettings__c();
        listAppSettings = new List<AppSettings__c>();
        this.mapStringAppsttings = new Map<String, AppSettings__c>([SELECT id, name, mobileDevice__r.attachmentId__c, 
                                                                        (SELECT id, name from PageConfigs__r) 
                                                                    FROM AppSettings__c LIMIT 100]);

        listAppSettings = mapStringAppsttings.values();

    }

    public void getAppSettings() {

        appsettingvalue = mapStringAppsttings.Get(selectedAppSettings).name;

        listpageConfig = new List<PageConfig__c> ();
        listpageConfig = mapStringAppsttings.Get(selectedAppSettings).PageConfigs__r;
        listpage = new List<SelectOption> ();

        listpage.add(new SelectOption('None', 'None'));

        for (PageConfig__c pa : listpageConfig) {

            listpage.add(new SelectOption(pa.id, pa.name));
        }

    }

    public List<SelectOption> getPageConfig() {

        return listpage;
    }


    public PageReference saveAppSettings() {

        AppSettings__c appSettings = new AppSettings__c(name = appSett.name, appVersion__c = appSett.appVersion__c,
                                                            hash_Key__c = appSett.hash_Key__c,
                                                            mobileDevice__c = appSett.mobileDevice__c, version__c = appSett.version__c );

        try {
            Insert appSettings;
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        PageReference pagRef = new PageReference('/apex/AppSettingsDashboard');
        pagRef.setredirect(true);
        return pagRef;



    }

    

    @RemoteAction
    public static String getpageconfigUIcon(String pageConfigName) {

        pageCon = [SELECT id, name, backGround_Color__c, attachmentId__c,
                   (SELECT name, height__c, width__c, xCoordinate__c, yCoordinate__c, type__c, attachmentId__c FROM UIControls__r),
                   (SELECT id, name from attachments)
                    FROM PageConfig__c WHERE id = :pageConfigName];
        String uiControlsJSON = JSON.serializePretty(pageCon);
        //System.debug(uiControlsJSON);

        return uiControlsJSON;
    }

    


    @RemoteAction
    public static String getAppSettingsImages(String appSettingImage) {

        appsettingsimg = [SELECT id, name, mobileDevice__r.attachmentId__c, mobileDevice__r.height__c, mobileDevice__r.width__c
                             FROM AppSettings__c WHERE id = :appSettingImage];
        String appSettingsJSon = JSON.serializePretty(appsettingsimg);
       // System.debug(appSettingsJSon);

        return appSettingsJSon;
    }



    @RemoteAction
    public static void getUIControl(String jsondata, String jsonObjPageconfig) {

        List<jSONUicontrols> lstJSONUicon = new List<jSONUicontrols>();

        JSONParser parser = JSON.createParser(jsondata);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {

                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {

                        jSONUicontrols jsoncls = (jSONUicontrols)parser.readValueAs(jSONUicontrols.class);
                        lstJSONUicon.add(jsoncls);
                        parser.skipChildren();
                    }
                }
            }
        }

        system.debug('@@@@ lst json records== '+jsonObjPageconfig);
        system.debug('@@@@ lst json records== '+lstJSONUicon);

        List<UIControl__c> lstUIcontrols = new  List<UIControl__c>();

        Map<String, UIControl__c> mapStringUIControl = new  Map<String, UIControl__c>();

        for (jSONUicontrols rec : lstJSONUicon) {
            UIControl__c Uicon = new UIControl__c();
            uicon.id = rec.id;
            uicon.height__c = decimal.valueof(rec.height1);
            uicon.width__c = decimal.valueof(rec.width1);
            uicon.xCoordinate__c = decimal.valueof(rec.xCoordinate1);
            uicon.yCoordinate__c = decimal.valueof(rec.yCoordinate1);
            uicon.Image__c=String.valueof(rec.uploadimage);
            uicon.AttachmentId__c=string.valueof(rec.uploadimage);
           


            //if(!mapUiControls.containskey(Uicon.id))
            mapStringUIControl.put(Uicon.id, Uicon);

            system.debug('@@@@ map value==' + mapStringUIControl);
            //lstUIcontrols.add(Uicon);
        }

        if (!mapStringUIControl.values().isempty())
            update mapStringUIControl.values();

         

        List<jSONPageConfig> lstPageConfigJSON = new List<jSONPageConfig>();
        JSONParser parserjson = JSON.createParser(jsonObjPageconfig);
        while (parserjson.nextToken() != null) {
            if (parserjson.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parserjson.nextToken() != null) {

                    if (parserjson.getCurrentToken() == JSONToken.START_OBJECT) {

                        jSONPageConfig pagejsoncls = (jSONPageConfig)parserjson.readValueAs(jSONPageConfig.class);
                        lstPageConfigJSON.add(pagejsoncls);
                        parserjson.skipChildren();
                    }
                }
            }
        }
        system.debug('@@@@ lst lstPageConfigJSON records== '+lstPageConfigJSON);

        List<PageConfig__c> lstPageConfigJSONdata = new List<PageConfig__c>();
        Map<String, PageConfig__c> mapStringPageconfig = new  Map<String, PageConfig__c>();

        for (jSONPageConfig jsonpage : lstPageConfigJSON) {
            PageConfig__c pageConfig = new PageConfig__c();
            // pageConfig.id = jsonpage.id;
            pageConfig.backGround_Color__c = jsonpage.backgroundcolorJSon;
            //pageConfig.pageConfigImageUrl__c = jsonpage.backgroundimageurl;

            //if(!mapUiControls.containskey(Uicon.id))
            mapStringPageconfig.put(pageConfig.id, pageConfig);

            system.debug('@@@@ map value==' + mapStringPageconfig);
            //lstUIcontrols.add(Uicon);
        }



    }
    public class jSONUicontrols {

    public String id;
    public String height1;
    public String width1;
    public String xCoordinate1;
    public String yCoordinate1;
    public String uploadimage;


    }
    public class jSONPageConfig {

    public String backgroundcolorJSon;
    // public String backgroundimageurl;
    }







}