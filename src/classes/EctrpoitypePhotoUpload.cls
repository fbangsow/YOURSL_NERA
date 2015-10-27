/*
@Company:Your SL
@Author:veera
@Creation date:28/5/2015
Reference: Ticket no 615
*/


public with sharing class EctrpoitypePhotoUpload {

        public Boolean displaying {get;set;}
        public String poitypec{get;set;}
        public Transient Blob uploadPicFile{get;set;}
        public Id currentPicture {get; set;}
        public String attachfilename {get;set;}

        public EctrpoitypePhotoUpload (ApexPages.StandardController controller) {
          
            poitypec= ApexPages.currentPage().getParameters().get('id');
            List<attachment> listAttachments = [SELECT Id,ParentId,Name,Body 
                                                FROM Attachment 
                                                WHERE ParentId = :poitypec];
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
                                                      WHERE ParentId =:poitypec];
            if(!listAttachmentsdelete.isEmpty()){
                    delete listAttachmentsdelete;
            }        
            Attachment attachment = new Attachment(parentId = poitypec, name = attachfilename, body = uploadPicFile);
            try{
                if(uploadPicFile!= null){
                    insert attachment;
                    POIType__c objPoitype =[SELECT Id,Name,AttachmentId__c  
                                                  FROM POIType__c 
                                                  WHERE Id=:poitypec];
                    objPoitype.AttachmentId__c = attachment.Id;
                    update objPoitype;
                }
            }catch (Exception e) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(myMsg);
            }
                    currentPicture = attachment.Id;
                    displaying = true;
        }
    }