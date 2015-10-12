/*
@Company:Your SL
@Author:Prakash
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/Accounts2/*')

global class WsAccounts2 implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {

        //create Request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        // do businesslogic
        if(myRequest.resquestedByUser != null){
            system.debug('myRequest.resquestedByUser.Id-----------'+myRequest.resquestedByUser.Id);
            List<Account> listAccounts = WsAccounts2.getAccounts(myRequest.resquestedByUser.Id);

            if(!listAccounts.isEmpty()){

                List<string> accountIds = getAccoutIds(listAccounts);

                Map<Id, VisitScoreResult__c> mapVisitScoreResults = new Map<Id, VisitScoreResult__c>([SELECT Id,Account__c,Result__c,Date__c
                                                                                                      FROM VisitScoreResult__c
                                                                                                      WHERE Account__c = :accountIds order by Date__c desc]);
                List<AccountWrapper> listAccountWrapper = new LIst<AccountWrapper>();
                Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();

                for(string accountId : accountIds){
                    AccountWrapper accountWrapper = new AccountWrapper();

                    for(Account account : listAccounts){
                        if(account.Id == accountId){
                            accountWrapper.account = account;
                            accountWrapper.fields = new List<Field>();
                            accountWrapper.Id = accountId;
                            
                            Map<String, Object> queriedFieldValues = new Map<String, Object>();

                            for(String fieldName: schemaFieldMap.keySet()){
                                try { 
                                    queriedFieldValues.put(fieldName, account.get(fieldName)); 
                                    Field field = new Field();
                                    field.fieldName = fieldName;
                                    field.fieldValue = string.valueOf(account.get(fieldName));
                                	field.fieldType = string.valueOf(schemaFieldMap.get(fieldName).getDescribe().getSoapType());
                                    accountWrapper.fields.add(field);

                                } catch (SObjectException e)    { 
                                    // Intentional capture 
                                }
                            }

                            break;
                        }
                    }

                    for(VisitScoreResult__c visitScoreResult : mapvisitScoreResults.values()){
                        if(visitScoreResult.Account__c == accountId){
                            accountWrapper.visitScore = visitScoreResult.Result__c;
                            accountWrapper.lastVisitDate = String.valueOf(visitScoreResult.Date__c);
                        }
                    }

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

    public static List<Account> getAccounts(Id owner) {

        //to be refactored in a helper class
        Map<String, Map<String, BusinessProcessParameter__c>> mapBusinessProcess = ClsBusinessProcess.getBusinessParameters();
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();
        String soqlQuery ='SELECT ';
        for(String fieldName: schemaFieldMap.keySet()){
        	soqlQuery += fieldName + ',';
        }
        soqlQuery = soqlQuery.substring(0,soqlQuery.length()-1); 
        soqlQuery += ' FROM Account WHERE OwnerId = ';
        soqlQuery +=  '\'' + owner + '\' ' + (mapBusinessProcess.get('Account custom search')).get('filter').Values__c;
        System.debug('test --->' + soqlQuery);                      
        List<Account> listAccounts = Database.query(soqlQuery);
        return listAccounts;
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
        public Decimal visitScore {get; set;}
        public String lastVisitDate {get; set;}
        public Id Id{get; set;}
        public List<Field> fields{get; set;}

    }
    public class Field{
        public String fieldName{get; set;}
        public String fieldType{get; set;}
        public String fieldValue{get; set;}
    }
}