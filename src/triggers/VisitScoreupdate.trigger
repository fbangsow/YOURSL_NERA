
trigger VisitScoreupdate on AuditResult__c (after insert,after update) 
{
Map<Id, Account> parentacc = new Map<Id, Account>();

System.debug('......map......'+parentacc );

 List<Id> listIds = new List<Id>();
 
 for (AuditResult__c  childObj : Trigger.new) {
    listIds.add(childObj.AccountId__c);
    
  }
  
  parentacc = new Map<Id, Account>([SELECT id, VisitScore__c,
                                         (SELECT Id, Score__C FROM AuditResults__r ) 
                                         FROM Account WHERE ID IN :listIds]);

 for (AuditResult__c  audit: Trigger.new){
 
     Account myParentOpp = parentacc.get(audit.AccountId__c);
     system.debug('........audit.Score__c......'+audit.Score__c);
     system.debug('........myParentOpp......'+myParentOpp);
     myParentOpp.VisitScore__c= audit.Score__c;
  }
system.debug('........line23......'+parentacc.values());
 update parentacc.values();
 }