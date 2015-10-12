/*
@Company:Your SL
@Author:Pavan
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/AccountOrganizationMember/*')
global class WsAccountOrganizationMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void WsGet(){

    	//Create Request
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        if(myRequest.resquestedByUser!=null){
            List<AccountOrganizationWrapper> listAccountWrapper = getAccountOrganizations(myRequest.resquestedByUser.Id);
        	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listAccountWrapper));
    		RestContext.response.addHeader('size', String.valueOf(listAccountWrapper.Size()));
    		RestContext.response.addHeader('Content-Type', 'application/json');
        }
        else{
            RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }
    }
    public static List<AccountOrganizationWrapper> getAccountOrganizations(String userId){

        List<Id> listAccountId = new List<Id>();
        for(Account myAccount : [SELECT Id 
                                 FROM Account 
                                 WHERE ownerId=:userId]){          
            listAccountId.add(myAccount.Id);
        }
        List<OrganizationAccountMember__c>  listOrganizationAccount = [SELECT Id,Name,Account__c,Organization__c,LastModifiedDate,
                                                                       CreatedDate
                                                                       FROM OrganizationAccountMember__c
                                                                       WHERE Account__c IN :listAccountId];
        List<AccountOrganizationWrapper> listAccountWrapper = new List<AccountOrganizationWrapper>();
        for(OrganizationAccountMember__c myOrganization:listOrganizationAccount){
            AccountOrganizationWrapper accountOrganization = new AccountOrganizationWrapper(myOrganization);
            listAccountWrapper.add(accountOrganization);
        }
        return listAccountWrapper;
    } 
    public class AccountOrganizationWrapper{
        public String accountId;
        public String organizationId;
        public Datetime lastModifiedDateTime {get;set;}
        public Datetime createdDateTime {get;set;}
        public AccountOrganizationWrapper(OrganizationAccountMember__c myOrg){
            this.accountId = myOrg.Account__c;
            this.organizationId = myOrg.Organization__c;
            this.lastModifiedDateTime = myOrg.LastModifiedDate;
            this.createdDateTime = myOrg.CreatedDate;
        }
    }                                                                                       
}