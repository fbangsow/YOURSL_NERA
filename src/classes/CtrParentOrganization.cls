public class CtrParentOrganization {
    //public List<Organization__c> listOrg{get;set;}
    public CtrParentOrganization(ApexPages.StandardController controller) {
        //String orgId = apexpages.currentpage().getparameters().get('id'); 
        //listOrg = [SELECT ParentOrganization__c,ParentOrganization__r.Name FROM Organization__c WHERE id=:orgiId];  
    }

    public void deleteRecord(){
    	
    }
}