/*
@Company        :Your SL
@Author         :Imran
@Creation date  :07/08/2015
@Reference      :
*/
@isTest
global class TestWsVisitScore {
  
  static testMethod void testWsVisitScore() {

    Test.startTest();
      CleanUpTestData.createNeraTriggerCustomSetting();
      
      List<Account> listAccount = new List<Account>();
        listAccount.add(new Account(Name='United Gas'));
        listAccount.add(new Account(Name='Yoursl'));
      insert listAccount;

      List<VisitScoreResult__c> listVisitScoreResult = new List<VisitScoreResult__c>();
        listVisitScoreResult.add(new VisitScoreResult__c(Account__c=listAccount[0].ID,Result__c=20,Date__c=Date.today()));
        listVisitScoreResult.add(new VisitScoreResult__c(Account__c=listAccount[1].ID,Result__c=20,Date__c=Date.today()));
      insert listVisitScoreResult;

      List<VisitScoreType__c> listVisitScoreType = new List<VisitScoreType__c>();
        listVisitScoreType.add(new VisitScoreType__c(IsDefault__c=true,Order__c=2));
        listVisitScoreType.add(new VisitScoreType__c(IsDefault__c=true,Order__c=4));
      insert listVisitScoreType;


      List<VisitScoreResultType__c> listVisitScoreResultType = new List<VisitScoreResultType__c>();
        listVisitScoreResultType.add(new VisitScoreResultType__c(VisitScoreResult__c=listVisitScoreResult[0].Id,VisitScoreType__c=listVisitScoreType[0].Id,ResultInPercentage__c=25));
        listVisitScoreResultType.add(new VisitScoreResultType__c(VisitScoreResult__c=listVisitScoreResult[1].Id,VisitScoreType__c=listVisitScoreType[1].Id,ResultInPercentage__c=50));
      insert listVisitScoreResultType;

      List<VisitScorePotentialGroup__c> listVisitScorePotentialGroup = new List<VisitScorePotentialGroup__c>();
        listVisitScorePotentialGroup.add(new VisitScorePotentialGroup__c(IsDefault__c=true,Order__c=2));
        listVisitScorePotentialGroup.add(new VisitScorePotentialGroup__c(IsDefault__c=true,Order__c=4));
      insert listVisitScorePotentialGroup;

      List<VisitScorePotential__c> listVisitScorePotential = new List<VisitScorePotential__c>();
        listVisitScorePotential.add(new VisitScorePotential__c(IsDefault__c=true,Order__c=3,VisitScorePotentialGroup__c=listVisitScorePotentialGroup[0].Id));
        listVisitScorePotential.add(new VisitScorePotential__c(IsDefault__c=true,Order__c=5,VisitScorePotentialGroup__c=listVisitScorePotentialGroup[1].Id));
      insert listVisitScorePotential;

      List<VisitScoreResultPotential__c> listisitScoreResultPotential = new List<VisitScoreResultPotential__c>();
        listisitScoreResultPotential.add(new VisitScoreResultPotential__c(IsDefault__c=true,VisitScorePotential__c=listVisitScorePotential[0].Id,VisitScoreResult__c=listVisitScoreResult[0].Id));
        listisitScoreResultPotential.add(new VisitScoreResultPotential__c(IsDefault__c=true,VisitScorePotential__c=listVisitScorePotential[1].Id,VisitScoreResult__c=listVisitScoreResult[1].Id));
      insert listisitScoreResultPotential;

      List<WsVisitScore.MyAccount> listAccountWrapper = new List<WsVisitScore.MyAccount>();
        WsVisitScore.MyAccount myAccountWrapper = new WsVisitScore.MyAccount();
          myAccountWrapper.id = listAccount[0].Id;
      listAccountWrapper.add(myAccountWrapper);

    Test.stopTest();

    Set<String> setAcccountId = new Set<String>();
      setAcccountId.add(listAccount[0].Id);
      setAcccountId.add(listAccount[1].Id);

    RestRequest req = new RestRequest();
        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/BusinessProcess';
        req.httpMethod = 'GET';
        req.addParameter('accounts', JSON.serialize(setAcccountId));
    RestResponse res = new RestResponse();

    RestContext.request = req;
      RestContext.response = res;

      UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
      WsVisitScore.doReply(myRequest);
       WsVisitScore.wsGet();

    List<WsVisitScore.MyAccount> result = WsVisitScore.deserializeMyEventRequest(JSON.serialize(listAccount));
    //system.assertEquals(result,listAccountWrapper);

  }
  
}