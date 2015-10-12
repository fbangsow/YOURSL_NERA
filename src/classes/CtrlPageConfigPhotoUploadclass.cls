/*
@Company:Your SL
@Author:veera
@Creation date:28/5/2015
Reference: Ticket no 615
*/
public with sharing class CtrlPageConfigPhotoUploadclass {

    public String uploadPicFile { get; set; }

    public boolean displaying {get; set;}
    public List<PageConfig__c> pageconfigvalue {get;set;}
    public String pageconfigvalueid{get; set;} 
    public Blob uploadfile{get; set;}
    public Id currentPicture {get; set;}
    public String attachfilename {get; set;}
    public String filename {get; set;}
    public String value{get; set;}

    /** Constructor, grab record, and check/load an existing photo */
    public CtrlPageConfigPhotoUploadclass (){
        //pageconfigvalue= (PageConfig__c )controller.getRecord();
        pageconfigvalueid= ApexPages.CurrentPage().getparameters().get('id');
        
        
      List<PageConfig__c > pageconfigvalue =[SELECT id,Name FROM PageConfig__c where id=:pageconfigvalueid];
       if (pageconfigvalue!=null &pageconfigvalue.size() > 0){
       
        
        List<Attachment> currentPictures = [SELECT id FROM Attachment WHERE parentId = :pageconfigvalue[0].id LIMIT 1]; //AND name = :fixedFileName 
         if(currentPictures.size() != 0) {
            currentPicture = currentPictures.get(0).id;
        }

        displaying = true;
    }
    }

    /** toggle switches between the photo display and photo upload form */
    public void toggle() {
        displaying = !displaying;
    }
    
    /** saveFile clears any existing profile picture, retrieves the data from the form, and saves it under the relevant filename*/
    Public Pagereference saveFile() {
    
        // first, we cannot have any conflicting files
        List<attachment> savedPicture = [SELECT id, name, body FROM Attachment WHERE parentId = :pageconfigvalue[0].id]; // AND name = :fixedFileName
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = pageconfigvalue[0].id, name = attachfilename, body = uploadfile);
        try {
            if (uploadfile!= null) {
                insert attachment;
                PageConfig__c objAppsetting = [SELECT id,name from PageConfig__c WHERE id=:pageconfigvalue[0].id];
                objAppsetting.attachmentId__c = attachment.id;
                update objAppsetting;
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