/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :11/08/2015
@Reference      :
*/
@isTest
private class TestWsAttachments {

    static testMethod void doGet(){
        TestDataUtility.createNeraTriggerCustomSetting();
        MobileDevice__c objMobileDevice=new MobileDevice__c(Name='IPadAir2',height__c =768.0,width__c=1024.0);
        insert objMobileDevice;
        List<Attachment> listAttachment=new List<Attachment>();
        listAttachment.add(new Attachment(Name='checked.svg',Body=Blob.valueof('Attachmentbody'),ParentId=objMobileDevice.Id));
        listAttachment.add(new Attachment(Name='icon_login.svg',Body=Blob.valueof('New Attachmentbody'),ParentId=objMobileDevice.Id));
        listAttachment.add(new Attachment(Name='new_logo.svg',Body=Blob.valueof('Attachmentbody1'),ParentId=objMobileDevice.Id));
        insert listAttachment;
        List<String> imageIds = new List<String>();
        for(Attachment lstAttachment:listAttachment){
            imageIds.add(lstAttachment.Id);
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Attachments';
        req.httpMethod = 'GET';
        req.addParameter('ImageIds',JSON.Serialize(imageIds));
        RestContext.request = req;
        RestContext.response = res;
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        WsAttachments.returnImages();
        WsAttachments.doReply(myRequest);
        system.debug('RestContext.response----------'+JSON.serialize(RestContext.response));
        //system.assertEquals(JSON.serialize(RestContext.response.statusCode),null);
        system.assertNotEquals(EncodingUtil.base64Encode(listAttachment[0].Body),JSON.serialize(RestContext.response.responseBody));
    }
    
}