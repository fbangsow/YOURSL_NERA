/*
@Company        :Your SL
@Author         :Imran Shaik
@Creation date  :07/08/2015
@Reference      :
*/
@isTest
global class TestWsBusinessProcess {
    
    static testMethod void testWsBusinessProcess() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();

            RestRequest req = new RestRequest();
                req.requestURI = 'https://eu5.salesforce.com/services/apexrest/BusinessProcess';
                req.httpMethod = 'GET';
            RestResponse res = new RestResponse();

            RestContext.request = req;
            RestContext.response = res;
            UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
            WsBusinessProcess.doReply(myRequest);
            WsBusinessProcess.wsGet();
            system.debug('-----------'+myRequest);
            //System.assertEquals('true', result.success);
            //System.assertEquals('Query Executed Successfully.', result.message);

            Test.stopTest();
    }
}