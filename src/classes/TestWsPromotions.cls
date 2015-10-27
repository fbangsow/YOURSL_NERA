/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :11/08/2015
@Reference      :
*/
@isTest
private class TestWsPromotions {

  static testmethod void doGet() {
    TestDataUtility.createNeraTriggerCustomSetting();
    Promotion__c objPromotion = new Promotion__c(Name = 'Promo1', StartDate__c = system.today(), EndDate__c = system.today() + 3, ActionValidityEndDate__c = system.today() + 5, ActionValidityStartDate__c = system.today() + 7,
        Description__c = 'Test displayed', SellingValidityEndDate__c = system.today() + 8, SellingValidityStartDate__c = system.today() + 10);
    insert objPromotion;
    Attachment objAttachment = new Attachment(Name = 'checked.svg', Body = Blob.valueof('Attachmentbody'), ParentId = objPromotion .Id);
    insert  objAttachment;

    objPromotion.AttachmentId__c = objAttachment.Id;
    update objPromotion;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Promotions';
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;

    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    WsPromotions.wsGet();
    WsPromotions.doReply(myRequest);

  }
}