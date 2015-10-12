public with sharing class EctrPosProductGroupPhotoUpload {

        public Boolean displaying {get;set;}
        public String productGroupc{get;set;}
        public Transient Blob uploadPicFile{get;set;}
        public Id currentPicture {get; set;}
        public String attachfilename {get;set;}

        public EctrPosProductGroupPhotoUpload (ApexPages.StandardController controller) {
          
            productGroupc = ApexPages.currentPage().getParameters().get('id');
            List<attachment> listAttachments = [SELECT Id,ParentId,Name,Body 
                                                FROM Attachment 
                                                WHERE ParentId = :productGroupc];
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
                                                      WHERE ParentId =:productGroupc];
            if(!listAttachmentsdelete.isEmpty()){
                    delete listAttachmentsdelete;
            }        
            Attachment attachment = new Attachment(parentId = productGroupc, name = attachfilename, body = uploadPicFile);
            try{
                if(uploadPicFile!= null){
                    insert attachment;
                    ProductGroup__c objProductGroup =[SELECT Id,Name,AttachmentId__c  
                                                  FROM ProductGroup__c 
                                                  WHERE Id=:productGroupc];
                    objProductGroup.AttachmentId__c = attachment.Id;
                    update objProductGroup;
                }
            }catch (Exception e) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(myMsg);
            }
                    currentPicture = attachment.Id;
                    displaying = true;
        }
    }