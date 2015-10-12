/*
@Company        :Your SL
@Author         :Imran
@Creation date  :11/08/2015
@Reference      :
*/
@isTest
global class TestWsPotentials {
	
static testMethod void testWsPotentials() {
	Test.startTest();
		List<Account> listAccount = new List<Account>();
			listAccount.add(new Account(Name='Imran'));
			listAccount.add(new Account(Name='Test'));
		Insert listAccount;
		List<Id> listId = new List<Id>();
			listId.add(listAccount[0].Id);
			listId.add(listAccount[1].Id);

	List<Potential__c> listPotentials = new List<Potential__c>();
		listPotentials.add(new Potential__c(Name='testPotential1'));
		listPotentials.add(new Potential__c(Name='testPotential2'));
	insert listPotentials;

	Map<Id,Potential__c> potentialMap = new Map<Id,Potential__c>([SELECT Id,Name FROM Potential__c]);

	List<AccountPotentialMember__c> listAccountPotentialMember = new List<AccountPotentialMember__c>();
		listAccountPotentialMember.add(new AccountPotentialMember__c(Potential__c=listPotentials[0].Id,Account__c=listAccount[0].Id));
		listAccountPotentialMember.add(new AccountPotentialMember__c(Potential__c=listPotentials[1].Id,Account__c=listAccount[1].Id));
	insert listAccountPotentialMember;

    List<PriceBook2> listPriceBook = new List<PriceBook2>();
    	listPriceBook.add(new PriceBook2(Name='Standard Price Book',IsActive=false));
    	listPriceBook.add(new PriceBook2(Name='Standard',IsActive=false));
	insert listPriceBook;

	List <Product2> listProduct2s = new List <Product2>();
		listProduct2s.add(new Product2(Name='GenWatt Diesel 1000kW',ProductCode='GC1060',IsActive=true));
		listProduct2s.add(new Product2(Name='GenWatt Diesel 10kW',ProductCode='GC1020',IsActive=true));
	insert listProduct2s;

	List<PricebookEntry> listpriceBokkEntry = new List<PricebookEntry>();
		listpriceBokkEntry.add(new PricebookEntry(IsActive= true,Product2Id = listProduct2s[0].Id,UnitPrice=2770,UseStandardPrice=false,Pricebook2Id=Test.getStandardPricebookId()));
		listpriceBokkEntry.add(new PricebookEntry(IsActive= true,Product2Id = listProduct2s[1].Id,UnitPrice=7340,UseStandardPrice=false,Pricebook2Id=Test.getStandardPricebookId()));
	insert listpriceBokkEntry;

	List<PotentialPriceBookMember__c> listPotentialPriceBookMem = new List<PotentialPriceBookMember__c>();
		listPotentialPriceBookMem.add(new PotentialPriceBookMember__c(Name='testPriceBook',Potential__c=listPotentials[0].Id,PriceBookEntryId__c=listpriceBokkEntry[0].Id));
		listPotentialPriceBookMem.add(new PotentialPriceBookMember__c(Name='testPriceBook',Potential__c=listPotentials[1].Id,PriceBookEntryId__c=listpriceBokkEntry[1].Id));
	insert listPotentialPriceBookMem;

	Test.stopTest();

		RestRequest req = new RestRequest();
			req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Potentials';
			req.httpMethod = 'GET';
			req.addParameter('accounts',JSON.serialize(listId));
		RestResponse res = new RestResponse();
		RestContext.request = req;
    	RestContext.response = res;
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	WsPotentials.doReply(myRequest);
    	WsPotentials.wsGet();

		System.assertEquals(potentialMap,WsPotentials.getAllPotentials());
	}	
	static testMethod void testWsPotential1(){

		RestRequest req = new RestRequest();
			req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Potentials';
			req.httpMethod = 'GET';
			req.addParameter('accounts','');
		RestResponse res = new RestResponse();
		RestContext.request = req;
    	RestContext.response = res;
    	WsPotentials.wsGet();
	}
}