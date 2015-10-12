/*
@Company        :Your SL
@Author         :Imran
@Creation date  :12/08/2015
@Reference      :
*/
@isTest(SeeAllData=true)
global class TestWsProductCatalogue {
	static testMethod void testWsProductCatalogue() {
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User u = new User(Alias = 'jyothi', Email = 'jyothi.m@neradeveloprttment.org', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id,
				TimeZoneSidKey = 'America/Los_Angeles', UserName = 'jyothi.m@neradeveloprrrent.org');
		Insert u;
		
		System.runAs(u){
			Test.startTest();
				List<Account> listAccount = new List<Account>();
					listAccount.add(new Account(Name='Imran'));
					listAccount.add(new Account(Name='Test'));
				Insert listAccount;

				//This standard price book  used beacuse we cant insert standard price book with Istandard field
				List<PriceBook2> listPriceBook2 = [SELECT id,Name FROM PriceBook2 WHERE IsStandard = true limit 2];
				System.debug('listPriceBook2---------------'+listPriceBook2);

				List<AccountPriceBookMember__c> listAccountPriceBookMember = new List<AccountPriceBookMember__c>();
					listAccountPriceBookMember.add(new AccountPriceBookMember__c(AccountId__c=listAccount[0].Id,EndDate__c=System.Today()+1,PriceBookId__c=listPriceBook2[0].Id,StartDate__c=System.Today()));
	                listAccountPriceBookMember.add(new AccountPriceBookMember__c(AccountId__c=listAccount[1].Id,EndDate__c=System.Today()+1,PriceBookId__c=listPriceBook2[0].Id,StartDate__c=System.Today()));
				insert listAccountPriceBookMember;
				
				List <Product2> listProduct2s = new List <Product2>();
					listProduct2s.add(new Product2(Name='GenWatt Diesel 1000kW',ProductCode='GC1060',IsActive=true));
					listProduct2s.add(new Product2(Name='GenWatt Diesel 10kW',ProductCode='GC1020',IsActive=true));
				insert listProduct2s;

				List<PricebookEntry> listpriceBokkEntry = new List<PricebookEntry>();
					listpriceBokkEntry.add(new PricebookEntry(IsActive= true,Product2Id = listProduct2s[0].Id,UnitPrice=2770,UseStandardPrice=false,Pricebook2Id=listPriceBook2[0].Id));
					listpriceBokkEntry.add(new PricebookEntry(IsActive= true,Product2Id = listProduct2s[1].Id,UnitPrice=7340,UseStandardPrice=false,Pricebook2Id=listPriceBook2[0].Id));
				insert listpriceBokkEntry;

				
				List<ProductGroup__c> listProductGrouup = new List<ProductGroup__c>();
					listProductGrouup.add(new ProductGroup__c(Name='Indian Oil',EndDate__c=System.Today()+2,IsDefault__c=true,StartDate__c=System.Today()));
					listProductGrouup.add(new ProductGroup__c(Name='Hp',EndDate__c=System.Today()+2,IsDefault__c=true,StartDate__c=System.Today()));
				Insert listProductGrouup;

				List<ProductGroup__c> listProductGrouup1 = new List<ProductGroup__c>();
					listProductGrouup1.add(new ProductGroup__c(Name='Indian Oil',EndDate__c=System.Today()+2,IsDefault__c=true,ParentGroup__c=listProductGrouup[0].Id,StartDate__c=System.Today()));
					listProductGrouup1.add(new ProductGroup__c(Name='Hp',EndDate__c=System.Today()+2,IsDefault__c=true,ParentGroup__c=listProductGrouup[1].Id,StartDate__c=System.Today()));
				Insert listProductGrouup1;
				List<ProductGroupMember__c> listProductGroupMember = new List<ProductGroupMember__c>();
					listProductGroupMember.add(new ProductGroupMember__c(Product2Id__c=listProduct2s[0].Id,ProductGroup__c=listProductGrouup1[0].Id));
					listProductGroupMember.add(new ProductGroupMember__c(Product2Id__c=listProduct2s[1].Id,ProductGroup__c=listProductGrouup1[1].Id));
				insert listProductGroupMember;

			Test.stopTest();
			RestRequest req = new RestRequest();
				req.requestURI = 'https://eu5.salesforce.com/services/apexrest/ProductCatalogues';
				req.addParameter('userId',u.Id);
				req.httpMethod = 'GET';
			RestResponse res = new RestResponse();
			RestContext.request = req;
	    	RestContext.response = res;
	    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
	    	WsProductCatalogue.doReply(myRequest);
	    	WsProductCatalogue.wsGet();
	    	System.assertEquals(listAccount.size(),RestContext.response.headers.size());
	    	
    	}
	}

	//This method is usedd to cover catch block code

	static testMethod void testWsProductCatalogue1() {
		RestRequest req = new RestRequest();
			req.requestURI = 'https://eu5.salesforce.com/services/apexrest/ProductCatalogues';
			req.httpMethod = 'GET';
		RestResponse res = new RestResponse();
		RestContext.request = req;
    	RestContext.response = res;
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	WsProductCatalogue.doReply(myRequest);
    	WsProductCatalogue.wsGet();
    	System.assertEquals(400,RestContext.response.statusCode);
	}
}