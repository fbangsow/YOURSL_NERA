/*
@Company:Your SL
@Author:Veera
@Creation date:
Reference: 
*/
public with sharing class EctrUserProfilePhotoUpload{

    //Private Static FINAL String fixedFileName = 'profilePhoto.svg';
    public boolean displaying {get; set;}
    public UserProfile__c userProfile;
    public Blob profilePicFile {get; set;}
    public Id currentPicture {get; set;}
    public String attachfilename {get; set;}
    
   
    /** Constructor, grab record, and check/load an existing photo */
    public EctrUserProfilePhotoUpload(ApexPages.StandardController controller){
        userProfile = (UserProfile__c)controller.getRecord();
        
        List<attachment> currentPictures = [SELECT Id 
                                            FROM Attachment 
                                            WHERE parentId = :userProfile.Id LIMIT 1]; 
        if(currentPictures.size() != 0){
            currentPicture = currentPictures.get(0).Id;
        }
        
        displaying = true;
    }

    /** toggle switches between the photo display and photo upload form */
    public void toggle(){
        displaying = !displaying;
    }
    
    /** saveFile clears any existing profile picture, retrieves the data from the form, and saves it under the relevant filename*/
    Public Pagereference saveFile(){
    
        // first, we cannot have any conflicting files
        List<attachment> savedPicture = [SELECT Id, name, body 
                                         FROM Attachment 
                                         WHERE parentId = :userProfile.Id]; 
        if(savedPicture.size() > 0){
            delete savedPicture;
        }
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = userProfile.Id, name = attachfilename, body = profilePicFile);
        try {
            if(profilePicFile != null){
                insert attachment;
                UserProfile__c objUserProfile = [SELECT id,name 
                                                 FROM UserProfile__c 
                                                 WHERE id=:userProfile.Id];
                objUserProfile.AttachmentId__c=attachment.Id;
                update objUserProfile;
            } 
       }catch (Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
       //insert a;
        currentPicture = attachment.Id;
        displaying = true;
        return null;
    }
    
 }