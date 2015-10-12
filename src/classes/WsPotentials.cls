/*
@Company:Your SL
@Author:Parasuram
@Creation date:23/7/2015
@Reference: Ticket no 1027
*/
@RestResource(urlMapping = '/Potentials/*')
global class WsPotentials implements UcbWs{

	public static UcbWsResponse doReply(UcbWsRequest request) {
		return new UcbWsResponse();
	}

	static List<Account> listAccounts;

	@HttpGet
	global static void wsGet() {
		//create request
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		String strAccounts = '';
		Map<Id,PotentialPriceBookMember> mapPotentialPriceBook;
		List<PotentialProductsWrapper> listDataSet;

		strAccounts = RestContext.request.params.get('accounts');
		System.debug('@@@In Get : accountIds Json From Request Param is' + strAccounts);

		if(String.isEmpty(strAccounts))
		{
			Map<Id,Potential__c> mapTalons = getAllPotentials();
			mapPotentialPriceBook = getPotentialPriceBookEntries(mapTalons.keyset());

		}
		else
		{
			listAccounts = WsPromotions.getAccountsFromRequest(strAccounts);
			Set<Id> setPotentials = getPotentials(listAccounts);
			mapPotentialPriceBook = getPotentialPriceBookEntries(setPotentials);							
		}

		try{
			listDataSet = getDataset(mapPotentialPriceBook);
			System.debug('listDataSet-------------'+listDataSet.Size());
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listDataSet));
			RestContext.response.addHeader('size', String.valueOf(listDataSet.Size()));
		}
		catch(Exception ex){
			RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
			RestContext.response.statusCode = myRequest.statusCode;
		}
		RestContext.response.addHeader('Content-Type', 'application/json');
	}

	// All Potentials
	public static Map<Id,Potential__c> getAllPotentials(){
		Map<Id,Potential__c> mapAllPotentials = new Map<Id,Potential__c>([SELECT Id,Name FROM Potential__c]);
		return mapAllPotentials;
	}

	// All Potentials for the accounts
	public static Set<Id> getPotentials(List<Account> accounts){
		Set<Id> setPotentials = new Set<Id>();
		List<AccountPotentialMember__c> listAccountPotentialMembers = [SELECT Potential__c, Account__c 
																FROM AccountPotentialMember__c															
																WHERE Account__c IN: accounts];
		for(AccountPotentialMember__c member : listAccountPotentialMembers){
			setPotentials.add(member.Potential__c);
		}
		return setPotentials;
	}

	// Return Potentials with priceBookEntryMembers
	public static Map<Id,PotentialPriceBookMember> getPotentialPriceBookEntries(Set<Id> potentials){
		List<Potential__c> listPotentials = [SELECT Id,Name,
										(SELECT PriceBookEntryId__c 
										FROM PotentialPriceBookMembers__r) 
									FROM Potential__c where Id IN: potentials];

		Map<Id,PotentialPriceBookMember> mapPotentialPriceBookEntries = new Map<Id,PotentialPriceBookMember>();
		
		for(Potential__c potential : listPotentials){
			PotentialPriceBookMember potentialmember = new PotentialPriceBookMember();
			potentialmember.potentialId = potential.Id;
			potentialmember.potentialName = potential.Name;
			potentialmember.setPriceBookEntryIds = new Set<String>();
			for(PotentialPriceBookMember__c member : potential.PotentialPriceBookMembers__r){
				potentialmember.setPriceBookEntryIds.add(member.PriceBookEntryId__c);
			}
			mapPotentialPriceBookEntries.put(potential.Id,potentialmember);
		}
		return mapPotentialPriceBookEntries;
	}

	// Potential with products
	public static List<PotentialProductsWrapper> getDataset(Map<Id,PotentialPriceBookMember> mapPotentialMembers){
		List<PotentialProductsWrapper> listPotentialProducts = new List<PotentialProductsWrapper>();
		Set<String> setPriceBookEntries = new Set<String>();
		for(PotentialPriceBookMember myMember : mapPotentialMembers.values()){
			for(String str : myMember.setPriceBookEntryIds){
				setPriceBookEntries.add(str);
			}
		}
		
		Map<Id, PricebookEntry> mapPriceBookEntry = new Map<Id, PricebookEntry>([SELECT Id, Name,
																						IsActive,Product2Id,
																						ProductCode,UnitPrice, 
																						UseStandardPrice,
																						Pricebook2Id 
																				FROM PricebookEntry 
																				WHERE Id IN: setPriceBookEntries]);

		for(PotentialPriceBookMember potentialMember : mapPotentialMembers.values()){
			PotentialProductsWrapper potentialProducts = new PotentialProductsWrapper();
			potentialProducts.potentialId = potentialMember.potentialId;
			potentialProducts.potentialName = potentialMember.potentialName;
			potentialProducts.products = new List<ProductsWrapper>();
			for(String EntryId : potentialMember.setPriceBookEntryIds){
				ProductsWrapper product = new ProductsWrapper(mapPriceBookEntry.get(EntryId));
				potentialProducts.products.add(product);				
			}
			listPotentialProducts.add(potentialProducts);
		}
		return listPotentialProducts;
	}

	// wrapper class
	public class PotentialPriceBookMember{
		public Id potentialId {get; set;}
		public String potentialName {get; set;}
		public Set<String> setPriceBookEntryIds {get; set;}
	}

	public class PotentialProductsWrapper{
		public Id potentialId {get; set;}
		public String potentialName {get; set;}
		public List<ProductsWrapper> products {get; set;}
	}

	public class ProductsWrapper{
		public String priceBookEntryId {get; set;}
        public String name {get; set;}
        public String isActive {get; set;}
        public String product2Id {get; set;}
        public String productCode {get; set;}
        public String unitPrice {get; set;}
        public String useStandardPrice {get; set;}
        public String priceBook2Id {get; set;}
        //public String image {get; set;}
        public ProductsWrapper(PricebookEntry myPriceBookentry) {

            this.priceBookEntryId = myPriceBookentry.Id;
            this.name = myPriceBookentry.Name;
            this.isActive = String.valueOf(myPriceBookentry.IsActive);
            this.product2Id = myPriceBookentry.Product2Id;
            //this.image = getProductImage(myPriceBookentry.Product2Id);
            this.productCode = myPriceBookentry.ProductCode;
            this.unitPrice = String.valueOf(myPriceBookentry.UnitPrice);
            this.useStandardPrice = String.valueOf(myPriceBookentry.UseStandardPrice);
            this.priceBook2Id = myPriceBookentry.Pricebook2Id;
        }
	}

}