/*
* @author :Ravindra;
* @Company: YOUR SL
* @Created Date:
* @Reference:
*/
public with sharing class EctrProduct2PhotoUpload {
    public Boolean  displaying {get;set;}
    public String  product2{get;set;}
    public Transient  Blob uploadImage{get;set;}
    public Id  currentProductImage {get;set;}
    public String  attachfilename {get;set;}
    public List<Attachment> listAttachments {get;set;}

    public EctrProduct2PhotoUpload(ApexPages.StandardController controller) {
      product2 = ApexPages.currentPage().getParameters().get('id');
      listAttachments  = [SELECT Id,Name,ParentId,Body
                         FROM Attachment
                         WHERE parentId = :product2];
        if(!listAttachments.isEmpty()){
            currentProductImage = listAttachments.get(0).Id;
        }
        displaying = true;
    }
    public void toggle(){
        displaying = !displaying;
    }
    public void saveFile(){
      if(!listAttachments.isEmpty()){
           delete listAttachments;
      }
    Attachment attachment = new Attachment(ParentId = product2, Name = attachfilename, Body = uploadImage);
    try{
        if(uploadImage!= null && uploadImage.size()<30000) {
            insert attachment;
            Product2 listProducts = [SELECT Id,Image__c
                                     FROM Product2
                                     WHERE Id=:product2];
            listProducts.Image__C = attachment.id;
            update listProducts;
          }
          else{

             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This file exceeds the maximum size limit of 30Kb.'));  
          }
        }catch (Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
          ApexPages.addMessage(myMsg);
        }
          currentProductImage = attachment.Id;
          displaying = true;
    }
}