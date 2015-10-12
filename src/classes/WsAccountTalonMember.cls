/*
@Company:Your SL
@Author:Pavan
@Creation date:9/2/2015
Reference:ticket no:1114
*/
@RestResource(urlMapping = '/AccountTalonMember/*')

global class WsAccountTalonMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void wsGet() {
    	//Create Request
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	if(myRequest.resquestedByUser!=null){
    		List<AccountTalonWrapper> listAccountTalonWrap = getAccountTalons(myRequest.resquestedByUser.Id);
    		RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listAccountTalonWrap));
        	RestContext.response.addHeader('size', String.valueOf(listAccountTalonWrap.Size()));
        	RestContext.response.addHeader('Content-Type', 'application/json');
    	}
    	else{
    		RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
    	}
    }
    public static List<AccountTalonWrapper> getAccountTalons(String userId){
    	
    	List<Id> listAccountId = new List<Id>();
    	for(Account myAccount:[SELECT Id,Name 
    						   FROM Account 
    						   WHERE OwnerId=:userId]){
    		listAccountId.add(myAccount.Id);
    	}
    	List<AccountTalonMember__c> listAccountTalons = [SELECT Id,Name,Account__c,Talon__c,
    													 LastModifiedDate,CreatedDate 
    											 		 FROM AccountTalonMember__c
    											 		 WHERE Account__c=:listAccountId];

   		List<AccountTalonWrapper> listAccountTalon = new List<AccountTalonWrapper>();
   		for(AccountTalonMember__c myAccountTalon:listAccountTalons){
   			AccountTalonWrapper accountTalon = new AccountTalonWrapper(myAccountTalon);
   			listAccountTalon.add(accountTalon);
   		}
   		return listAccountTalon;
    }
    public class AccountTalonWrapper{
    	public String accountId;
    	public String talonId;
    	public Datetime lastModifiedDate;
    	public Datetime createdDate;

    	public AccountTalonWrapper(AccountTalonMember__c myAccount){
    		this.accountId = myAccount.Account__c;
    		this.talonId = myAccount.Talon__c;
    		this.lastModifiedDate = myAccount.LastModifiedDate;
    		this.createdDate = myAccount.CreatedDate;
    	}
    }	
}