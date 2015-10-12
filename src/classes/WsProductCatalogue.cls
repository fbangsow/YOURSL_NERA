/*
@Company:Your SL
@Author:Parasuram
@Creation date:03/08/2015
Reference: Ticket no 766
*/

@RestResource(urlMapping = '/ProductCatalogues/*')
global class WsProductCatalogue implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
        //create Request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        if(myRequest.resquestedByUser != null){
        	List<Account> listAccounts = getAccounts(myRequest.resquestedByUser);
        	Map<Id,Set<Id>> mapAccountPriceBookIds = getAccountPricebookIds(listAccounts);
        	Map<Id,List<PriceBookEntry>> mapPriceBookIdPriceBookEntries = getPricebookIdProducts(mapAccountPriceBookIds);
    		Map<Id,Pricebook2> mapPricebooks = getPricebooks(mapAccountPriceBookIds);
    		Map<Id,PriceBookEntry> mapPriceBookEntries = getPriceBookEntries(mapAccountPriceBookIds);
        	Map<Id,Map<String,groupWrapper>> mapProductIdGroups = getProductIdGroups(mapPriceBookEntries);
        	List<AccountProductsWrapper> dataSet = getAccountProducts(listAccounts,mapAccountPriceBookIds,
    																mapPriceBookIdPriceBookEntries,
    																mapPriceBookEntries,mapProductIdGroups,
    																mapPricebooks);

        	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(dataSet));
        	RestContext.response.addHeader('size', String.valueOf(dataSet.Size()));
    	}
    	else{
    		RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
      		RestContext.response.statusCode = myRequest.statusCode;
    	}        
        RestContext.response.addHeader('Content-Type', 'application/json');
    }

    // All accounts based on user
    public static List<Account> getAccounts(User user) {
    	return  [SELECT Id 
             	FROM Account 
             	WHERE Ownerid =: user.Id];
    }

    // Account with pricebook ids
    public static Map<Id,Set<Id>> getAccountPricebookIds(List<Account> accounts){
    	List<AccountPriceBookMember__c> listAccountPricebookMembers = [SELECT Id,AccountId__c,EndDate__c,
    																		PriceBookId__c,StartDate__c 
																		FROM AccountPriceBookMember__c 
																		WHERE AccountId__c IN: accounts];
		Map<Id,Set<Id>> mapAccountPricebookIds = new Map<Id,Set<Id>>();
		for(AccountPriceBookMember__c member : listAccountPricebookMembers){
			Set<id> setPbIds = new Set<Id>();
			if(mapAccountPricebookIds.containskey(member.AccountId__c)){
				setPbIds = mapAccountPricebookIds.get(member.AccountId__c);
				setPbIds.add(member.PriceBookId__c);
				mapAccountPricebookIds.put(member.AccountId__c,setPbIds);
			}
			else{
				setPbIds.add(member.PriceBookId__c);
				mapAccountPricebookIds.put(member.AccountId__c,setPbIds);	
			}
		}
    	return mapAccountPricebookIds;
    }

    // return pricebook related products
    public static Map<Id,List<PriceBookEntry>> getPricebookIdProducts(Map<Id,Set<Id>> accountPricebooks){
        Set<Id> setPricebookIds = new Set<Id>();
    	for(Id idval : accountPricebooks.keyset()){
    		setPricebookIds.addAll(accountPricebooks.get(idval));
    	}

    	List<Pricebook2> listPricebook =[SELECT Id,Name,
    										(SELECT Id, Name,
	                                            IsActive,Product2Id,
	                                            ProductCode,UnitPrice,
	                                            UseStandardPrice,Pricebook2.Name,
	                                            Pricebook2Id,Can__c,Product2.Image__c   
                                        	FROM PricebookEntries 
                                        	WHERE IsActive = true)
    									FROM Pricebook2 
    									WHERE Id IN: setPricebookIds];

		Map<Id,List<PricebookEntry>> mapPricebookIdProducts = new Map<Id,List<PricebookEntry>>();
		for(Pricebook2 pricebook : listPricebook){
			mapPricebookIdProducts.put(pricebook.Id,pricebook.PricebookEntries);
		}
    	return mapPricebookIdProducts;
    }

    // return Account pricebooks
    public static Map<Id,Pricebook2> getPricebooks(Map<Id,Set<Id>> accountPricebooks){
        Set<Id> setPricebookIds = new Set<Id>();
    	for(Id idval : accountPricebooks.keyset()){
    		setPricebookIds.addAll(accountPricebooks.get(idval));
    	}

    	Map<Id,Pricebook2> mapPricebooks = new Map<Id,Pricebook2>([SELECT Id,Name,IsActive 
    																FROM Pricebook2 
    																WHERE Id IN: setPricebookIds]);
    	return mapPricebooks;
    }

    // Based on pricebooks return all price Book Entries
  public static Map<Id,PriceBookEntry> getPriceBookEntries(Map<Id,Set<Id>> accountPricebooks){
    Set<Id> setPricebookIds = new Set<Id>();
    	for(Id idval : accountPricebooks.keySet()){
    		setPricebookIds.addAll(accountPricebooks.get(idval));
    	}

    Map<Id, PricebookEntry> mapPriceBookEntry = new Map<Id, PricebookEntry>([SELECT Id, Name,
                                            IsActive,Product2Id,
                                            ProductCode,UnitPrice,
                                            UseStandardPrice,Pricebook2.Name,
                                            Pricebook2Id,Can__c,Product2.Image__c   
                                        FROM PricebookEntry 
                                        WHERE Pricebook2Id IN: setPricebookIds]);
    return mapPriceBookEntry;
  }

      // To get product with related product groups
  public static Map<Id,Map<String,groupWrapper>> getProductIdGroups(Map<Id, PricebookEntry> priceBookEntries){
    Map<Id,Map<String,groupWrapper>> mapProductAndProductGroups = new Map<Id,Map<String,groupWrapper>>();
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
      Map<String,groupWrapper> mapProductGroup = new Map<String,groupWrapper>();
      if(mapProductAndProductGroups.containskey(member.Product2Id__c)){
        mapProductGroup = mapProductAndProductGroups.get(member.Product2Id__c);
        groupWrapper wrapGroup = new groupWrapper();
        wrapGroup.name = member.ProductGroup__r.Name;
        wrapGroup.id = member.ProductGroup__c;
        wrapGroup.image = member.ProductGroup__r.Image__c;
        wrapGroup.parentGroupName = member.ProductGroup__r.ParentGroup__r.Name;
        wrapGroup.parentGroupId = member.ProductGroup__r.ParentGroup__c;
        wrapGroup.startDate = member.ProductGroup__r.StartDate__c;
        wrapGroup.endDate = member.ProductGroup__r.EndDate__c;
        mapProductGroup.put(wrapGroup.id,wrapGroup);
        mapProductAndProductGroups.put(member.Product2Id__c,mapProductGroup);
      }
      else{
        groupWrapper wrapGroup = new groupWrapper();
        wrapGroup.name = member.ProductGroup__r.Name;
        wrapGroup.id = member.ProductGroup__c;
        wrapGroup.image = member.ProductGroup__r.Image__c;
        wrapGroup.parentGroupName = member.ProductGroup__r.ParentGroup__r.Name;
        wrapGroup.parentGroupId = member.ProductGroup__r.ParentGroup__c;
        wrapGroup.startDate = member.ProductGroup__r.StartDate__c;
        wrapGroup.endDate = member.ProductGroup__r.EndDate__c;
        mapProductGroup.put(wrapGroup.id,wrapGroup);
        mapProductAndProductGroups.put(member.Product2Id__c,mapProductGroup);
      }
    }
    return mapProductAndProductGroups;
  }

  	// list of data set based on Account with related products
	public static List<AccountProductsWrapper> getAccountProducts(List<Account> lstAccounts,
																Map<Id,Set<Id>> acountPriceBookIds,
																Map<Id,List<PriceBookEntry>> priceBookIdPriceBookEntries,
																Map<Id,PriceBookEntry> priceBookEntries,
																Map<Id,Map<String,groupWrapper>> productIdGroups,
																Map<Id,Pricebook2> pricebooks){
		

        List<AccountProductsWrapper> listAccountProducts = new List<AccountProductsWrapper>();
		
		for(Account acc : lstAccounts){
			AccountProductsWrapper accountWrapper = new AccountProductsWrapper();
			accountWrapper.accountId = acc.id;
			accountWrapper.productCatalogues = new  List<productCatalogue>();
			
			Set<Id> setPbIds = acountPriceBookIds.get(acc.id);
			//Map<String,pricebookWrapper> mapPricebooks = new Map<String,pricebookWrapper>();

			if(setPbIds != null)
			for(Id idval : setPbIds){
				productCatalogue pbwrap = new productCatalogue();
				pbwrap.priceBookId = idval;
				pbwrap.name = pricebooks.get(idval).Name;
				pbwrap.isActive = String.valueOf(pricebooks.get(idval).IsActive);
				pbwrap.accountId = acc.id;
				pbwrap.productGroups = new List<productGroup>();

				Map<String,productGroup> mapGroups = new Map<String,productGroup>();

				for(PricebookEntry entry : priceBookIdPriceBookEntries.get(idval)){
					ProductsWrapper product = new ProductsWrapper(entry);
					if(productIdGroups.containskey(entry.Product2Id) && productIdGroups.get(entry.Product2Id) != null){
						Map<String,groupWrapper> mapPrGroup = productIdGroups.get(entry.Product2Id);
						for(String groupStr : mapPrGroup.keyset()){
							if(mapGroups.containsKey(groupStr)){
								productGroup groupWrap = mapGroups.get(groupStr);
								groupWrap.products.add(product);
								mapGroups.put(groupWrap.productGroupid,groupWrap);
							}
							else{
								productGroup groupWrap = new productGroup();
								groupWrap.productGroupid = mapPrGroup.get(groupStr).id;
					            groupWrap.name = mapPrGroup.get(groupStr).name;
					            groupWrap.image = mapPrGroup.get(groupStr).image;
					            groupWrap.parentGroupName = mapPrGroup.get(groupStr).parentGroupName;
					            groupWrap.parentGroupId = mapPrGroup.get(groupStr).parentGroupId;
					            groupWrap.startDate = mapPrGroup.get(groupStr).startDate;
					            groupWrap.enddate = mapPrGroup.get(groupStr).endDate;
					            groupWrap.catalogueName = pbwrap.name;
					            groupWrap.products = new List<ProductsWrapper>();
					            groupWrap.products.add(product);
					            mapGroups.put(groupWrap.productGroupid,groupWrap);
				            }				            
						}
					}
					else{
						if(mapGroups.containsKey('')){
							productGroup groupWrap = mapGroups.get('');
							groupWrap.products.add(product);
							mapGroups.put(groupWrap.productGroupid,groupWrap);
						}
						else{
							productGroup groupWrap = new productGroup();
							groupWrap.productGroupid = '';
				            groupWrap.name = 'Other Group';
				            groupWrap.image = null;
				            groupWrap.parentGroupName = null;
				            groupWrap.parentGroupId = null;
				            groupWrap.startDate = null;
				            groupWrap.enddate = null;
				            groupWrap.catalogueName = pbwrap.name;
				            groupWrap.products = new List<ProductsWrapper>();
				            groupWrap.products.add(product);
				            mapGroups.put(groupWrap.productGroupid,groupWrap);
			        	}
					}
				}
				pbwrap.productGroups = mapGroups.values();
				accountWrapper.productCatalogues.add(pbwrap);
			}

			listAccountProducts.add(accountWrapper);
		}
		return listAccountProducts;
	}

  	
	// Wrapper class for Account products
    public class AccountProductsWrapper{
    	public String accountId{get; set;}
    	public List<productCatalogue> productCatalogues{get;set;}
    }

    // wrapper class for pricebooks
    public class productCatalogue{
		public String name{get;set;}
		public String priceBookId{get;set;}
		public String isActive{get; set;}
		public String accountId{get; set;}
		public List<productGroup> productGroups{get;set;}
	}

	// Wrapper class for Product group
    public class productGroup{
		public String name{get; set;}
		public String productGroupid{get; set;}
		public String image{get;set;}
		public String parentGroupName{get; set;}
		public String parentGroupId{get; set;}
		public Date startDate{get; set;}
		public Date endDate{get; set;}
		public String catalogueName{get; set;}
		public List<ProductsWrapper> products{get; set;}
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
        public String image{get;set;}
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
            this.image = myPriceBookentry.Product2.Image__c;
        }
  }

  // Wrapper class to get product group
	public class groupWrapper{
		public String name{get; set;}
		public String id{get; set;}
		public String image{get; set;}
		public String parentGroupName{get; set;}
		public String parentGroupId{get; set;}
		public Date startDate{get; set;}
		public Date endDate{get; set;}
	}


}