@isTest(SeeAllData=true)
global class TestWsPromotion {
	static testMethod void testWsPromotion() {
		Test.startTest();

			Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
			User u = new User(Alias = 'imran', Email = 'imran.s@neradeveloprttment.org', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id,
			TimeZoneSidKey = 'America/Los_Angeles', UserName = 'imran.s@neradeveloprrrent.org');
			Insert u;
			System.runAs(u){
				List<Account> listAccount = new List<Account>();
			        listAccount.add(new Account(Name='United Gas'));
			        listAccount.add(new Account(Name='Yoursl'));
		      	insert listAccount;

		      	List<Id> listAccountId = new List<Id>();
		      		listAccountId.add(listAccount[0].Id);
		      		listAccountId.add(listAccount[1].Id);

		      	List<Organization__c> listOrganization = new List<Organization__c>();
		      		listOrganization.add(new Organization__c(Name='HP'));
		      		listOrganization.add(new Organization__c(Name='HP'));
	      		Insert listOrganization;

		      	List<Organization__c> listOrganization1 = new List<Organization__c>();
	      			listOrganization1.add(new Organization__c(Name='HP',ParentOrganization__c=listOrganization[0].Id));
	      			listOrganization1.add(new Organization__c(Name='HP',ParentOrganization__c=listOrganization[1].Id));
      			Insert listOrganization1;

	      		List<OrganizationAccountMember__c> listOrganizationAccountMember = new List<OrganizationAccountMember__c>();
	      			listOrganizationAccountMember.add(new OrganizationAccountMember__c(Name='test',Account__c=listAccount[0].Id,Organization__c=listOrganization1[0].Id));
	      			listOrganizationAccountMember.add(new OrganizationAccountMember__c(Name='test',Account__c=listAccount[0].Id,Organization__c=listOrganization1[0].Id));
	      			listOrganizationAccountMember.add(new OrganizationAccountMember__c(Name='test',Account__c=listAccount[1].Id,Organization__c=listOrganization1[1].Id));
      			Insert listOrganizationAccountMember;

      			List<Promotion__c> listPromotion = new List<Promotion__c>();
      				listPromotion.add(new Promotion__c(Name='test',EndDate__c=System.Today()+2,StartDate__c=System.Today()));
      				listPromotion.add(new Promotion__c(Name='testPromotion',EndDate__c=System.Today()+2,StartDate__c=System.Today()));
  				Insert listPromotion;

  				List <Product2> listProduct2s = new List <Product2>();
					listProduct2s.add(new Product2(Name='GenWatt Diesel 1000kW',ProductCode='GC1060',IsActive=true));
					listProduct2s.add(new Product2(Name='GenWatt Diesel 10kW',ProductCode='GC1020',IsActive=true));
				insert listProduct2s;

  				List<PriceBook2> listPriceBook2 = [SELECT id,Name FROM PriceBook2 WHERE IsStandard = true limit 2];

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
					listProductGroupMember.add(new ProductGroupMember__c(Product2Id__c=listProduct2s[0].Id,ProductGroup__c=listProductGrouup1[0].Id));
					listProductGroupMember.add(new ProductGroupMember__c(Product2Id__c=listProduct2s[1].Id,ProductGroup__c=listProductGrouup1[1].Id));
					listProductGroupMember.add(new ProductGroupMember__c(Product2Id__c=listProduct2s[1].Id,ProductGroup__c=listProductGrouup1[1].Id));
				insert listProductGroupMember;

  				List<PromotionMember__c> listPromotionMember = new List<PromotionMember__c>();
  					listPromotionMember.add(new PromotionMember__c(Name='testPromotionMember',Promotion__c=listPromotion[0].Id,PriceBookEntryId__c=listpriceBokkEntry[0].Id));
  					listPromotionMember.add(new PromotionMember__c(Name='testPromotionMember',Promotion__c=listPromotion[0].Id,PriceBookEntryId__c=listpriceBokkEntry[0].Id));
  					listPromotionMember.add(new PromotionMember__c(Name='testPromotionMember2',Promotion__c=listPromotion[1].Id,PriceBookEntryId__c=listpriceBokkEntry[1].Id));

				Insert listPromotionMember;

      			List<OrganizationPromotionMember__c> listOrganizationPromotionMember = new List<OrganizationPromotionMember__c>();
      				listOrganizationPromotionMember.add(new OrganizationPromotionMember__c(Name='testOrganizationMember',Organization__c=listOrganization1[0].Id,Promotion__c=listPromotion[0].Id));
      				listOrganizationPromotionMember.add(new OrganizationPromotionMember__c(Name='testOrganizationMember',Organization__c=listOrganization1[0].Id,Promotion__c=listPromotion[0].Id));
      				listOrganizationPromotionMember.add(new OrganizationPromotionMember__c(Name='testOrganizationMember2',Organization__c=listOrganization1[1].Id,Promotion__c=listPromotion[1].Id));
		      	Insert listOrganizationPromotionMember;

		      	List<AccountPromotionMember__c> listAccountPromotionMember = new List<AccountPromotionMember__c>();
		      		listAccountPromotionMember.add(new AccountPromotionMember__c(Name='testAccountPromotion',Account__c=listAccount[0].Id,Promotion__c=listPromotion[0].Id));
		      		listAccountPromotionMember.add(new AccountPromotionMember__c(Name='testAccountPromotion',Account__c=listAccount[0].Id,Promotion__c=listPromotion[0].Id));
		      		listAccountPromotionMember.add(new AccountPromotionMember__c(Name='testAccountPromotion2',Account__c=listAccount[1].Id,Promotion__c=listPromotion[1].Id));
	      		Insert listAccountPromotionMember;

		      	RestRequest req = new RestRequest();
			        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Promotion';
			        req.addParameter('userId', u.Id);
			        req.addParameter('accounts', JSON.serialize(listAccountId));
			        req.httpMethod = 'GET';	        
			    RestResponse res = new RestResponse();
			    RestContext.request = req;
			    RestContext.response = res;
			    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
	    		WsPromotion.doReply(myRequest);
			    WsPromotion.wsGet();
			    System.assertEquals(listAccount.size(),RestContext.response.headers.size());
			}
      	Test.stopTest();
	}
	static testMethod void testWsPromotion1() {
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User u = new User(Alias = 'imran', Email = 'imran.s@neradeveloprttment.org', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id,
		TimeZoneSidKey = 'America/Los_Angeles', UserName = 'imran.s@neradeveloprrrent.org');
		Insert u;

		List<Account> listAccount = new List<Account>();
	        listAccount.add(new Account(Name='United Gas'));
	        listAccount.add(new Account(Name='Yoursl'));
      	insert listAccount;

		RestRequest req = new RestRequest();
	        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Promotion';
	        req.addParameter('userId', u.Id);
	        req.addParameter('accounts', '');
	        req.httpMethod = 'GET';	        
	    RestResponse res = new RestResponse();
	    RestContext.request = req;
	    RestContext.response = res;
	    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
	    WsPromotion.doReply(myRequest);
	    WsPromotion.wsGet();
	    System.assertNotEquals(listAccount.size(),RestContext.response.headers.size());
	}
	static testMethod void testWsPromotion2() {
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User u = new User(Alias = 'imran', Email = 'imran.s@neradeveloprttment.org', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id,
		TimeZoneSidKey = 'America/Los_Angeles', UserName = 'imran.s@neradeveloprrrent.org');
		Insert u;

		List<Organization__c> listOrganization = new List<Organization__c>();
      		listOrganization.add(new Organization__c(Name='HP'));
      		listOrganization.add(new Organization__c(Name='HP'));
  		Insert listOrganization;

  		List<Id> listAccountId = new List<Id>();
			listAccountId.add(listOrganization[0].Id);
			listAccountId.add(listOrganization[1].Id);

		RestRequest req = new RestRequest();
	        req.requestURI = 'https://eu5.salesforce.com/services/apexrest/Promotion';
	        req.addParameter('userId', u.Id);
	        req.addParameter('accounts', JSON.serialize(listAccountId));
	        req.httpMethod = 'GET';	        
	    RestResponse res = new RestResponse();
	    RestContext.request = req;
	    RestContext.response = res;
	    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
	    WsPromotion.doReply(myRequest);
	    WsPromotion.wsGet();

	     RestRequest req1 = new RestRequest();
	        req1.requestURI = 'https://eu5.salesforce.com/services/apexrest/Promotion';
	        req1.addParameter('userId', '');
	        //req.addParameter('accounts', JSON.serialize(listAccountId));
	        req1.httpMethod = 'GET';	        
	    RestResponse res1 = new RestResponse();
	    RestContext.request = req1;
	    RestContext.response = res1;
	    UcbWsRequest myRequest1 = new UcbWsRequest(RestContext.request);
	    WsPromotion.wsGet();
	    System.assertEquals(400,RestContext.response.statusCode);
	}
}