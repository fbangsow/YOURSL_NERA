/*
@Company:Your SL
@Author:Pavan
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/AccountPriceBookMember/*')
global class WsAccountPriceBookMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void wsGet() {
        //Create request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        if(myRequest.resquestedByUser!=null){
            List<AccountPriceBookWrapper> listAccountWrapper = getAccountPriceBookMember(myRequest.resquestedByUser.Id);
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listAccountWrapper));
            RestContext.response.addHeader('size', String.valueOf(listAccountWrapper.Size()));
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
        else{
            RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }
    }
    public static List<AccountPriceBookWrapper> getAccountPriceBookMember(String userId){

        List<Id> listaccountId = new List<Id>();
        for(Account myAccount : [SELECT Id 
                                 FROM Account 
                                 WHERE ownerId=:userId]){
            listaccountId.add(myAccount.Id);

        }
        List<AccountPriceBookMember__c> listAccountPriceBooks = [SELECT Id,Name,AccountId__c,PriceBookId__c,
                                                                        StartDate__c,EndDate__c,LastModifiedDate,CreatedDate
                                                                 FROM AccountPriceBookMember__c
                                                                 WHERE AccountId__c IN:listaccountId];
        List<AccountPriceBookWrapper> listAccountPriceBook = new List<AccountPriceBookWrapper>();
        for(AccountPriceBookMember__c myAccount:listAccountPriceBooks){
            AccountPriceBookWrapper accountWrapper = new AccountPriceBookWrapper(myAccount);
            listAccountPriceBook.add(accountWrapper);
        }
        return listAccountPriceBook;
    }
    public class AccountPriceBookWrapper{
        public String accountId {get;set;}
        public String priceBookId {get;set;}
        public Date startDate {get;set;}
        public Date endDate {get;set;}
        public Datetime lastModifiedDateTime {get;set;}
        public Datetime createdDateTime {get;set;}

        public AccountPriceBookWrapper(AccountPriceBookMember__c mypriceBook){
            this.accountId = mypriceBook.AccountId__c;
            this.priceBookId = mypriceBook.PriceBookId__c;
            this.startDate = mypriceBook.StartDate__c;
            this.endDate = mypriceBook.EndDate__c;
            this.lastModifiedDateTime = mypriceBook.LastModifiedDate;
            this.createdDateTime = mypriceBook.CreatedDate;

        }
    }
}