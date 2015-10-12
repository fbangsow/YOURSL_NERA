/*
@Company:Your SL
@Author:Pavan
@Creation date:19/8/2015
@Reference: 
*/
@RestResource(urlMapping = '/Organization/*')
global class WsOrganization implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {

    	//create Request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        //List<Organization__c> listOrganization = getOrganizations();
        List<OrganizationWrapper> listOrganization = getOrganizations();
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listOrganization));			
		RestContext.response.addHeader('size', String.valueOf(listOrganization.size()));
		RestContext.response.addHeader('Content-Type', 'application/json'); 
    }	
    public static List<OrganizationWrapper> getOrganizations(){

    	List<Organization__c> listOrganizations =  [SELECT Id,Name,ParentOrganization__c,
                                                           LastModifiedDate,
                                                           CreatedDate 
    									   			FROM Organization__c
                                                    LIMIT 50000];

    	List<OrganizationWrapper> listOrganization = new List<OrganizationWrapper>();
    	for(Organization__c myOrg:listOrganizations){
    		OrganizationWrapper orgWrapper = new OrganizationWrapper(myOrg);
    		listOrganization.add(orgWrapper);
    	}
    	return listOrganization;

    }
    public class OrganizationWrapper{

    	public String Id {get;set;}
    	public String name {get; set;}
    	public String parentId {get; set;}
        public Datetime lastModifiedDateTime;
        public Datetime  createdDateTime; 

    	public OrganizationWrapper(Organization__c myOrg){

    		this.Id = myOrg.Id;
    		this.name = myOrg.Name;
    		this.parentId = myOrg.ParentOrganization__c;
            this.lastModifiedDateTime = myOrg.LastModifiedDate;
            this.createdDateTime = myOrg.CreatedDate;
    	}

    }
}