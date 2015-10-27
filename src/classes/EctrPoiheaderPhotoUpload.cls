/*
@Company:Your SL
@Author:veera
@Creation date:28/5/2015
Reference: Ticket no 615
*/

public with sharing class EctrPoiheaderPhotoUpload {

        public Boolean displaying {get;set;}
        public String PoiHeaderc{get;set;}
        public Transient Blob uploadPicFile{get;set;}
        public Id currentPicture {get; set;}
        public String attachfilename {get;set;}

        public EctrPoiheaderPhotoUpload(ApexPages.StandardController controller) {
          
            PoiHeaderc = ApexPages.currentPage().getParameters().get('id');
            List<attachment> listAttachments = [SELECT Id,ParentId,Name,Body 
                                                FROM Attachment 
                                                WHERE ParentId = :PoiHeaderc];
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
                                                      WHERE ParentId =:PoiHeaderc];
            if(!listAttachmentsdelete.isEmpty()){
                    delete listAttachmentsdelete;
            }        
            Attachment attachment = new Attachment(parentId = PoiHeaderc, name = attachfilename, body = uploadPicFile);
            try{
                if(uploadPicFile!= null){
                    insert attachment;
                    POIHeader__c objPoiheader =[SELECT Id,Name,AttachmentId__c  
                                                  FROM POIHeader__c 
                                                  WHERE Id=:PoiHeaderc];
                    objPoiheader.AttachmentId__c = attachment.Id;
                    update objPoiheader;
                }
            }catch (Exception e) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(myMsg);
            }
                    currentPicture = attachment.Id;
                    displaying = true;
        }
    }