/*
@Company:Your SL
@Author:Pavan
@Creation date:9/2/2015
Reference: 
*/
public with sharing class EctrTalonPhotoUpload {

	public String talon {get;set;}
	public Id currentPicture {get;set;}
	public Boolean displaying {get;set;}
	public String attachfileName {get;set;}
	public Transient Blob uploadPicFile {get;set;}

	public EctrTalonPhotoUpload(ApexPages.StandardController controller) {
		talon = ApexPages.currentPage().getParameters().get('id');
		List<attachment> listAttachments = [SELECT Id,Name,ParentId,Body 
											FROM attachment
											WHERE ParentId=:talon];
		if(!listAttachments.isEmpty()){
			currentPicture = listAttachments.get(0).Id;
		}	
		displaying = true;
	}
	public void toggle(){
		displaying =!displaying;
	}
	public void savefile(){

		List<attachment> listDeleteAttachments = [SELECT Id,Name,ParentId,Body
											 	   FROM attachment
											       WHERE ParentId=:talon];
		if(!listDeleteAttachments.isEmpty()){
			delete listDeleteAttachments;
		}
		Attachment attachment = new Attachment(ParentId=talon,Name=attachfileName,Body=uploadPicFile); 
		try{
			if(uploadPicFile!=null && uploadPicFile.size()<30000){
				insert attachment;
				Talon__c objTalon = [SELECT Id,Name,AttachmentId__c
				          			 FROM Talon__c
				          			 WHERE Id=:Talon];
				objTalon.AttachmentId__c=attachment.Id;
				update objTalon;
			}	

			else{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This file exceeds the maximum size limit of 30Kb.'));
			}
		}
		catch(Exception e){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
		}
		currentPicture = attachment.Id;
        displaying = true;		
	}
}