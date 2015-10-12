public with sharing class CtrlPageConfigPhotoUpload {

    public boolean displaying {get; set;}
    public PageConfig__c pageconfigvalue;
    public String pageconfigvalueid{get; set;} 
    public Blob uploadfile{get; set;}
    public Id currentPicture {get; set;}
    public String attachfilename {get; set;}
    public String filename {get; set;}
    public String value{get; set;}

    /* Constructor, grab record, and check/load an existing photo /
    public CtrlPageConfigPhotoUpload (){
        //pageconfigvalue= (PageConfig__c )controller.getRecord();
       pageconfigvalueid = ApexPages.CurrentPage().getparameters().get('id');
       
       
       PageConfig__c page =[SELECT id Name FROM PageConfig__c where id=:pageconfigvalueid];
      
        
        List<Attachment> currentPictures = [SELECT id FROM Attachment WHERE parentId = :pageconfigvalue.id LIMIT 1]; //AND name = :fixedFileName 
         if(currentPictures.size() != 0) {
            currentPicture = currentPictures.get(0).id;
        }

        displaying = true;
    }

    /* toggle switches between the photo display and photo upload form /
    public void toggle() {
        displaying = !displaying;
    }
    
    /** saveFile clears any existing profile picture, retrieves the data from the form, and saves it under the relevant filename*/
    Public Pagereference saveFile() {
    
        // first, we cannot have any conflicting files
        List<attachment> savedPicture = [SELECT id, name, body FROM Attachment WHERE parentId = :pageconfigvalue.id]; // AND name = :fixedFileName
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }
        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = pageconfigvalue.id, name = attachfilename, body = uploadfile);
        try {
            if (uploadfile!= null) {
                insert attachment;
                PageConfig__c objAppsetting = [SELECT id,name from PageConfig__c WHERE id=:pageconfigvalue.id];
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