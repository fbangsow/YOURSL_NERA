/*
@Company:Your SL
@Author:Pavan
@Creation date:
Reference:
*/

@RestResource(urlMapping = '/AccountPromotionMember/*')
global class WsAccountPromotionMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
    	// do businesslogic
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);  
        if(myRequest.resquestedByUser!=null){  	
        	List<AccountPromotionWrapper> listAccountPromotions = getAccountPromotions(myRequest.resquestedByUser.Id);
        	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listAccountPromotions));
        	RestContext.response.addHeader('size', String.valueOf(listAccountPromotions.Size()));
        	RestContext.response.addHeader('Content-Type', 'application/json');
        }
        else{
            RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }
    }
    public static List<AccountPromotionWrapper> getAccountPromotions(String userId){

        List<Id> listAccountId = new List<Id>();
        for(Account myAccount : [SELECT Id 
                                 FROM Account 
                                 WHERE ownerId=:userId]){          
            listAccountId.add(myAccount.Id);
        }
    	
        List<AccountPromotionMember__c> listAccountPromomembers = [SELECT Id,Name,Account__c,Promotion__c,
                                                                   LastModifiedDate,CreatedDate 
    															   FROM AccountPromotionMember__c
    															   WHERE Account__c IN:listAccountId];
    	List<AccountPromotionWrapper> listAccountPromotions = new List<AccountPromotionWrapper>();
    	for(AccountPromotionMember__c myAccountPromo:listAccountPromomembers){
    		AccountPromotionWrapper accountWrapper = new AccountPromotionWrapper(myAccountPromo);
    		listAccountPromotions.add(accountWrapper);
    	}
    	return listAccountPromotions;
    }
    public class AccountPromotionWrapper{
        public String accountPromotionId;
    	public String accountId{get; set;}
    	public String promotionId{get;set;}
        public Datetime lastModifiedDateTime {get;set;}
        public Datetime createdDateTime {get;set;}

    	public AccountPromotionWrapper(AccountPromotionMember__c myAccount){
            this.accountPromotionId = myAccount.Id;
    		this.accountId = myAccount.Account__c;
    		this.promotionId = myAccount.Promotion__c;
            this.lastModifiedDateTime = myAccount.LastModifiedDate;
            this.createdDateTime = myAccount.CreatedDate;
    	}
    }
}