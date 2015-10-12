/*
@Company:Your SL
@Author:veera
@Creation date:28/5/2015
Reference: Ticket no 615
*/
public with sharing class MobileDevicesPhotoUpload {

    public boolean displaying {get; set;}
    public MobileDevice__c mobileDevicesc;
    public Blob uploadfile{get; set;}
    public Id currentPicture {get; set;}
    public String attachfilename {get; set;}
    public String filename {get; set;}
    public String value{get; set;}

    /** Constructor, grab record, and check/load an existing photo */
    public mobileDevicesPhotoUpload (ApexPages.StandardController controller){
        mobileDevicesc= (MobileDevice__c)controller.getRecord();
        
        List<Attachment> currentPictures = [SELECT id FROM Attachment WHERE parentId = :mobileDevicesc.id LIMIT 1]; //AND name = :fixedFileName 
         if(currentPictures.size() != 0) {
            currentPicture = currentPictures.get(0).id;
        }

        displaying = true;
    }

    /** toggle switches between the photo display and photo upload form */
    public void toggle() {
        displaying = !displaying;
    }
    
    /** saveFile clears any existing profile picture, retrieves the data from the form, and saves it under the relevant filename*/
    Public Pagereference saveFile() {
    
        // first, we cannot have any conflicting files
        List<attachment> savedPicture = [SELECT id, name, body FROM Attachment WHERE parentId = :mobileDevicesc.id]; // AND name = :fixedFileName
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = mobileDevicesc.id, name = attachfilename, body = uploadfile);
        try {
            if (uploadfile!= null) {
                insert attachment;
                MobileDevice__c objMobileDevices = [SELECT id,name from MobileDevice__c WHERE id=:mobileDevicesc.id];
                objMobileDevices.attachmentId__c= attachment.id;
                //objAppsetting.appSettingImage__c = '/servlet/servlet.FileDownload?file='+attachment.id;
                update objMobileDevices;
            } 
       }catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        currentPicture = attachment.id;
        displaying = true;
        return null;
    }
   

}