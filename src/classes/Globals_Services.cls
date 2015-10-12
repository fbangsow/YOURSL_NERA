/// <summary>
/// Created by Sreenath 
/// For common services, like main SOQL functions to retrieve business object details, accross classes
/// </summary>
public class Globals_Services
{
    private static Globals_Services objInstance = new Globals_Services();
    public static Globals_Services Instance
    {
        get
        {
            return objInstance;
        }
    }

    /// <summary> 
    /// Created by Sreenath
    /// Get Mobile device IDs for Name of Device
    /// </summary>
    /// <param name="aStrName"></param>
    /// <returns></returns>
    public List<MobileDevice__c> getMobileDeviceForName(String aStrName){
                List<MobileDevice__c> lLstMobileDevices = [SELECT Id 
                                                           FROM MobileDevice__c 
                                                           WHERE Name = :aStrName];
                return lLstMobileDevices;
    }


    /// <summary>
    /// Created by Sreenath
    /// Retrieves All AppSettings List for Provided Version
    /// </summary>
    /// <param name="aDcmlVersion"></param>
    /// <returns></returns>
    public List<AppSettings__c> getAppSettingsForVersion(decimal aDcmlVersion)
    {
        List<AppSettings__c> lLstAppSettings = [SELECT Id 
                                                FROM AppSettings__c 
                                                WHERE AppVersion__c = :aDcmlVersion];
        return lLstAppSettings;
    }

    /// <summary>
    /// Created by Sreenath
    /// Retrieves All AppSettings List for Provided Mobile Device ID
    /// </summary>
    /// <param name="aObjMobileDeviceID"></param>
    /// <returns></returns>
    public List<AppSettings__c> getAppSettingsForMobileDevice(mobileDevice__c aObjMobileDeviceID)
    {
        List<AppSettings__c> lLstAppSettings = [SELECT Id 
                                                FROM AppSettings__c 
                                                WHERE mobileDevice__c =:aObjMobileDeviceID.Id];
        return lLstAppSettings;
    }


    public static List<clsStringCatalogItem> getStringCatalog(String myLanguage){
        List<clsStringCatalogItem> lstClsStringCatalogItem = new List<clsStringCatalogItem>();

        List<StringCatalogItem__c> lstStrCatalogItem = [SELECT Id,EnumCode__c,Language__c,Text__c,Type__c 
                                                        FROM StringCatalogItem__c 
                                                        WHERE Language__c=:myLanguage];

        for(StringCatalogItem__c strCatalogItem : lstStrCatalogItem  ){
            clsStringCatalogItem sc = new clsStringCatalogItem();
            sc.Text = strCatalogItem.Text__c;
            sc.EnumType = strCatalogItem.Type__c;
            sc.Id = strCatalogItem.Id;
            sc.Language = strCatalogItem.Language__c;
            sc.EnumCode = strCatalogItem.EnumCode__c;

            lstClsStringCatalogItem.add(sc);
        }

        return lstClsStringCatalogItem;
    }


    /// <summary>
    /// Finds AppSettings_c by Id and populates it with PageConfig and UiControls and returns a Custom Json Wrapper 
    /// </summary>
    public static AppSettings getAppSettingsJson(AppSettings__c appSettings){

        List<pageconfig__c> lLstPageConfgs = [SELECT Id, Name, Image__c, PageConfigTypeId__r.Name, BackGround_Color__c ,Height__c,Width__c,XCoordinate__c,YCoordinate__c,DataBinding__c
                                              FROM pageconfig__c 
                                              WHERE appsetting__c =:appSettings.ID order by id asc];

        //separate attachment maps for PageConfig, UiControl, UiControlAttribute - 
        //to avoid looping for unwanted types while matching attaching bodies in the looping control.
        Map<Id, Attachment> mapPageConfigAttachmentsById = new Map<Id, Attachment>( [SELECT Parent.Id, Parent.Name, body,Name 
                                                                                     FROM Attachment 
                                                                                     WHERE Parent.Type  = 'pageconfig__c']);
   
        Map<Id, Attachment> mapUiControlAttachmentsById = new Map<Id, Attachment>( [SELECT Parent.Id,Parent.Name, body ,Name 
                                                                                    FROM Attachment 
                                                                                    WHERE Parent.Type  = 'UIControl__c' ]);
        
        Map<Id, Attachment> mapUiControlAttributeAttachmentsById = new Map<Id, Attachment>( [SELECT Parent.Id, Parent.Name,body ,Name 
                                                                                             FROM Attachment 
                                                                                             WHERE Parent.Type  = 'UIControlAttribute__c']);
   
        //TODO, need to change this when we have complete requirements for language workbench .
        List<clsStringCatalogItem> stringCatalog = getStringCatalog('en_US');

        //placeholder map for the page configs objects  map by Ids to later add the UIControls
        Map<ID, clsPageConfigs> lMapObjPageConfigObjs = new  Map<ID, clsPageConfigs>();
        
        //used to query the list of UI controls in for each PageConfig..
        List<string> lLstrPageConfigIDsList = new List<string>();

        for (pageconfig__c iRollItem : lLstPageConfgs) {

            clsPageConfigs lObjPageConfigObjs = new  clsPageConfigs();
            
            lObjPageConfigObjs.coordinate = new clsCoordinate();
            lObjPageConfigObjs.dimension = new clsDimension();

            lObjPageConfigObjs.Name = iRollItem.Name;
            lObjPageConfigObjs.BackGroundUrl = iRollItem.Image__c;
            lObjPageConfigObjs.BackGroundColor = iRollItem.BackGround_Color__c;
            lObjPageConfigObjs.PageConfigType=iRollItem.PageConfigTypeId__r.Name;

            lObjPageConfigObjs.dimension.Height = iRollItem.Height__c;
            lObjPageConfigObjs.dimension.Width = iRollItem.Width__c;
            lObjPageConfigObjs.coordinate.X = iRollItem.XCoordinate__c;
            lObjPageConfigObjs.coordinate.Y = iRollItem.YCoordinate__c;
            lObjPageConfigObjs.dataBinding = iRollItem.DataBinding__c;


            //lObjPageConfigObjs.image = listAttachments[0].Body;

            for(Attachment pageConfigAttachment : mapPageConfigAttachmentsById.values()){
                if (pageConfigAttachment.Parent.Id == iRollItem.Id){
                     lObjPageConfigObjs.image = pageConfigAttachment.Id;
                     //lObjPageConfigObjs.Name = pageConfigAttachment.Name;
                     
                }
            }

            //add page config id to page config id list.
            lLstrPageConfigIDsList.add(iRollItem.ID);

            //create page config object mBap by page config id.
            lMapObjPageConfigObjs.put(iRollItem.ID,lObjPageConfigObjs);

                     
        }

        //place holder List for UiControl data wrapper by PageConfigId ..
        Map<ID,List<clsUIControls>> lMapUIControlsObjs = new Map<ID,List<clsUIControls>>();
        
        //add PageConfigs even if it has to UiControl Objects... eg. SplashScreen etc... since the SOQL Query will not return this any Ui Controls with PageConfig Id..
        for(ID pageConfigId :  lMapObjPageConfigObjs.keySet()){
            List<clsUIControls> lLstUIControlsObjs = new List<clsUIControls>();
            lMapUIControlsObjs.put(pageConfigId,lLstUIControlsObjs);
        }

        List<UIControl__c> lLstUIControls = [SELECT Id, Name, Image__c, IsHidden__c,Order__c, Type__c,Value__c,UIControlGroupId__r.Name,UIControlTypeId__r.Name, Width__c, YCoordinate__c, Height__c, XCoordinate__c,PageConfigName__c,FieldType__c,FieldName__c 
                                             FROM UIControl__c 
                                             WHERE PageConfigName__c IN : lLstrPageConfigIDsList order by PageConfigName__c asc];             
        
        List<string> lLstUIControlIds = new List<string>();
        for (UIControl__c lRollControl : lLstUIControls) {
            lLstUIControlIds.add(lRollControl.Id);
        }

        List<UIControlAttribute__c> lLstUiControlAttributes = [SELECT Id, Name,Image__c,IsHidden__c,Order__c,Value__c,DataObjectType__c,UIControlId__c,UIControlAttributeGroupId__r.Name,UIControlAttributeTypeId__r.Name 
                                                               FROM UIControlAttribute__c 
                                                               WHERE UiControlId__c IN: lLstUIControlIds];

        for (UIControl__c lRollControl : lLstUIControls) {

            clsUIControls objUIControls = new clsUIControls();
            objUIControls.coordinate = new clsCoordinate();
            objUIControls.dimension = new clsDimension();

            objUIControls.Id = lRollControl.Id;
            objUIControls.Name = lRollControl.Name;
            objUIControls.Type = lRollControl.Type__c;
            objUIControls.value=lRollControl.Value__c;
            objUIControls.dimension.Height = lRollControl.Height__c;
            objUIControls.dimension.Width = lRollControl.Width__c;
            objUIControls.coordinate.X = lRollControl.XCoordinate__c;
            objUIControls.coordinate.Y = lRollControl.YCoordinate__c;
            objUIControls.Order = lRollControl.Order__c;
            objUIControls.IsHidden=lRollControl.IsHidden__c;
            objUIControls.UIControlGroup=lRollControl.UIControlGroupId__r.Name;
            objUIControls.UIControlType=lRollControl.UIControlTypeId__r.Name;
            objUIControls.fieldName = lRollControl.FieldName__c;
            objUIControls.fieldType = lRollControl.FieldType__c;

           
            for(Attachment uiControlAttachment : mapUiControlAttachmentsById.values()){
                if (uiControlAttachment.Parent.Id == lRollControl.Id){
                   objUIControls.Image=uiControlAttachment.Id;
                }
            }

           
            
            if(lMapUIControlsObjs.containsKey(lRollControl.PageConfigName__c)){
                List<clsUIControls> lLstUIControlsObjs=lMapUIControlsObjs.get(lRollControl.PageConfigName__c);
                lLstUIControlsObjs.add(objUIControls);
                lMapUIControlsObjs.put(lRollControl.PageConfigName__c,lLstUIControlsObjs);
            }

            objUIControls.UiControlAttributes = new List<clsUiControlAttributes>();

            for(UIControlAttribute__c uiCtrlAttribute : lLstUiControlAttributes){
                if(uiCtrlAttribute.UIControlId__c == lRollControl.Id){

                 clsUiControlAttributes objClsUiCtrlAttribute = new clsUiControlAttributes();
                   objClsUiCtrlAttribute.Value = uiCtrlAttribute.Value__c;
                   objClsUiCtrlAttribute.Order = uiCtrlAttribute.Order__c;
                   objClsUiCtrlAttribute.DataObjectValue = uiCtrlAttribute.DataObjectType__c;
                   objClsUiCtrlAttribute.UiControlAttritubeType = uiCtrlAttribute.UIControlAttributeTypeId__r.name;
                   objClsUiCtrlAttribute.UiControlAttributeGroup = uiCtrlAttribute.UIControlAttributeGroupId__r.name;
                   objClsUiCtrlAttribute.UiControl = uiCtrlAttribute.UIControlId__c;
                   objClsUiCtrlAttribute.IsHidden=uiCtrlAttribute.IsHidden__c;
                   
                   for(Attachment uiControlAttributeAttachment : mapUiControlAttributeAttachmentsById.values()){
                       if (uiControlAttributeAttachment.Parent.Id == uiCtrlAttribute.Id){
                           objClsUiCtrlAttribute.Image = uiControlAttributeAttachment.Id;
                        }
                    }

                    objUIControls.UiControlAttributes.add(objClsUiCtrlAttribute);
                }
            }
 

        }

           
        List<clsPageConfigs> lLstObjclsPageConfigs=new List<clsPageConfigs>();

         for (ID pageconfigID : lMapUIControlsObjs.keySet()){

             //lStrDebugVar = lStrDebugVar + '     looping controls assign '  + pageconfigID;

             clsPageConfigs objclsPageConfigs=null;
             List<clsUIControls> lLstUIControlsObjIntern=null;

             if(lMapObjPageConfigObjs.containsKey(pageconfigID))
                 objclsPageConfigs=lMapObjPageConfigObjs.get(pageconfigID);

             if(lMapUIControlsObjs.containsKey(pageconfigID))
                 lLstUIControlsObjIntern=lMapUIControlsObjs.get(pageconfigID);

             if(objclsPageConfigs!=null && lLstUIControlsObjIntern!=null)
                 objclsPageConfigs.UiControls=lLstUIControlsObjIntern;

             if(objclsPageConfigs!=null)
                 lLstObjclsPageConfigs.add(objclsPageConfigs);         

            
         }
             
       
     
        AppSettings lObjFinalResult = new AppSettings();
        lObjFinalResult.hashKey = appSettings.Hash_Key__c;
        lObjFinalResult.StringCatalog = stringCatalog;
        lObjFinalResult.PageConfigs = lLstObjclsPageConfigs;
        lObjFinalResult.version = appSettings.version__c;
        return lObjFinalResult;
    }

    public class AppSettings {
        public String hashKey;
        public List<clsStringCatalogItem> stringCatalog {get; set;}
        public List<clsPageConfigs> pageConfigs {get; set;}
        public String version{get;set;}

    }

    class clsStringCatalogItem {
        public String text {get; set;}
        public String enumType {get; set;}
        public String id {get; set;}
        public String language {get; set;}
        public String enumCode {get; set;}
    }

    class clsPageConfigs {
        public String name {get; set;}
        public String backGroundUrl {get; set;}
        public String image {get; set;}
        public String pageConfigType {get; set;}
        public List<clsUIControls> uiControls {get; set;}
        public String backGroundColor {get; set;}  
        public String dataBinding {get; set;}  
        
        public ClsDimension Dimension {get; set;}
        public ClsCoordinate Coordinate {get; set;}        
                
    }

    class clsUIControls {
        public String name {get; set;}
        public String type {get; set;}
        public String Id {get; set;}
        public String value{get; set;}
        public ClsDimension Dimension {get; set;}
        public ClsCoordinate Coordinate {get; set;}
        public String uiControlGroup {get; set;}
        public String uiControlType {get; set;}
        public Decimal order {get;set;}
        public String image {get;set;}
        public Boolean isHidden {get;set;}
        public List<clsUiControlAttributes> uiControlAttributes {get;set;}
        public String fieldName {get;set;}
        public String fieldType {get;set;}


    }
    
    class clsUiControlAttributes {
        public String uiControlAttritubeType {get;set;}  //ColumnName
        public String uiControlAttributeGroup {get;set;}  //ProductListingGridColumnGroup
        public String uiControl {get;set;} //ProductListingGrid
        public Decimal order {get;set;} //1
        public String value {get;set;} //Name
        public String image {get;set;}
        public Boolean isHidden{get;set;}
        public String dataObjectValue{get;set;}    //Product__c
    }
    
    

    class clsDimension {
        public Decimal height {get; set;}
        public Decimal width {get; set;}
    }

    class clsCoordinate {
        public Decimal x {get; set;}
        public Decimal y {get; set;}
    }

}