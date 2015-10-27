/*
* @author :Ravindra;
* @Company: YOUR SL  
* @Created Date: 26.05.2015 16:11
* @Reference:
*/
public with sharing class EctrPageConfigcPhotoUpload {

        public Boolean displaying {get;set;}
        public String pageConfigc{get;set;}
        public Transient Blob uploadPicFile{get;set;}
        public Id currentPicture {get; set;}
        public String attachfilename {get;set;}

        public EctrPageConfigcPhotoUpload(ApexPages.StandardController controller) {
          
            pageConfigc = ApexPages.currentPage().getParameters().get('id');
            List<attachment> listAttachments = [SELECT Id,ParentId,Name,Body 
                                                FROM Attachment 
                                                WHERE ParentId = :pageConfigc];
            if(!listAttachments.isEmpty()) {
                currentPicture = listAttachments.get(0).Id;
            }
                displaying = true;
        }

        public void toggle() {
                   displaying = !displaying;
        }
      
        Public void saveFile(){
            List<Attachment> listAttachmentsdelete = [SELECT Id,Name,ParentId,Body 
                                                      FROM Attachment 
                                                      WHERE ParentId =:pageConfigc];
            if(!listAttachmentsdelete.isEmpty()){
                    delete listAttachmentsdelete;
            }        
            Attachment attachment = new Attachment(parentId = pageConfigc, name = attachfilename, body = uploadPicFile);
            try{
                if(uploadPicFile!= null){
                    insert attachment;
                    PageConfig__c objPageConfig =[SELECT Id,Name,AttachmentId__c  
                                                  FROM PageConfig__c 
                                                  WHERE Id=:pageConfigc];
                    objPageConfig.AttachmentId__c = attachment.Id;
                    update objPageConfig;
                }
            }catch (Exception e) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(myMsg);
            }
                    currentPicture = attachment.Id;
                    displaying = true;
        }
    }