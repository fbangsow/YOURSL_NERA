/*
@Company:Your SL
@Author:unkown
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/Accounts/*')
global class WsAccounts implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {

        //create Request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        // do businesslogic
        if(myRequest.resquestedByUser != null) {
            Map<Id,Account> listAccounts = WsAccounts.getAccounts(myRequest.resquestedByUser.Id);
            Map<Id,String> mapContact = new Map<Id,String>();
            for(Contact objCon : [SELECT Id,Name,AccountId 
                                  FROM Contact 
                                  WHERE AccountId IN:listAccounts.keyset()]){
                mapContact.put(objCon.AccountId,objCon.Name);
            } 

            if(!listAccounts.isEmpty()){

                //List<string> accountIds = getAccoutIds(listAccounts.values());

                Map<String,VisitScoreResult__c> mapVisitScoreResults = new Map<String,VisitScoreResult__c>();
                List<VisitScoreResult__c> listVistScoreResults = [SELECT Id,Account__c,Result__c,Date__c
                                                                    FROM VisitScoreResult__c
                                                                    WHERE Account__c = :listAccounts.keyset() order by Date__c desc];
                for(VisitScoreResult__c visitScore : listVistScoreResults){
                    mapVisitScoreResults.put(visitScore.Account__c,visitScore);
                }

                List<AccountWrapper> listAccountWrapper = new LIst<AccountWrapper>();

                for(String accountId : listAccounts.keyset()){
                    AccountWrapper accountWrapper = new AccountWrapper();                   
                        accountWrapper.account = listAccounts.get(accountId);  
                        accountWrapper.contactName = mapContact.containsKey(accountId) ? mapContact.get(accountId): null;  
                        accountWrapper.visitScore = mapvisitScoreResults.containsKey(accountId) ? mapvisitScoreResults.get(accountId).Result__c : null;                    
                        accountWrapper.lastVisitDate = mapvisitScoreResults.containsKey(accountId) ? mapvisitScoreResults.get(accountId).Date__c : null;                                                  
                    listAccountWrapper.add(accountWrapper);
                }

                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listAccountWrapper));
                RestContext.response.addHeader('size', String.valueOf(listAccountWrapper.Size()));
            } else {
                RestContext.response.addHeader('size', '0');
            }
            RestContext.response.statusCode = 200;
        } else {
            RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
    }

    public static Map<Id,Account> getAccounts(Id owner) {

        //to be refactored in a helper class
        Map<String, Map<String, BusinessProcessParameter__c>> mapBusinessProcess = ClsBusinessProcess.getBusinessParameters();
        
        //String soqlQuery ='SELECT Id, Name,VisitScore__c, BillingCity, BillingCountry,GeoLocations__c, GeoLocations__Latitude__s,GeoLocations__Longitude__s,BillingPostalCode, BillingState, BillingStreet, Phone FROM Account WHERE ';
        //soqlQuery +=  (mapBusinessProcess.get('Account custom search')).get('filter').Values__c;
        //    System.debug('test --->' + soqlQuery);
        //String soqlQuery ='SELECT Id, OwnerId,Name,VisitScore__c, BillingCity, BillingCountry,GeoLocations__c, GeoLocations__Latitude__s,GeoLocations__Longitude__s,BillingPostalCode, BillingState, BillingStreet, Phone FROM Account';
        String soqlQuery ='SELECT Id, OwnerId,Name,VisitScore__c, BillingCity, BillingCountry,GeoLocations__c, GeoLocations__Latitude__s,GeoLocations__Longitude__s,BillingPostalCode, BillingState, BillingStreet, Phone FROM Account WHERE Ownerid =: owner';
        List<Account> listAccounts = Database.query(soqlQuery);
        Map<Id,Account> mapAccounts = new Map<Id,Account>();
        for(Account acc: listAccounts){
            mapAccounts.put(acc.Id,acc);
        }
        return mapAccounts;
    }

    public static List<string> getAccoutIds (List<Account> accounts){

        List<string> accountIds = new List<string>();
        for(Account account : accounts){
            accountIds.add(account.Id);
        }

        return accountIds;
    }

    public class AccountWrapper{

        public Account account {get; set;}
        public String contactName;
        public Decimal visitScore {get; set;}
        public Date lastVisitDate {get; set;}
    }
}