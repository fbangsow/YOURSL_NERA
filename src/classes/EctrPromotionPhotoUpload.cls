/*
@Company:Your SL
@Author:Pavan
@Creation date:
Reference: 
*/
public with sharing class EctrPromotionPhotoUpload {

        public Boolean displaying {get; set;}
        public String promotion{get; set;}
        public Transient Blob uploadPicFile{get; set;}
        public Id currentPicture {get; set;}
        public String attachfilename {get; set;}

        public EctrPromotionPhotoUpload (ApexPages.StandardController controller) {          
            Promotion = ApexPages.currentPage().getParameters().get('id');
            List<attachment> listAttachments = [SELECT Id,ParentId,Name,Body 
                                                FROM Attachment 
                                                WHERE ParentId = :Promotion];
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
                                                      WHERE ParentId =:Promotion];
            if(!listAttachmentsdelete.isEmpty()){
                    delete listAttachmentsdelete;
            }        
            Attachment attachment = new Attachment(parentId = Promotion, name = attachfilename, body = uploadPicFile);
            try{
                if(uploadPicFile!= null && uploadPicFile.size()<30000){ 
                        system.debug('test.........'+uploadPicFile.size());
                        insert attachment;

                        Promotion__c objPromotion  =[SELECT Id,Name,AttachmentId__c  
                                                     FROM Promotion__c 
                                                     WHERE Id=:Promotion];
                        objPromotion.AttachmentId__c = attachment.Id;
                        update objPromotion;               
                }   
                    else{ 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This file exceeds the maximum size limit of 30Kb.'));  
                        
                    }                   
            }   catch (Exception e) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(myMsg);
                }
                    currentPicture = attachment.Id;
                    displaying = true;                    
        }
}