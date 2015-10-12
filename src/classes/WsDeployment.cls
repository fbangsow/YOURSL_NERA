/*
@Company:Your SL
@Author:Veera
@Creation date:4/6/2015
Reference: Ticket no 463
*/
@RestResource(urlmapping = '/Deployment/*')

global class WsDeployment implements UcbWs {
public static Map<Id,BusinessProcessParameter__c> businessProcessParameterMap;
public static UcbWsResponse doReply(UcbWsRequest request) {
return new UcbWsResponse();

}
@HttpGet
global static void wsGplet() {
UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
if(myRequest.attachMentId <> null){
RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAttachMent(myRequest.attachMentId)));
}
if(myRequest.appSetting == 'mobileDevice'){ 
   RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnMobileDevice()));
        }    
        else if(myRequest.appSetting == 'appSetting'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAppSettings()));
        } 
        else if(myRequest.appSetting == 'pageConfig'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPageConfig()));
        }
        else if(myRequest.appSetting == 'uiControl'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnUiControl()));
        } 
        else if(myRequest.appSetting == 'uiControlAttribute'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnUiControlAttribute()));
        } 
        else if(myRequest.appSetting == 'uiControlType'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnUiControlType()));
        }
        else if(myRequest.appSetting == 'uiControlGroup'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnUiControlGroup()));
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
        else if(myRequest.appSetting == 'uiControlAttributeType'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnUiCntrlAttType()));
        } 
        else if(myRequest.appSetting == 'uiControlAttributeGroup'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnUiCntrlAttGroup()));
        } 
        else if(myRequest.appSetting == 'pageConfigType'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(retunPageConfigType()));           
        } 
        else if(myRequest.appSetting == 'businessProcessParameter'){
           RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnBusinessProcessParameter()));
        }
        else if(myRequest.appSetting == 'businessProcess'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnBusinessProcess()));
        }
        else if(myRequest.appSetting == 'stringCatlogItem'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnStringCatlogItem()));
        }
        RestContext.response.addHeader('Content-Type', 'application/json');  
    }  

    public static List<MobileDevice__c> returnMobileDevice(){                                                                    

        List<MobileDevice__c> mobDev = [SELECT ID,Name,AttachmentId__c,Height__c,Image__c,IsDefault__c,OperatingSystem__c,Width__c,XBezel__c,XFrame__c,YBezel__c,YFrame__c 
                                        FROM MobileDevice__c 
                                        WHERE IsDefault__c=true];
        return mobDev;
    }

    public static List<AppSettings__c> returnAppSettings(){
  
          List<AppSettings__c> listAppSetting = [SELECT ID,Name,AppSettingImage__c,AppVersion__c,Hash_Key__c,IsDefault__c,MobileDevice__c,Version__c 
                                                 FROM AppSettings__c
                                                 WHERE IsDefault__c = true];   
         return listAppSetting;
    }

    public static List<PageConfig__c> returnPageConfig(){   

        List<PageConfig__c> pageConfig = [SELECT Name,ID,AppSetting__c,AttachmentId__c,BackGround_Color__c,DataBinding__c,Height__c,Image__c,IsDefault__c,PageConfigTypeId__c,Type__c,Width__c,XCoordinate__c,YCoordinate__c 
                                         FROM PageConfig__c
                                         WHERE IsDefault__c = true];
        return pageConfig;
    }
    public static List<UIControl__c> returnUiControl(){

        List<UIControl__c> uiControl = [SELECT Name,AttachmentId__c,FieldName__c,FieldType__c,Height__c,Image__c,IsDefault__c,IsHidden__c,Order__c,PageConfigName__c,Type__c,UIControlGroupId__c,UIControlTypeId__c,Value__c,Width__c,XCoordinate__c,YCoordinate__c 
                                        FROM UIControl__c
                                        WHERE IsDefault__c = true];
        return uiControl;
    }

    public static List<UIControlAttribute__c> returnUiControlAttribute(){
       
            List<UIControlAttribute__c> uiControlAttribute = [SELECT Name,AttachmentId__c,DataObjectType__c,Image__c,IsDefault__c,IsHidden__c,Order__c,UIControlAttributeGroupId__c,UIControlAttributeTypeId__c,UIControlId__c,Value__c
                                                                FROM UIControlAttribute__c 
                                                                WHERE IsDefault__c = true];
        return uiControlAttribute;
    }
    
    public static List<UIControlType__c> returnUiControlType(){
       
            List<UIControlType__c> uiControlType = [SELECT Name,IsDefault__c FROM UIControlType__c WHERE IsDefault__c=true];
            return uiControlType;
    }
    
    public static List<UIControlGroup__c> returnUiControlGroup(){
      
            List<UIControlGroup__c> uiControlGroup = [SELECT Name,IsDefault__c FROM UIControlGroup__c WHERE IsDefault__c=true];
            return uiControlGroup;
    }
    
    public static List<UIControlAttributeType__c> returnUiCntrlAttType(){
        
            List<UIControlAttributeType__c> uiCintrolAttributeType= [SELECT Name,IsDefault__c FROM UIControlAttributeType__c WHERE IsDefault__c=true];
            return uiCintrolAttributeType;
    }
   
    public static List<UIControlAttributeGroup__c> returnUiCntrlAttGroup(){
        
            List<UIControlAttributeGroup__c> uiControlAttributeGroup = [SELECT Name,IsDefault__c FROM UIControlAttributeGroup__c WHERE IsDefault__c=true];
            return uiControlAttributeGroup;
    }
   
    public static List<PageConfigType__c> retunPageConfigType(){
       
        List<PageConfigType__c> pageConfigType = [SELECT Name,IsDefault__c FROM PageConfigType__c WHERE IsDefault__c=true];
        return pageConfigType;
    }
   
    public static List<Businessprocess__c> returnBusinessProcess(){
       
        List<Businessprocess__c> businessProcess = [SELECT Name,IsDefault__c FROM Businessprocess__c WHERE IsDefault__c=true];
        return businessProcess;
    }
    
    public static List<BusinessProcessParameter__c> returnBusinessProcessParameter(){
        List<BusinessProcessParameter__c> businessProcessParameter = [SELECT Name,IsDefault__c,BusinessprocessId__c,Value__c,ValueNumber__c,Values__c 
                                                                        FROM BusinessProcessParameter__c
                                                                        WHERE IsDefault__c=true];
        return businessProcessParameter;
    }
    public static List<StringCatalogItem__c> returnStringCatlogItem(){
        List<StringCatalogItem__c> stringCatlogItem = [SELECT  Id,Name,EnumCode__c,IsDefault__c,Language__c,Text__c,Type__c 
                                                        FROM StringCatalogItem__c
                                                        WHERE IsDefault__c = true];
        return stringCatlogItem;
    }
    public static AttachmentWrapper returnAttachMent(String attachMentId){
        if(attachMentId <> null && attachMentId <> ''){
            try{
                    Attachment att = [SELECT Id,Name,Body,ParentId FROM Attachment where ID=:attachMentId];
                    AttachmentWrapper attWrap = new AttachmentWrapper();      
                        attWrap.id = att.ID;
                        attWrap.name = att.Name;
                        attWrap.body = att.Body;
                        attWrap.parentId = att.ParentId;
                    return attWrap;
                }catch(Exception e){
                    system.debug('erroe-------------------'+e.getMessage());
                }            
        } 
        return null;      
    }
    public class AttachmentWrapper{
        public String name;
        public Id id;
        public Blob body;
        public String parentId;
    }
}