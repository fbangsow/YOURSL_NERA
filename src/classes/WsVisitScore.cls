/*
@Company:Your SL
@Author:
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/VisitScore/*')
global class WsVisitScore implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {

        String myAccounts = RestContext.request.params.get('accounts');
        Set<String> setAccIds = (Set<String>) JSON.deserialize(myAccounts, Set<String>.class);
        
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        Map<String, Map<Id, Account>> mapAccounts = getAccounts(setAccIds);

        Map<Id, List<DatasetResult>> myDataSet = getDataSet(mapAccounts.get('known'));
        
        //Prakash
        List<DatasetResultWrapper> myResultList = new List<DatasetResultWrapper>();

        for(List<DatasetResult> wrp : myDataSet.values()){
                DatasetResultWrapper wrapper = new DatasetResultWrapper(wrp);
                myResultList.add(wrapper);
        }
        //prakash

        //TODO make the return 
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(myResultList)); //prakash
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = myRequest.statusCode;
    }

    public static Map<String, Map<Id, Account>> getAccounts(Set<String> myAccountIds) {
        
        Map<String, Map<Id, Account>> mapResult = new Map<String, Map<Id, Account>>();

        //Logic
        //get known accounts
        Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id
                                                             FROM Account
                                                             WHERE Id = : myAccountIds]);
        if(!mapAccounts.isEmpty()){
            mapResult.put('known' , mapAccounts);
        }

        // get unknown accounts
        Map<Id, Account> mapUnknownAccounts = new Map<Id, Account>();
        for(String myAccountId : myAccountIds){
            if(!mapAccounts.containsKey(myAccountId)){
                mapUnknownAccounts.put(myAccountId, new Account());
            }
        }
        if(!mapUnknownAccounts.isEmpty()){
            mapResult.put('unknown' , mapUnknownAccounts);
        }

        return mapResult;
    }
    // Map<AccountID < List<DateSetResult(order by datetime ) >>
    public static Map<Id, List<DatasetResult>> getDataSet(Map<Id, Account> mapAccounts) {

        Map<Id, List<DatasetResult>> myResult = new Map<Id, List<DatasetResult>>();

        //do logic
        Map<Id, VisitScoreResult__c> mapVisitScoreResults = new Map<Id, VisitScoreResult__c>([SELECT Id,Account__c,Result__c,Date__c
                                                                                              FROM VisitScoreResult__c
                                                                                              WHERE Account__c =: mapAccounts.keyset()]);
        Map<Id, VisitScoreResultType__c> mapVisitScoreResultTypes;
        Map<Id, VisitScoreType__c> mapVisitScoreTypes;
               
        Map<Id,VisitScoreResultPotential__c> mapVisitScoreResultPotentials;
        Map<Id,VisitScorePotential__c> mapVisitScorePotentials;
        Map<Id,VisitScorePotentialGroup__c> myVisitScorePotentialGroups;

                
        if(!mapVisitScoreResults.isEmpty()){

            //*******************************************************************
            mapVisitScoreResultTypes = new Map<Id, VisitScoreResultType__c>([SELECT Id , VisitScoreResult__c,VisitScoreType__c,ResultInPercentage__c
                                                                             FROM VisitScoreResultType__c
                                                                             WHERE VisitScoreResult__c =: mapVisitScoreResults.keyset()]);           
            Set<String> myVisitScoreTypeIds = new Set<String>();
            for(VisitScoreResultType__c myVisitScoreType : mapVisitScoreResultTypes.values()){
                myVisitScoreTypeIds.add(myVisitScoreType.VisitScoreType__c);
            }

            if(!myVisitScoreTypeIds.isEmpty()){
                mapVisitScoreTypes = new Map<Id, VisitScoreType__c>([SELECT Id , Name,Order__c 
                                                                     FROM  VisitScoreType__c
                                                                     WHERE Id =: myVisitScoreTypeIds]);
            }   


            //*******************************************************************
            mapVisitScoreResultPotentials = new Map<Id, VisitScoreResultPotential__c>([SELECT Id ,VisitScoreResult__c, VisitScorePotential__c
                                                                                       FROM VisitScoreResultPotential__c
                                                                                       WHERE VisitScoreResult__c =: mapVisitScoreResults.keyset()]);
            
            Set<String> myVisitScorePotentialIds = new Set<String>();
            for(VisitScoreResultPotential__c myVisitScoreResultPotential : mapVisitScoreResultPotentials.values()){
                myVisitScorePotentialIds.add(myVisitScoreResultPotential.VisitScorePotential__c);
            }

            if(!myVisitScorePotentialIds.isEmpty()){
                mapVisitScorePotentials = new Map<Id, VisitScorePotential__c>([SELECT Id,Order__c,VisitScorePotentialGroup__c,Name
                                                                               FROM  VisitScorePotential__c
                                                                               WHERE Id =: myVisitScorePotentialIds]);
            }
            
            //*******************************************************************
            Set<String> myVisitScorePotentialGroupId = new Set<String>();
            if(mapVisitScorePotentials != null && mapVisitScorePotentials.values() != null && !mapVisitScorePotentials.values().isEmpty()){
                for(VisitScorePotential__c myVisitScorePotentialGroup : mapVisitScorePotentials.values() ){
                   myVisitScorePotentialGroupId.add(myVisitScorePotentialGroup.VisitScorePotentialGroup__c);
                }
            }

             if(!myVisitScorePotentialGroupId.isEmpty()){
                  myVisitScorePotentialGroups= new Map<Id,VisitScorePotentialGroup__c>([SELECT Id,Name,Order__c 
                                                                                        FROM VisitScorePotentialGroup__c 
                                                                                        WHERE Id=:myVisitScorePotentialGroupId]);
             }  
            
            for(Account acc :  mapAccounts.values()){

                List<DatasetResult> listVisitScoreResults = new List<DatasetResult>();
                for(VisitScoreResult__c rsr: mapVisitScoreResults.values()){
                    if(rsr.Account__c == acc.Id){
                        
                        DatasetResult myResults = new DatasetResult(rsr);
                        listVisitScoreResults.add(myResults);
                        
                        //*******************************************************************
                        //get the redscoreType
                        List<VisitScoreResultType> visitScoreResultTypes = new List<VisitScoreResultType>();
                        for(VisitScoreResultType__c type :mapVisitScoreResultTypes.values()){

                            if(rsr.id == type.VisitScoreResult__c){
                                visitScoreResultTypes.add(new VisitScoreResultType(type,mapVisitScoreTypes.get(type.VisitScoreType__c)));
                            }
                        }
                        myResults.visitScoreResultTypes = visitScoreResultTypes;

                        //*******************************************************************
                        //get the potential
                        Map<String,List<VisitScoreResultPotential>> mapPotential = new Map<String,List<VisitScoreResultPotential>>();
                        
                        for(VisitScoreResultPotential__c pontenti : mapVisitScoreResultPotentials.values()){
                            if(rsr.id == pontenti.VisitScoreResult__c){

                                VisitScorePotential__c myPotential = mapVisitScorePotentials.get(pontenti.VisitScorePotential__c);
                                VisitScorePotentialGroup__c potentialGroup = myVisitScorePotentialGroups.get(myPotential.VisitScorePotentialGroup__c);

                                if(!mapPotential.containsKey(potentialGroup.Name)){
                                    List<VisitScoreResultPotential> listResultpotentials = new List<VisitScoreResultPotential>();
                                    listResultpotentials.add(new VisitScoreResultPotential(pontenti,myPotential));
                                    mapPotential.put(potentialGroup.Name, listResultpotentials);
                                }else{
                                    mapPotential.get(potentialGroup.Name).add(new VisitScoreResultPotential(pontenti,myPotential));
                                }
                            }
                        }

                        List<VisitScorePotentialGroupJsonModel> visitScorePotentialGroups = new List<VisitScorePotentialGroupJsonModel>(); //prakash
                        for(string potentialGroupName :mapPotential.keySet())
                        {
                            VisitScorePotentialGroupJsonModel model = new VisitScorePotentialGroupJsonModel(potentialGroupName, mapPotential.get(potentialGroupName));
                            visitScorePotentialGroups.add(model);
                        }

                        myResults.visitScorePotentialGroups = visitScorePotentialGroups;
                        
                    }
                }
                
                myResult.put(acc.Id,listVisitScoreResults);
            }
                     
        }
            //this is just for debugging
            Integer counter =0;
            for(Id data : myResult.keySet()){
                system.debug('kim account (' + counter + ')'  + '   --> ' + data);
                Integer counter2 =0;
                for(DatasetResult result : myResult.get(data)){
                    system.debug('kim VisitscoreResult (' + counter2 + ')  --> ' + result.visitDate + ' : ' + result.result );
                    counter2++;

                    Integer counterTypes = 0;
                    for(VisitScoreResultType  type :result.visitScoreResultTypes){
                        System.debug('kim VisitScoreType :' + counterTypes + '  :' + type.name + '  :  ' + type.result);
                        counterTypes++;
                    }

                }
                counter++;
            }
        //bind visitscoreresultTypes
        system.debug('test::: ' + String.valueof(Blob.valueOf(JSON.serialize(myResult))));
        return myResult;
    }
    // wrapper for VisitScoreResult__c
    public class DatasetResult {

        public Decimal result {get; set;}
        public String visitDate {get; set;}
        public String accountId {get; set;}
        public List<VisitScoreResultType> visitScoreResultTypes {get; set;}
        public List<VisitScorePotentialGroupJsonModel> visitScorePotentialGroups {get; set;}
        public DatasetResult(VisitScoreResult__c rsr){
            this.result = rsr.Result__c;
            this.visitDate = String.valueOf(rsr.Date__c);
            this.accountId = rsr.Account__c;
        }
    }

    //Prakash
    public class DatasetResultWrapper {
        public List<DatasetResult> visitScores{get; set;}

        public DatasetResultWrapper(List<DatasetResult> datasetResultList){
            //this.accountId = accountId;
            this.visitScores = datasetResultList;
        }
    }
    //Prakash

    public class VisitScoreResultType {

        public String name {get; set;}
        public Decimal result {get; set;}
        public Decimal order {get; set;}

        public VisitScoreResultType(VisitScoreResultType__c rsrt,  VisitScoreType__c rst){
            this.result = rsrt.ResultInPercentage__c;
            this.order = rst.Order__c;
            this.name = rst.Name;
        }

    }

    public class VisitScoreType {

        public String name {get; set;}
        public Integer order {get; set;}
    }

    public class VisitScoreResultPotential {

        public String name {get; set;}
        public Decimal order {get; set;}

        public VisitScoreResultPotential(VisitScoreResultPotential__c rsrp, VisitScorePotential__c pot){
            this.name = pot.name;
            this.order = pot.Order__c;
        }
    }

    public class VisitScorepotential {

        public String name {get;set;}
        public Integer order {get; set;}

    }

    public class VisitScorePotentialGroup {

        public String name {get; set;}
        public Integer order {get; set;}

    }

//prakash
    public class VisitScorePotentialGroupJsonModel{
        public String groupName {get; set;}
        public List<VisitScoreResultPotential> visitScoreResultPotentials {get; set;}

        public VisitScorePotentialGroupJsonModel(String groupName, List<VisitScoreResultPotential> visitScoreResultPotentials){
            this.groupName = groupName;
            this.visitScoreResultPotentials = visitScoreResultPotentials;
        }
    }

    public class MyAccount{

        public String id {get;set;}
    }

    public static List<MyAccount> deserializeMyEventRequest(String request) {
        List<MyAccount> listMyAccount = null;
        if(!String.isEmpty(request)){
            listMyAccount = (List<MyAccount>) JSON.deserialize(request, List<MyAccount>.class);
        }
        return listMyAccount;
    }

}