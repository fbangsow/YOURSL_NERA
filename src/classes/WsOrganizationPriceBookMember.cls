/*
@Company:Your SL
@Author:Pavan
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/OrganizationPriceBookMember/*')
global class WsOrganizationPriceBookMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
        //Create Request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        List<OrganizationPriceBookWrapper> listOrgWrapper = organizationPriceBooks();
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listOrgWrapper));
        RestContext.response.addHeader('size', String.valueOf(listOrgWrapper.Size()));
        RestContext.response.addHeader('Content-Type', 'application/json');

    }
    public static List<OrganizationPriceBookWrapper> organizationPriceBooks(){
        List<OrganizationPriceBookMember__c> listOrganizationMembers = [SELECT Name,
                                                                               PriceBookId__c,
                                                                               LastModifiedDate,
                                                                               CreatedDate,
                                                                               OrganizationId__c
                                                                        FROM OrganizationPriceBookMember__c
                                                                        LIMIT 50000];
        List<OrganizationPriceBookWrapper> listOrganizations = new List<OrganizationPriceBookWrapper>();
        for(OrganizationPriceBookMember__c myMember : listOrganizationMembers){
            OrganizationPriceBookWrapper orgMember = new OrganizationPriceBookWrapper(myMember);
            listOrganizations.add(orgMember);
        }
        return listOrganizations;
    }

    public class OrganizationPriceBookWrapper{
        public String organizationPromotionMemberId;
        public String name{get; set;}
        public String organizationId{get; set;}
        public String priceBookId{get; set;}
        public Datetime lastModifiedDate;
        public Datetime createdDate;
    
        public OrganizationPriceBookWrapper(OrganizationPriceBookMember__c myOrgmember){
            this.name = myOrgmember.Name;
            this.organizationId = myOrgmember.OrganizationId__c;
            this.priceBookId = myOrgmember.PriceBookId__c;
            this.organizationPromotionMemberId = myOrgmember.Id;
            this.lastModifiedDate = myOrgmember.LastModifiedDate;
            this.createdDate = myOrgmember.CreatedDate;
        }
    }    
}