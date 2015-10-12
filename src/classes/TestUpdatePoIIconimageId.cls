/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :08/09/2015
@Reference      :
*/

@isTest
public class TestUpdatePoIIconimageId {

      //This method checks whether PoiIconImageId__c field of UICOntroll object upadated (with AttachmentId of POIType object) or not after inserting the image in POIType object
    static testmethod void UpdatePoIIconimageIdinUICnt(){
    
    
      POIType__c objPOIType=new POIType__c(Name='Cooler');
      insert objPOIType;
       Attachment attach = new Attachment(Name = 'iPadAir2vector', body = Blob.valueOf('attachBody'), parentId = objPOIType.id);
        insert attach;
        
        objPOIType.AttachmentId__c=attach .Id;
        update objPOIType;
        system.debug('-----POITY'+objPOIType);
        
        MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'Samsung', height__c = 4, width__c = 4, XBezel__c = 90.0, YBezel__c = 34.0, XFrame__c = 727.0, YFrame__c = 563.0 );
        insert objmobileDevice;
        
        AppSettings__c objAppSettings = new AppSettings__c(mobileDevice__c = objmobileDevice.Id, Name = 'IPadAir2', AppVersion__c = 123);
        insert objAppSettings;
        
        PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.Id, BackGround_Color__c = '#465568');
        insert objPageConfig;
        
        UIControlType__c objUIControlType = new UIControlType__c(Name = 'POI');
        insert objUIControlType;
        UIControl__c objUIControl=new UIControl__c(Name='CoolerPOI',Height__c=12,YCoordinate__c=3,PageConfigName__c=objPageConfig .Id,POIType__c=objPOIType.Id,Type__c=objUIControlType.Id );
        insert objUIControl;
        UIControl__c objUIControl1=[SELECT Id,PoiIconImageId__c FROM UIControl__c ];
        
        
        system.assertEquals( objPOIType.AttachmentId__c,objUIControl1.PoiIconImageId__c );
        
        
    }


}