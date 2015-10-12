/*
 @Company: Mold tek India  
 @Author: Sunny  
 @Creation date: 20/05/2015
 @Ref: Create dashboard for editing app settings
*/
Public class CtrAppSettingConfig {

    

 Public List<PageConfig__c> pageConfiglist{get; set;}
 Public List<UIControl__c> uiControllerslist{get; set;}
 Public List<AppSettings__c> appSettingslist{get; set;}
 Public List<UIControl__c> uiControllerslist1 { get; set;}
 Public List<SelectOption> listPage {get; set;}
 Public String pageConfigselect{get; set;}
 Public String selectedAppSettings{get; set;}
 Public String selectedUIControllers{get; set;}
 Public String appSettingValue {get; set;}
 Public String pageConfigValue {get; set;}
 Public AppSettings__c appSett {get; set;}
 
 

        Public Map <String,AppSettings__c> mapStringAppsttings = new Map <String,AppSettings__c>();
        Public Map <String,PageConfig__c> mapStringPageConfig = new Map <String,PageConfig__c>();
    
        Public CtrAppSettingConfig()
        {
        appsett = new AppSettings__c();
        appSettingslist = new List<AppSettings__c>();

            For(AppSettings__c app:[Select id,name,(select id,name from PageConfigs__r) From AppSettings__c])
            {
            appSettingslist.add(app);
            mapStringAppsttings.Put(app.ID,app);
            }
 
        }
        
        Public void PageUIcon() {
        
        uiControllerslist1 =null; 
   
        pageConfiglist = new List<PageConfig__c>();
           if(pageConfigselect!='none')
            {
                for(PageConfig__c pagCon:[select id,name,(select name,Height__c,Width__c,XCoordinate__c,YCoordinate__c from UIControls__r) from PageConfig__c where id=:PageConfigselect])
                {
                pageConfiglist.add(pagCon);
                mapStringPageConfig.Put(pagCon.ID,pagCon);            
                }
             
            String pageJSON = JSON.serializePretty(pageConfiglist);
            System.debug(pageJSON);
        uiControllerslist = new list<UIControl__c>();
        uiControllerslist = mapStringPageConfig.Get(pageConfigselect).UIControls__r;
        
        
         }

        }
    
        Public List<SelectOption> GetPageConfig() { 
            
        return listpage;
        
        } 
        
        
        Public void GetAppSettings() {
           
        uiControllerslist =null;
        uiControllerslist1 =null;
          
        appsettingvalue = mapStringAppsttings.Get(selectedAppSettings).name;
          
        pageConfiglist = new List<PageConfig__c>();               
        pageConfiglist = mapStringAppsttings.Get(selectedAppSettings).PageConfigs__r;

            listpage = new List<SelectOption>();

            listpage.add(new SelectOption('None','None'));              
            for(PageConfig__c pa: pageConfiglist){   

            listpage.add(new SelectOption(pa.id,pa.name));                              
            } 
        }
        
        Public void GetUIControllers( ) {

           uiControllerslist1 = new List<UIControl__c>();   

            for(UIControl__c uicon:[select id,name,Height__c,Width__c,XCoordinate__c,YCoordinate__c from UIControl__c where id=:selecteduicontrollers])
            {
            uiControllerslist1.add(uicon);           
            }   
      
                  
        }
        
           
        Public PageReference Cancelit() {
        return null;
        }
        
        
        Public PageReference SaveAppSettings() {
        
        AppSettings__c aset = new AppSettings__c();
        aset.Name = appsett.Name;
        aset.AppVersion__c = appsett.AppVersion__c;
        aset.Hash_Key__c = appsett.Hash_Key__c;
        aset.mobileDevice__c = appsett.mobileDevice__c;
        aset.version__c = appsett.version__c;
        
        try {
            Insert aset;
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        PageReference pagref = new PageReference('/apex/AppSettingConfigpage');
        pagref.setredirect(false);
        return pagref ;
        
        
        
        }
   Public Class JSONClass {

    public String id;
    public String Height1;
    public String Width1;
    public String XCoordinate1;
    public String YCoordinate1;

}
   
    
    @RemoteAction
    public static void GetUIControl(String jsondata)
     {
        // system.debug('@@@ Json data== '+jsondata);
         list<JSONClass> lstJSONClass = new list<JSONClass>();
         JSONParser parser = JSON.createParser(jsondata);        
         while (parser.nextToken() != null) {        
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                        
                    JSONClass jsoncls = (JSONClass)parser.readValueAs(JSONClass.class);
                    lstJSONClass.add(jsoncls);
                    
                 //   system.debug('@@@ inv value== '+jsoncls);
                  //  String s = JSON.serialize(jsoncls);
                  //  system.debug('Serialized JSONClass: ' + s);

                    parser.skipChildren();
                }
            }
        }
    }
    
    system.debug('@@@@ lst json records== '+lstJSONClass);

         list<UIControl__c> lstUIcontrols = new list<UIControl__c>();

         Map<string,UIControl__c> mapStringUIControl = new  map<string,UIControl__c>();
         for(JSONClass rec : lstJSONClass){
             UIControl__c Uicon = new UIControl__c();
             uicon.id = rec.id;
             uicon.Height__c = decimal.valueof(rec.Height1);
             uicon.Width__c = decimal.valueof(rec.Width1);
             uicon.XCoordinate__c = decimal.valueof(rec.XCoordinate1);
             uicon.YCoordinate__c = decimal.valueof(rec.YCoordinate1);
             //if(!mapUiControls.containskey(Uicon.id))
             mapStringUIControl.put(Uicon.id,Uicon);
             system.debug('@@@@ map value=='+mapStringUIControl);
             //lstUIcontrols.add(Uicon);
         }
         
         if(!mapStringUIControl.values().isempty())
             update mapStringUIControl.values();

    

  
}
    
      


}