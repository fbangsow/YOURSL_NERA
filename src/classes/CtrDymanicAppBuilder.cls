/*
@Company: YOUR SL   
@Author: M.Sunny 
@Creation date: 23.June.2015  
@Ref: 
*/

public with sharing class CtrDymanicAppBuilder {

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
public String uiControlName {get; set;}
public Static AppSettings__c appsettingsimg {get; set;}
public Static PageConfig__c pageCon {get; set;}
public Static UIControl__c uiconstr {get; set;}
public String customObjects {get; set;}
public String standardObjects {get; set;}
public List<string> lstStandardfields {get; set;} 
public List<string> lstCustomfields {get; set;}
public Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
public String customObj =  '__c';
public Map<String, AppSettings__c> mapStringAppsttings {get; set;}
    // public Map < String, PageConfig__c > mapStringPageConfig = new Map < String, PageConfig__c > ();

    public CtrDymanicAppBuilder() {

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

    public List<SelectOption> getCustomObjectsList() {
    
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        objNames.add(new SelectOption('None', 'None'));
        for(String name : entities)
        {
           if(name.CONTAINS(customObj))
           {
            objNames.add(new SelectOption(name,name));
        } 
        }
        return objNames;
    }

    public List<SelectOption> getStandardObjectsList() {
    
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        objNames.add(new SelectOption('None', 'None'));
        for(String name : entities)
        {
           if(!name.CONTAINS(customObj))
           {
            objNames.add(new SelectOption(name,name));
        }
        }
        return objNames;
    }

    public Void getStandardObjectFields() {

        lstStandardfields = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(standardObjects);
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();

      //  Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();

                //  Map<String, Schema.SObjectField> M;
// M = Schema.SObjectType.Account.fields.getMap();
//Schema.SObjectField field = M.get('AccountNumber');
//Schema.DisplayType FldType = field.getDescribe().getType();
//system.debug('FldType-------------'+FldType);
        for(String fieldName: fieldMap.keySet())
        {

            lstStandardfields.add(fieldName);
        }            
    }

    public list<string> getStdObjectFields(){

        return lstStandardfields;
      
    }

    public Void getCustomObjectFields() {

        
        lstCustomfields = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(customObjects);

        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        for(String fieldName: fieldMap.keySet())
        {

            lstCustomfields.add(fieldName);
        }            
    }

    public list<string> getCusObjectFields(){
         
        return lstCustomfields;
       
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

        pageCon = [SELECT id, name, backGround_Color__c, attachmentId__c, width__c, height__c,yCoordinate__c, xCoordinate__c,
                   (SELECT name, height__c, width__c, xCoordinate__c, yCoordinate__c, type__c, attachmentId__c FROM UIControls__r),
                   (SELECT id, name from attachments)
                    FROM PageConfig__c WHERE id = :pageConfigName];
        String uiControlsJSON = JSON.serializePretty(pageCon);
        //System.debug(uiControlsJSON);

        return uiControlsJSON;
    }


    @RemoteAction
    public static String getUIcontroluiAttributes(String uiControlName) {

        uiconstr = [SELECT id, name,
                   (SELECT name, value__c FROM UIControllerAttributes__r),
                   (SELECT id, name from attachments)
                    FROM UIControl__c WHERE id = :uiControlName];
        String uiAttributesJSON = JSON.serializePretty(uiconstr);
        //System.debug('uiAttributesJSON@@@@@@@@@@@'+uiAttributesJSON );

        return uiAttributesJSON;
    }

    


    @RemoteAction
    public static String getAppSettingsImages(String appSettingImage) {

        appsettingsimg = [SELECT id, name, mobileDevice__r.attachmentId__c, mobileDevice__r.height__c, mobileDevice__r.width__c, mobileDevice__r.xBezel__c,
                                mobileDevice__r.yBezel__c, mobileDevice__r.xFrame__c, mobileDevice__r.yFrame__c
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

        Map<String, UIControl__c> mapStringUIControlId = new  Map<String, UIControl__c>();

        Map<String, UIControl__c> mapStringUIControlName = new  Map<String, UIControl__c>();

            
        for (jSONUicontrols rec : lstJSONUicon) {

            UIControl__c uicon = new UIControl__c();

            if(rec.id!=null && rec.id!='')
            {
            uicon.id = rec.id;
            uicon.height__c = decimal.valueof(rec.height1);
            uicon.width__c = decimal.valueof(rec.width1);
            uicon.xCoordinate__c = decimal.valueof(rec.xCoordinate1);
            uicon.yCoordinate__c = decimal.valueof(rec.yCoordinate1);
            uicon.pageConfigName__c = rec.parentid1;

            mapStringUIControlId.put(Uicon.id, Uicon);
            
            } else

            {            
            uicon.name = rec.uiname1;
            uicon.fieldName__c = rec.uiname1;
            uicon.fieldType__c = 'Text';
            uicon.height__c = decimal.valueof(rec.height1);
            uicon.width__c = decimal.valueof(rec.width1);
            uicon.xCoordinate__c = decimal.valueof(rec.xCoordinate1);
            uicon.yCoordinate__c = decimal.valueof(rec.yCoordinate1);
            uicon.pageConfigName__c = rec.parentid1;


            mapStringUIControlName.put(Uicon.name, uicon);
                           
            }

        }    

        if (!mapStringUIControlId.values().isempty())
            upsert mapStringUIControlId.values();

             if (!mapStringUIControlName.values().isempty())
            upsert mapStringUIControlName.values();

         

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
     //   Map<String, PageConfig__c> mapStringPageconfig = new  Map<String, PageConfig__c>();

        for (jSONPageConfig jsonpage : lstPageConfigJSON) {
            PageConfig__c pageConfig = new PageConfig__c();
            pageConfig.id = jsonpage.pagiconfigid1;
            pageConfig.backGround_Color__c = jsonpage.backgroundcolor1;
            

            //if(!mapUiControls.containskey(Uicon.id))
          //  mapStringPageconfig.put(pageConfig.id, pageConfig);


            lstPageConfigJSONdata.add(pageConfig);

         //   system.debug('@@@@ map value==' + mapStringPageconfig);
        }
        if(!lstPageConfigJSONdata.isempty())
            upsert lstPageConfigJSONdata;




    }
    public class jSONUicontrols {

    public String id;
    public String height1;
    public String width1;
    public String xCoordinate1;
    public String yCoordinate1;
    public String parentid1;
    public String uiname1;


    }
    public class jSONPageConfig {

    public String backgroundcolor1;
    public String pagiconfigid1;

    }






}