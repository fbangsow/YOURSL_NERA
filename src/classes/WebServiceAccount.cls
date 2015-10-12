@RestResource(urlMapping='/Account/*')

global class WebServiceAccount{
   
    @HttpGet
    global static List<Account> getAccounts(){
      List<Account> accounts ; 
      try 
        { 
             RestRequest req = RestContext.request;
             RestResponse res = RestContext.response;
             //String UserId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
             String UserId = req.params.get('userId');
             accounts = [SELECT Name,OwnerId from Account WHERE OwnerId =:UserId Limit 50000];
             return accounts;
        } Catch(Exception e){
         System.debug('exceed more than 50000 Records : ' + e.getMessage());
        }
      return accounts;
    }
}