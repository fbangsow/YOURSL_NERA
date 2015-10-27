/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :11/08/2015
@Reference      :
*/
@isTest
private class TestWsProductGroups {
    static testmethod void doGet() {
        TestDataUtility.createNeraTriggerCustomSetting();
        ProductGroup__c objProductGroup = new ProductGroup__c(Name = 'Danonawater');
        insert objProductGroup;
        List<ProductGroup__c> listProductGroup = new List<ProductGroup__c>();
        listProductGroup.add(new ProductGroup__c(Name = 'water', ParentGroup__c = objProductGroup.Id,
                             EndDate__c = system.today() + 1, StartDate__c = system.today(), Image__c = 'null'));
        listProductGroup.add(new ProductGroup__c(Name = 'water1', ParentGroup__c = objProductGroup.Id,
                             EndDate__c = system.today() + 1, StartDate__c = system.today(), Image__c = 'null'));

        insert listProductGroup;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/ProductGroups';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        WsProductGroups.wsGet();
        WsProductGroups.doReply(myRequest);
        System.assertEquals(objProductGroup.Name,WsProductGroups.getProductGroups()[0].name);
    }

}