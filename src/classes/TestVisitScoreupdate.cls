/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :29/07/2015
@Reference      :
*/

@isTest
private class TestVisitScoreupdate {

//This method checks VisitScore field in Account updated or not after inserting the record in AuditResult
static testmethod void visitScoreUpdateAfterInsert(){
Account objAccount=new Account(Name='Genepoint');
insert objAccount;

AuditResult__c objAuditResult=new AuditResult__c(AccountId__c=objAccount.Id,Score__c=3);
insert objAuditResult;
Account objAccount1=[SELECT Id,VisitScore__c FROM Account Where Id=:objAccount.Id];
System.assertEquals(objAuditResult.Score__c,objAccount1.VisitScore__c);
}
}