public with sharing class ctrOrganizationRelatedAccount {
    public List<Account> listAccount {get; set;}
    public String orgId {get;set;}
    public ctrOrganizationRelatedAccount(ApexPages.StandardController controller) {
        orgId = apexpages.currentpage().getparameters().get('id');
        organizationData();
    }
    public void organizationData() {
        listAccount = new List<Account>();
        for (OrganizationAccountMember__c orgmember : [SELECT Account__c, Account__r.Name, Account__r.OwnerId, Account__r.GeoLocations__c, Organization__c FROM OrganizationAccountMember__c WHERE Organization__c = :orgId]) {
            Account acc = new Account();
            acc.Id = orgmember.Account__c;
            acc.Name = orgmember.Account__r.Name;
            acc.OwnerId = orgmember.Account__r.OwnerId;
            listAccount.add(acc);
        }

    }
}