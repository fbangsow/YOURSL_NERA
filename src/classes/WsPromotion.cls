/*
@Company:Your SL
@Author:Parasuram
@Creation date:28/7/2015
@Reference: Ticket no 438
*/
@RestResource(urlMapping = '/Promotion/*')
global class WsPromotion implements UcbWs {

  public static UcbWsResponse doReply(UcbWsRequest request) {
    return new UcbWsResponse();
  }
  static List<Account> listAccounts;
  @HttpGet
  global static void wsGet() {
        //create request
    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    String strAccounts = '';
    if(myRequest.resquestedByUser != null) 
    {
      strAccounts = RestContext.request.params.get('accounts');
      System.debug('@@@In Get : accountIds Json From Request Param is' + strAccounts);

      //If there are no accounts in the request, Exit from the method.
      if(String.isEmpty(strAccounts))
      {
        myRequest.errorMessage = 'no requested accounts';
        myRequest.statusCode = 400;
        RestContext.response.addHeader('size', '0');
        RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
        RestContext.response.statusCode = myRequest.statusCode;
        RestContext.response.addHeader('Content-Type', 'application/json');
        return;
      }

      listAccounts = getAccountsFromRequest(strAccounts,myRequest.resquestedByUser);
      if(!listAccounts.isEmpty()) 
      {
        Map<Id,Set<String>> mapAccountOrgs = getAccountOrganizations(listAccounts);
        Map<Id,Set<String>> mapOrgPromotion = getOrganizationPromotions(mapAccountOrgs);
        Map<Id,Set<String>> mapAccountPromotion = getAccountPromotions(listAccounts);
        Map<Id,Set<String>> mapAccountUniquePromotions = getAccountUniquePromotions(listAccounts,mapOrgPromotion,mapAccountPromotion);
        Map<Id,Promotion__c> mapPromotions = getPromotions(mapAccountUniquePromotions);
        Map<Id,Set<String>> mapPromotionPBEntries = getPromotionPriceBookEntry(mapAccountUniquePromotions);
        Map<Id,PriceBookEntry> mapPriceBookEntry = getPriceBookEntries(mapPromotionPBEntries);
        Map<Id,Map<String,ProductGroup>> mapProductProductGroups = getProductIdGroups(mapPriceBookEntry);
        List<AccountWrapper> listDataset = getAccountPromotions(listAccounts,
                              mapAccountUniquePromotions,
                              mapPromotionPBEntries,
                              mapPriceBookEntry,
                              mapProductProductGroups,mapPromotions);

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listDataset));
        RestContext.response.addHeader('size', String.valueOf(listDataset.Size()));
      }  
          else  //Accounts List is Empty
          {
          RestContext.response.addHeader('size', '0');
          RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
          RestContext.response.statusCode = myRequest.statusCode;
          }
    } 
    else //Requested By User is NULL
    {
      RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
      RestContext.response.statusCode = myRequest.statusCode;
    }
    RestContext.response.addHeader('Content-Type', 'application/json');
  }
  
  // Return requested Accounts based on user
  public static List<Account> getAccountsFromRequest(String accountIDs, User user) {
    List<Account> lstAccounts = new List<Account>();
    List<Id> listAccountIds = (List<Id>) JSON.deserialize(accountIDs, List<Id>.class);
    return  [SELECT Id 
             FROM Account 
             WHERE Id IN: listAccountIds AND Ownerid =: user.Id];    
  }

  // Account related Organizations
  public static Map<Id,Set<String>> getAccountOrganizations(List<Account> lstAccounts){
    List<OrganizationAccountMember__c> listOrgAccounts = [SELECT Account__c,Organization__c
                                    FROM OrganizationAccountMember__c 
                                    WHERE Account__c IN: lstAccounts];
    Map<Id,Set<String>> mapAccountOrgs = new Map<Id,Set<String>>();
    for(OrganizationAccountMember__c orgAccountMember: listOrgAccounts){
      Set<String> setOrgIds = new Set<String>();
      if(mapAccountOrgs.containskey(orgAccountMember.Account__c)){
        setOrgIds = mapAccountOrgs.get(orgAccountMember.Account__c);
        setOrgIds.add(orgAccountMember.Organization__c);
        mapAccountOrgs.put(orgAccountMember.Account__c,setOrgIds);
      }
      else{
        setOrgIds.add(orgAccountMember.Organization__c);
        mapAccountOrgs.put(orgAccountMember.Account__c,setOrgIds);
      }
    }
    return mapAccountOrgs;
  }

  // organization related Promotions
  public static Map<Id,Set<String>> getOrganizationPromotions(Map<Id,Set<String>> setAccountOrgs){
    Map<Id,Set<String>> mapOrgPromotions = new Map<Id,Set<String>>();
    Map<String,String> mapOrgIdAccountId = new Map<String,String>(); 
    for(Id accountId : setAccountOrgs.keyset()){
      Set<String> setIds = setAccountOrgs.get(accountId);
      for(String str : setIds){
        mapOrgIdAccountId.put(str,string.valueof(accountId));
      }
      
    }

    List<OrganizationPromotionMember__c> listOrgPromotions = [SELECT Organization__c,Promotion__c
                                    FROM OrganizationPromotionMember__c 
                                    WHERE Organization__c IN: mapOrgIdAccountId.keyset()];

    for(OrganizationPromotionMember__c orgPromotion : listOrgPromotions){
      Set<String> setPromotionIds = new Set<String>();

      if(mapOrgPromotions.containskey(mapOrgIdAccountId.get(orgPromotion.Organization__c))){
        setPromotionIds = mapOrgPromotions.get(mapOrgIdAccountId.get(orgPromotion.Organization__c));
        setPromotionIds.add(orgPromotion.Promotion__c);
        mapOrgPromotions.put(mapOrgIdAccountId.get(orgPromotion.Organization__c),setPromotionIds);
      }
      else{
        setPromotionIds.add(orgPromotion.Promotion__c);
        mapOrgPromotions.put(mapOrgIdAccountId.get(orgPromotion.Organization__c),setPromotionIds);
      }
    }
    return mapOrgPromotions;
  }
  
  // Account related Promotions
  public static Map<Id,Set<String>> getAccountPromotions(List<Account> lstAccounts){
    List<AccountPromotionMember__c> listAccountPromotions = [SELECT Account__c,Promotion__c
                                    FROM AccountPromotionMember__c 
                                    WHERE Account__c IN: lstAccounts];
    Map<Id,Set<String>> mapAccountPromotions = new Map<Id,Set<String>>();
    for(AccountPromotionMember__c accountPromotion : listAccountPromotions){
      Set<String> setPromotionIds = new Set<String>();
      if(mapAccountPromotions.containskey(accountPromotion.Account__c)){
        setPromotionIds = mapAccountPromotions.get(accountPromotion.Account__c);
        setPromotionIds.add(accountPromotion.Promotion__c);
        mapAccountPromotions.put(accountPromotion.Account__c,setPromotionIds);
      }
      else{
        setPromotionIds.add(accountPromotion.Promotion__c);
        mapAccountPromotions.put(accountPromotion.Account__c,setPromotionIds);
      }
    }
    return mapAccountPromotions;
  }

  // Account with related promotions
  public static Map<Id,Set<String>> getAccountUniquePromotions(List<Account> accounts, Map<Id,Set<String>> orgPromotions, Map<Id,Set<String>> accountPromotions){
    Map<Id,Set<String>> mapAccountUniPromotions = new Map<Id,Set<String>>();
    for(Account acc : accounts){
      Set<String> setPromotions = new Set<String>();
      if(orgPromotions.containskey(acc.id)){
        Set<String> setOrgids = orgPromotions.get(acc.id);
        for(String str : setOrgids){
          setPromotions.add(str);
        }
      }

      if(accountPromotions.containskey(acc.id)){
        Set<String> setOrgids = accountPromotions.get(acc.id);
        for(String str : setOrgids){
          setPromotions.add(str);
        }
      }
      mapAccountUniPromotions.put(acc.id,setPromotions);
    }
    return mapAccountUniPromotions;
  }

  // Return all Promotions data
  public static Map<Id,Promotion__c> getPromotions(Map<Id,Set<String>> promotions){
    Set<String> setPromotionIds = new Set<String>();
    for(Id idval : promotions.keyset()){
      Set<String> setIds = promotions.get(idval);
      for(String str : setIds){
        setPromotionIds.add(str);
      }
    }
    Map<Id,Promotion__c> mapPromotions = new Map<Id,Promotion__c>([SELECT Id,Name,
                                      StartDate__c,EndDate__c,Image__c  
                                    FROM Promotion__c 
                                    WHERE Id IN: setPromotionIds]);
    return mapPromotions;
  }

  // get all promotion priceBookEntries
  public static Map<Id,Set<String>> getPromotionPriceBookEntry(Map<Id,Set<String>> mapPromotions){
    Set<String> setPromotionIds = new Set<String>();
    for(Id idval : mapPromotions.keyset()){
      Set<String> setIds = mapPromotions.get(idval);
      for(String str : setIds){
        setPromotionIds.add(str);
      }

    }
    Map<Id,Set<String>> mapPromotionPriceBookEntries = new Map<Id,Set<String>>();
    List<PromotionMember__c> listPromotionMembers = [SELECT Id,Name,Promotion__c,PriceBookEntryId__c 
                              FROM PromotionMember__c 
                              WHERE Promotion__c IN: setPromotionIds];
    
    for(PromotionMember__c member : listPromotionMembers){
      Set<String> setPBEntry = new Set<String>();
      if(mapPromotionPriceBookEntries.containskey(member.Promotion__c)){
        setPBEntry = mapPromotionPriceBookEntries.get(member.Promotion__c);
        setPBEntry.add(member.PriceBookEntryId__c);
        mapPromotionPriceBookEntries.put(member.Promotion__c,setPBEntry);
      }
      else{
        setPBEntry.add(member.PriceBookEntryId__c);
        mapPromotionPriceBookEntries.put(member.Promotion__c,setPBEntry);
      }
    }
    return mapPromotionPriceBookEntries;
  }

  // Based on promotions return all price Book Entries
  public static Map<Id,PriceBookEntry> getPriceBookEntries(Map<Id,Set<String>> mapPromotionPbEs){
    Set<String> setPBEntries = new Set<String>();
    for(Id idval : mapPromotionPbEs.keyset()){
      Set<String> setPbs = mapPromotionPbEs.get(idval);
      for(String str : setPbs)
      setPBEntries.add(str);
    }
    Map<Id, PricebookEntry> mapPriceBookEntry = new Map<Id, PricebookEntry>([SELECT Id, Name,
                                            IsActive,Product2Id,
                                            ProductCode,UnitPrice, 
                                            UseStandardPrice,
                                            Pricebook2Id,Can__c  
                                        FROM PricebookEntry 
                                        WHERE Id IN: setPBEntries]);
    return mapPriceBookEntry;
  }

  // To get product with related product groups
  public static Map<Id,Map<String,ProductGroup>> getProductIdGroups(Map<Id, PricebookEntry> priceBookEntries){
    Map<Id,Map<String,ProductGroup>> mapProductAndProductGroups = new Map<Id,Map<String,ProductGroup>>();
    Set<String> setProducts = new Set<String>();

    for(PricebookEntry pbe : priceBookEntries.values()){
      setProducts.add(pbe.product2id);
    }

    List<ProductGroupMember__c> listProductGroupMembers = [SELECT Id, Name,Product2Id__c,ProductGroup__c,ProductGroup__r.Name,
                                    ProductGroup__r.ParentGroup__c,ProductGroup__r.ParentGroup__r.Name,
                                    ProductGroup__r.StartDate__c,ProductGroup__r.EndDate__c,ProductGroup__r.Image__c  
                                FROM ProductGroupMember__c 
                                WHERE Product2Id__c IN: setProducts];
    for(ProductGroupMember__c member : listProductGroupMembers){
      Map<String,ProductGroup> mapProductGroup = new Map<String,ProductGroup>();
      if(mapProductAndProductGroups.containskey(member.Product2Id__c)){
        mapProductGroup = mapProductAndProductGroups.get(member.Product2Id__c);
        ProductGroup wrapGroup = new ProductGroup();
        wrapGroup.name = member.ProductGroup__r.Name;
        wrapGroup.id = member.ProductGroup__c;
        wrapGroup.parentGroupName = member.ProductGroup__r.ParentGroup__r.Name;
        wrapGroup.parentGroupId = member.ProductGroup__r.ParentGroup__c;
        wrapGroup.startDate = member.ProductGroup__r.StartDate__c;
        wrapGroup.endDate = member.ProductGroup__r.EndDate__c;
        wrapGroup.image = member.ProductGroup__r.Image__c;
        mapProductGroup.put(wrapGroup.id,wrapGroup);
        mapProductAndProductGroups.put(member.Product2Id__c,mapProductGroup);
      }
      else{
        ProductGroup wrapGroup = new ProductGroup();
        wrapGroup.name = member.ProductGroup__r.Name;
        wrapGroup.id = member.ProductGroup__c;
        wrapGroup.parentGroupName = member.ProductGroup__r.ParentGroup__r.Name;
        wrapGroup.parentGroupId = member.ProductGroup__r.ParentGroup__c;
        wrapGroup.startDate = member.ProductGroup__r.StartDate__c;
        wrapGroup.endDate = member.ProductGroup__r.EndDate__c;
        wrapGroup.image = member.ProductGroup__r.Image__c;
        mapProductGroup.put(wrapGroup.id,wrapGroup);
        mapProductAndProductGroups.put(member.Product2Id__c,mapProductGroup);
      }
    }
    return mapProductAndProductGroups;
  }

  // To get Account with related promotions
  public static List<AccountWrapper> getAccountPromotions(List<Account> lstAccounts,
                              Map<Id,Set<String>> mapUniAccountPromotions,
                              Map<Id,Set<String>> promotionPBEntries,
                              Map<Id,PriceBookEntry> priceBookEntry,
                              Map<Id,Map<String,ProductGroup>> productProductGroups,
                              Map<Id,Promotion__c> idPromotions){
    List<AccountWrapper> listAccountPromotions = new List<AccountWrapper>();
    
    for(Account acc : lstAccounts){
      AccountWrapper accWrap = new AccountWrapper();
      accWrap.accountId = acc.id;
      accWrap.promotions = new List<PromotionWrapper>();
      Set<String> setPromotions = mapUniAccountPromotions.get(acc.id);
      for(String proStr : setPromotions){
        PromotionWrapper proWrap = new PromotionWrapper();
        proWrap.promotionName = idPromotions.get(proStr).Name;
        proWrap.promotionId = proStr;
        proWrap.startDate = idPromotions.get(proStr).StartDate__c;
        proWrap.endDate = idPromotions.get(proStr).EndDate__c;
        proWrap.image = idPromotions.get(proStr).Image__c;
        proWrap.productGroups = new List<GroupWrapper>();
        Map<String,GroupWrapper> mapGroupWrapper = new Map<String,GroupWrapper>();

        Set<String> setPBentries = promotionPBEntries.get(proStr);
        for(String pBEntrystr : setPBentries){
          if(priceBookEntry.containskey(pBEntrystr)){
            String productId = priceBookEntry.get(pBEntrystr).Product2Id;
            Map<String,ProductGroup> mapPrGroup = productProductGroups.get(productId);
            if(mapPrGroup != null)
            for(String groupStr : mapPrGroup.keyset()){
              GroupWrapper groupWrap = new GroupWrapper();
              groupWrap.id = mapPrGroup.get(groupStr).id;
              groupWrap.name = mapPrGroup.get(groupStr).name;
              groupWrap.parentGroupName = mapPrGroup.get(groupStr).parentGroupName;
              groupWrap.parentGroupId = mapPrGroup.get(groupStr).parentGroupId;
              groupWrap.startDate = mapPrGroup.get(groupStr).startDate;
              groupWrap.enddate = mapPrGroup.get(groupStr).endDate;
              groupWrap.image = mapPrGroup.get(groupStr).image;
              groupWrap.products = new List<ProductsWrapper>();
              if(mapGroupWrapper.containskey(groupWrap.id)){
                groupWrap.products = mapGroupWrapper.get(groupWrap.id).products;
                ProductsWrapper prdWrap = new ProductsWrapper(priceBookEntry.get(pBEntrystr));
                groupWrap.products.add(prdWrap);
              }
              else{
                ProductsWrapper prdWrap = new ProductsWrapper(priceBookEntry.get(pBEntrystr));
                groupWrap.products.add(prdWrap);
              }
              mapGroupWrapper.put(groupWrap.id,groupWrap);            
                          
            }
          }
        }
        proWrap.productGroups = mapGroupWrapper.values();
        accWrap.promotions.add(proWrap);
      }
      listAccountPromotions.add(accWrap);
    }
    return listAccountPromotions;
  }

  // Wrapper class to get Groups
  public class GroupWrapper{
    public String id{set;get;}
    public String name{set;get;}
    public String parentGroupName{get; set;}
    public String parentGroupId{get; set;}
    public Date startDate{get; set;}
    public Date endDate{get; set;}
    public String image{get; set;}
    public List<ProductsWrapper> products{set;get;}
  }

  // Wrapper class to get product group
  public class ProductGroup{
    public String name{get; set;}
    public String id{get; set;}
    public String parentGroupName{get; set;}
    public String parentGroupId{get; set;}
    public Date startDate{get; set;}
    public Date endDate{get; set;}
    public String image{get; set;}
  }
  
  // Wrapper class to get Account and related promotions
  public class AccountWrapper{
    public String accountId{get; set;}
    public List<PromotionWrapper> promotions{get; set;}
  }
  
  // Wrapper class to get promotions
  public class PromotionWrapper{
    public String promotionName{get; set;}
    public String promotionId{get; set;}
    public Date startDate{set;get;}
    public Date endDate{set; get;}
    public String image{get; set;}
    public List<GroupWrapper> productGroups{get; set;}
  }
  
  // Wrapper class to get product group with products
  public class ProductGroupWrapper{
    public String name{set; get;}
    public String parentGroup{get; set;}
    public String parentGroupId{get; set;}
    public List<ProductsWrapper> listProducts{get; set;}
  }
  
  // Wrapper class to get product
  public class ProductsWrapper{
    public String priceBookEntryId {get; set;}
        public String name {get; set;}
        public String isActive {get; set;}
        public String product2Id {get; set;}
        public String productCode {get; set;}
        public String unitPrice {get; set;}
        public String useStandardPrice {get; set;}
        public String priceBook2Id {get; set;}
        public String can{get; set;}
        public ProductsWrapper(PricebookEntry myPriceBookentry) {

            this.priceBookEntryId = myPriceBookentry.Id;
            this.name = myPriceBookentry.Name;
            this.isActive = String.valueOf(myPriceBookentry.IsActive);
            this.product2Id = myPriceBookentry.Product2Id;
            this.productCode = myPriceBookentry.ProductCode;
            this.unitPrice = String.valueOf(myPriceBookentry.UnitPrice);
            this.useStandardPrice = String.valueOf(myPriceBookentry.UseStandardPrice);
            this.priceBook2Id = myPriceBookentry.Pricebook2Id;
            this.can = String.valueof(myPriceBookentry.Can__c);
        }
  }
}