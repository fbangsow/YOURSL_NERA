/*
@Company:Your SL
@Author:Pavan
@Creation date:9/4/2015
Reference:
*/
@RestResource(urlMapping ='/OrganizationTalonMember/*')
global class WsOrganizationTalonMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void wsGet() {
    	//Create Request
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	List<OrganizationWrapper> listOrganizationWrapper = getOrganizationTalons();
    	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listOrganizationWrapper));
		RestContext.response.addHeader('size', String.valueOf(listOrganizationWrapper.Size()));
		RestContext.response.addHeader('Content-Type', 'application/json');
    }
    public static List<OrganizationWrapper> getOrganizationTalons(){
    	List<OrganizationTalonMember__c> listOrganizationTalons = [SELECT Id,Name,Organization__c,
    																	  Talon__c,
    																	  LastModifiedDate,CreatedDate		
    															   FROM OrganizationTalonMember__c
    															   LIMIT 50000];
    	List<OrganizationWrapper> listOrganization = new List<OrganizationWrapper>();
    	//system.debug('listOrganizationWrapper....'+listOrganizationWrapper);
    	for(OrganizationTalonMember__c myOrganization:listOrganizationTalons){
    		OrganizationWrapper orgWrapper = new OrganizationWrapper(myOrganization);
    		listOrganization.add(orgWrapper);
    	}	
    	return listOrganization;												   
    }
    public class OrganizationWrapper{
    	public String organizationTalonMemberId;
    	public String name;
    	public String talonId;
    	public String organizationId;
    	public Datetime lastModifiedDate;
    	public Datetime createdDate;

  		public OrganizationWrapper(OrganizationTalonMember__c organizationTalon){
  			this.organizationId = organizationTalon.Id;
  			this.name = organizationTalon.Name;
  			this.talonId = organizationTalon.Talon__c;
  			this.organizationId = organizationTalon.Organization__c;
  			this.lastModifiedDate = organizationTalon.LastModifiedDate;
  			this.createdDate = organizationTalon.CreatedDate;
  		}
    }	
}