@RestResource(urlMapping = '/AppSettingsDev/*')
global class WebServiceAppSettings {

    public String lStrMobileDeviceName {get; set;}
    public MobileDevice__c lMobileDeviceID {get; set;}
    public AppSettings__c lAppSettingsID {get; set;}
    public PageConfigsDataWrapper pageConfigsDataWrapper {get; set;}
    public Decimal appVersion {get; set;}
    static String lStrDebugVar {get; set;}
    public string version {get; set;}
    
    public void fillAllObjects() {

        setMobileDeviceIDAndAppSettings();
        setPageConfigsAndUIControlsForAppSettings();
    }

 
    private void setMobileDeviceIDAndAppSettings() {


        List<MobileDevice__c> listMobileDevices = [select id from MobileDevice__c where Name = :lStrMobileDeviceName];
        if (listMobileDevices.Size() > 0) {
            this.lMobileDeviceID = listMobileDevices[0];
        }

        List<AppSettings__c> listAppSettings = [select hash_key__c, id from AppSettings__c where version__c = : this.version and mobileDevice__c = :this.lMobileDeviceID.Id limit 1];

        if (listAppSettings.Size() > 0) {
            lAppSettingsID =listAppSettings[0];
        }

    }


 
    private void setPageConfigsAndUIControlsForAppSettings() {


        List<pageconfig__c> sfPageConfigs = [select id, name, image__C from pageconfig__c where appsetting__c = :lAppSettingsID.Id];
        System.debug('AppSettings ID is '+ lAppSettingsID.Id);
        //List to store the list of PageConfig objects in 
        List<PageConfig> pageConfigs = new  List<PageConfig>();

        //a map of PageConfig by the corresponding PageConfig__c custom object id.. 
        Map<string,PageConfig> pageConfigsBySfPageConfigId = new Map<string,PageConfig>();
        
        for (pageconfig__c sfPageConfig : sfPageConfigs) {
            PageConfig pageConfig = new PageConfig();

            pageConfig.Name = sfPageConfig.name;
            pageConfig.BackGroundUrl = sfPageConfig.image__C;

            pageConfigs.add(pageConfig);
            lStrDebugVar = lStrDebugVar + '     Page '  + sfPageConfig.ID;

            pageConfigsBySfPageConfigId.put(sfPageConfig.Id, pageConfig);
            
        }


        for (pageconfig__c sfPageConfig : sfPageConfigs ){    

            List<UIControl__c> sfUIControls = [select id, name, Type__c, Width__c, YCoordinate__c, Height__c, XCoordinate__c, Value__c from UIControl__c where PageConfigName__c = : sfPageConfig.Id];
        
            List<UIControl> uiControls = new List<UIControl>();

            for (UIControl__c sfUIControl : sfUIControls) {

                UIControl uiControl = new UIControl();
                uiControl.Coordinate = new Coordinate();
                uiControl.Dimension = new Dimension();

                uiControl.Name = sfUIControl.Name;
                uiControl.Type = sfUIControl.Type__c;
                uiControl.Value = sfUIControl.Value__c;
                uiControl.Dimension.Height = sfUIControl.Height__c;
                uiControl.Dimension.Width = sfUIControl.Width__c;
                uiControl.Coordinate.X = sfUIControl.XCoordinate__c;
                uiControl.Coordinate.Y = sfUIControl.YCoordinate__c;
                
                lStrDebugVar = lStrDebugVar + '     Control '  + sfUIControl.name;     
                
                uiControls.add(uiControl);

                PageConfig relatedPageConfig = pageConfigsBySfPageConfigId.get(sfPageConfig.Id);
                relatedPageConfig.UiControls = uiControls;
            }

            pageConfigsDataWrapper = new pageConfigsDataWrapper();
            pageConfigsDataWrapper.hashKey = lAppSettingsID.hash_key__c;
            pageConfigsDataWrapper.PageConfigs = pageConfigsBySfPageConfigId.values();
        }


  
    }

    public String createRespone() {
        System.debug('@@@ jsonString=='+ JSON.serialize(pageConfigsDataWrapper));
        return JSON.serialize(pageConfigsDataWrapper);
        
    }

    @HttpGet
    global static void returnSettings() {

        RestContext.response.addHeader('Content-Type', 'application/json');
        String jsonString = '';


        WebServiceAppSettings  appSettings = new WebServiceAppSettings();

        if(RestContext.request.params.get('DeviceType')!=null)
            appSettings.lStrMobileDeviceName =  RestContext.request.params.get('DeviceType');
            System.debug('@@@ DeviceType=='+ RestContext.request.params.get('DeviceType'));
            System.debug('@@@ lStrMobileDeviceName=='+ appSettings.lStrMobileDeviceName);
    
        if(RestContext.request.params.get('Version')!=null){
            appSettings.version = RestContext.request.params.get('Version');
            System.debug('@@@ Version=='+ RestContext.request.params.get('version'));
        }
        
 
        appSettings.fillAllObjects();
        jsonString = appSettings.createRespone(); 

        RestContext.response.responseBody = Blob.valueOf(jsonString);

    }

    class PageConfigsDataWrapper {
        public string hashKey;
        public List<PageConfig> PageConfigs; 
    }

    class PageConfig {
        public String Name;
        public String BackGroundUrl;
        public List<UIControl> UiControls;
    }

    class UIControl {
        public string Name;
        public string Type;
        public Dimension Dimension {get; set;}
        public Coordinate Coordinate {get; set;}
        public string Value;
    }

    class Dimension {
        public decimal Height;
        public decimal Width;
    }

    class Coordinate {
        public decimal X;
        public decimal Y;
    }

}