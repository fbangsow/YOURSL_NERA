/*
@Company:Your SL
@Author:veera
@Creation date:28/5/2015
Reference: Ticket no 369
*/

public with sharing class EctrUIControlPhotoUpload {

    //Private Static FINAL String fixedFileName = 'profilePhoto.svg';
    public boolean displaying { get; set; }
    public UIControl__c UIControlc;
    public Blob profilePicFile { get; set; }
    public Id currentPicture { get; set; }
    public string attachfilename { set; get; }
    
   
    /** Constructor, grab record, and check/load an existing photo */
    public EctrUIControlPhotoUpload(ApexPages.StandardController controller){
        UIControlc = (UIControl__c)controller.getRecord();
        
        List<attachment> currentPictures = [SELECT Id FROM Attachment WHERE parentId = :UiControlc.Id LIMIT 1]; //AND name = :fixedFileName 
        if(currentPictures.size() != 0) {
            currentPicture = currentPictures.get(0).Id;
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
        List<attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :UiControlc.Id]; // AND name = :fixedFileName
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }
        system.debug('filename'+attachfilename);
                system.debug('profilePicFile'+profilePicFile);
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = UiControlc.Id, name = attachfilename, body = profilePicFile);
        try {
            if (profilePicFile != null) {
                insert attachment;
                UIControl__c objUiControl = [select id,name from UIControl__c WHERE id=:UiControlc.Id];
                objUiControl.AttachmentId__c=attachment.Id;
                update objUiControl;
            } 
       }catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
       //insert a;
        currentPicture = attachment.Id;
        displaying = true;
        return null;
    }
    



}