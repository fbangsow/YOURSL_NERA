/*
@Company:Your SL
@Author:Pavan
@Creation date:18/7/2015
Reference: 
*/

public with sharing class EctrProductGroupPhotoUpload {

    public boolean displaying { get; set; }
    public ProductGroup__c productGroup;
    public Blob profilePicFile { get; set; }
    public Id currentPicture { get; set; }
    public String attachfilename { get; set; }
    
   
    /** Constructor, grab record, and check/load an existing photo */
    public EctrProductGroupPhotoUpload(ApexPages.StandardController controller){
        productGroup = (ProductGroup__c)controller.getRecord();
        
        List<attachment> currentPictures = [SELECT Id 
                                            FROM Attachment 
                                            WHERE parentId = :productGroup.Id]; //AND name = :fixedFileName 
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
        List<attachment> savedPicture = [SELECT Id,name,body 
                                         FROM Attachment 
                                         WHERE parentId = :productGroup.Id]; // AND name = :fixedFileName
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }
        system.debug('filename'+attachfilename);
        system.debug('profilePicFile'+profilePicFile);
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = productGroup.Id, name = attachfilename, body = profilePicFile);
        try {
            if(profilePicFile!= null && profilePicFile.size()<30000) {
                insert attachment;
                ProductGroup__c objProductControl = [SELECT id,name 
                                                     FROM ProductGroup__c 
                                                     WHERE id=:productGroup.Id];
                objProductControl.Image__c = attachment.Id;
                update objProductControl;
            } 
            else{

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This file exceeds the maximum size limit of 30Kb.'));  
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