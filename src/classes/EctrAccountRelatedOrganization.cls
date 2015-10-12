public with sharing class EctrAccountRelatedOrganization {
    public List<Organization__c> listorg {get; set;}
    public String orgId {get; set;}
    public EctrAccountRelatedOrganization (ApexPages.StandardController controller) {
        orgId = apexpages.currentpage().getparameters().get('id');
        organizationData(orgId);
    }
    public void organizationData(String orgId) {
        listorg = new List<Organization__c>();
        for (OrganizationAccountMember__c orgmember : [SELECT Account__c, Organization__r.Name, Organization__r.OwnerId,  Organization__c
                FROM OrganizationAccountMember__c WHERE Account__c = :orgId]) {
            Organization__c org = new Organization__c();
            org.Id = orgmember.Organization__c ;

            org.Name = orgmember.Organization__r.Name;
            org.OwnerId = orgmember.Organization__r.OwnerId;
            listorg.add(org);
        }

    }
}