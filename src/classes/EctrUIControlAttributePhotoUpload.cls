/*
@Company:Your SL
@Author:veera
@Creation date:29/5/2015
Reference: Ticket no 369
*/

public with sharing class EctrUIControlAttributePhotoUpload {
 
    //Private Static FINAL String fixedFileName = 'profilePhoto.svg';
    public Static String fixedFileName{get;set;}
    public Boolean displaying { get; set; }
    public UIControlAttribute__c UIControlAttributec;
    public Transient Blob uploadPicFile { get; set; }
    public Id currentPicture { get; set; }
    public String attachfilename { get; set; }
    
    
    
   
    /** Constructor, grab record, and check/load an existing photo */
    public EctrUIControlAttributePhotoUpload(ApexPages.StandardController controller){
        UIControlAttributec= (UIControlAttribute__c )controller.getRecord();
        
        List<attachment> currentPictures = [SELECT Id  FROM Attachment WHERE parentId = :UIControlAttributec.Id LIMIT 1];
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
    Public PageReference saveFile() {
    
        // first, we cannot have any conflicting files
        List<attachment> savedPicture = [SELECT Id, name, body,ContentType FROM Attachment WHERE parentId = :UIControlAttributec.Id];
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = UIControlAttributec.Id, name = attachfilename, body = uploadPicFile);
        try {
            if (uploadPicFile != null) {
                insert attachment ;
                UIControlAttribute__c objuicontrolAttribute=[select id, name,IsHidden__c From UIControlAttribute__c where id=:UIControlAttributec.Id];
                objuicontrolAttribute.AttachmentId__c=attachment.id;
                update objuicontrolAttribute;
            
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