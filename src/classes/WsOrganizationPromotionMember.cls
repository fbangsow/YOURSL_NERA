/*
@Company:Your SL
@Author:Pavan
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/OrganizationPromotionMember/*')
global class WsOrganizationPromotionMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    //static List<Account> listAccounts;

    @HttpGet
    global static void wsGet() {
    	//Create Request
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);        
    	List<OrganizationPromotionWrapper> listOrganizationWrapper =  organizationPromotions();
    	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listOrganizationWrapper));
		RestContext.response.addHeader('size', String.valueOf(listOrganizationWrapper.Size()));
		RestContext.response.addHeader('Content-Type', 'application/json');
    }
    public static List<OrganizationPromotionWrapper> organizationPromotions(){
        List<OrganizationPromotionMember__c> listOrganizationMembers = [SELECT Name,
                                                                               Promotion__c,
                                                                               LastModifiedDate,
                                                                               CreatedDate,
                                                                               Organization__c
                                                                        FROM OrganizationPromotionMember__c
                                                                        LIMIT 50000];
        List<OrganizationPromotionWrapper> listOrganizations = new List<OrganizationPromotionWrapper>();
        for(OrganizationPromotionMember__c myMember : listOrganizationMembers){
            OrganizationPromotionWrapper promotionMember = new OrganizationPromotionWrapper(myMember);
            listOrganizations.add(promotionMember);
        }
        return listOrganizations;
    }

    public class OrganizationPromotionWrapper{
        public String organizationPromotionMemberId;
        public String name{get; set;}
        public String organizationId{get; set;}
        public String promotionId{get; set;}
        public Datetime lastModifiedDate;
        public Datetime createdDate;
    
        public OrganizationPromotionWrapper(OrganizationPromotionMember__c myOrgmember){
            this.name = myOrgmember.Name;
            this.organizationId = myOrgmember.Organization__c;
            this.promotionId = myOrgmember.Promotion__c;
            this.organizationPromotionMemberId = myOrgmember.Id;
            this.lastModifiedDate = myOrgmember.LastModifiedDate;
            this.createdDate = myOrgmember.CreatedDate;
        }
    }    
}