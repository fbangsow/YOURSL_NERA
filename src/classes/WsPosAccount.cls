/*
@Company:Your SL
@Author:veera
@Creation date:25/7/2015
Reference: Ticket no 
*/

@RestResource(urlMapping = '/PosAccounts/*')

global class WsPosAccount implements WsPos {

public static WsPosResponse  doReply(WsPosRequest request) {
    return new WsPosResponse ();
  }
  
  static List<Account> listAccounts;
     @HttpGet
     global static void wsPosGet() {
        //create request
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);

    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(getAccountspos(getAccounts())));
    RestContext.response.addHeader('Content-Type', 'application/json');
   
    }
    
     public static List<Account> getAccounts()
     {        
        return  [SELECT Id FROM Account];
     }
     public static List<AccountPosWrapper > getAccountsPos(List<Account> lstAccounts)
     {     
     
      List<AccountPosMember__c> listAccountPosMember = [SELECT Account__c,PageConfig__r.Name
                                                               FROM AccountPosMember__c                                                               
                                                               WHERE Account__c IN: lstAccounts];
                                                                             
      List<AccountPosWrapper> listAccountPosMemberWrapper=new List<AccountPosWrapper>();                             
      for(AccountPosMember__c accountposmember : listAccountPosMember )
        {
           listAccountPosMemberWrapper.add(new AccountPosWrapper(accountposmember));
        }                                                                             
                                                                             
      return listAccountPosMemberWrapper;
                     
         }        
                 
     public class AccountPosWrapper {
        public Id accountId {get; set;}

        public String  posPageConfigName {get; set;}  
        public AccountPosWrapper (AccountPosMember__c accountPOSMember)
        {
            accountId=accountPOSMember.Account__c;
            posPageConfigName =accountPOSMember.PageConfig__r.Name ;        
        }     
    }     

    }