/*
@Company:Your SL
@Author:Pavan
@Creation date:26/6/2015
@Reference: Ticket no 438
*/
@RestResource(urlMapping = '/Promotions/*')

global class WsPromotions implements UcbWs {

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
				return;
			}

			List<AccountPromotionsWrapper> accountPromotionsList;
			listAccounts = getAccountsFromRequest(strAccounts);
			if(!listAccounts.isEmpty()) 
			{
					accountPromotionsList = new List<AccountPromotionsWrapper>();
					List<OrganizationWrapper> listOrganizations = getOrganizationsForAccounts(listAccounts);
					List<OrganizationPromotionsWrapper> listOrganizationPromotions = getOrganizationPromotions(listOrganizations);
					List<AccountDirectPromotionsWrapper> listAccountsPromotions = getAccountsPromotions(listAccounts);
					List<PromotionWrapper> listPromotions;
					Set<Id> setPromotionIds;
					for(Account account : listAccounts)
					{
						AccountPromotionsWrapper accountPromotionsWrapper = new AccountPromotionsWrapper();
						accountPromotionsWrapper.AccountId = account.Id;
						listPromotions = new List<PromotionWrapper>();
						setPromotionIds = new Set<Id>();

						//Getting promotions of account based on organization it belongs
						for(OrganizationWrapper organization : listOrganizations)
						{
							if(organization.AccountId == account.Id)
							{
								for(OrganizationPromotionsWrapper orgPromotions : listOrganizationPromotions)
								{
									if(orgPromotions.OrganizationId == organization.OrganizationId)
									{
									    setPromotionIds.add(orgPromotions.PromotionId);
									}
								}
							}
						}
						
						//Getting promotions of account, Which are directly defined on accounts
						for(AccountDirectPromotionsWrapper accountDirectPromotion : listAccountsPromotions)
						{
							if(accountDirectPromotion.AccountId == account.Id)
							{
								setPromotionIds.add(accountDirectPromotion.PromotionId);				
							}
						}

						for(Id promotionId : setPromotionIds)
						{
							PromotionWrapper promotion = getPromotion(promotionId);
							listPromotions.add(promotion);	
						}

						accountPromotionsWrapper.Promotions = listPromotions;
						accountPromotionsList.add(accountPromotionsWrapper);
					}	

					RestContext.response.responseBody = Blob.valueOf(JSON.serialize(accountPromotionsList));
				    RestContext.response.addHeader('size', String.valueOf(accountPromotionsList.Size()));
		        }  
		        else  //Accounts List is Empty
		        {
					RestContext.response.addHeader('size', '0');
			    }

				RestContext.response.statusCode = 200;
		} 
		else //Requested By User is NULL
		{
			RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
			RestContext.response.statusCode = myRequest.statusCode;
		}
		RestContext.response.addHeader('Content-Type', 'application/json');
	}
			
	public static List<Account> getAccountsFromRequest(String accountIDs) {

		List<Account> lstAccounts = new List<Account>();
		List<Id> lLstAccountIDs = (List<Id>) JSON.deserialize(accountIDs, List<Id>.class);
		return  [SELECT Id 
		         FROM Account 
		         WHERE Id IN: lLstAccountIDs];
		
	}

	public static List<OrganizationWrapper> getOrganizationsForAccounts(List<Account> lstAccounts) {

		List<OrganizationWrapper> listOrganizations = new List<OrganizationWrapper>();
		List<OrganizationAccountMember__c> listOrgAccounts = [SELECT Account__c,Organization__c
													          FROM OrganizationAccountMember__c 
													          WHERE Account__c IN: lstAccounts];
		for(OrganizationAccountMember__c member : listOrgAccounts )
		{
			OrganizationWrapper organization = new OrganizationWrapper();
			organization.OrganizationId = member.Organization__c;
			organization.AccountId = member.Account__c;
			listOrganizations.add(organization);
		}	
		return listOrganizations;
	}

	public static List<OrganizationPromotionsWrapper> getOrganizationPromotions(List<OrganizationWrapper> listOrganizations) {
		Set<Id> setOrganizations = new Set<Id>();
		for(OrganizationWrapper org : listOrganizations)
		{
			setOrganizations.add(org.OrganizationId);
		}

		List<OrganizationPromotionsWrapper> listOrganizationPromotions = new List<OrganizationPromotionsWrapper>();
		List<OrganizationPromotionMember__c> listOrgPromotions = [SELECT Organization__c,Promotion__c
		                                                          FROM OrganizationPromotionMember__c 
		                                                          WHERE Organization__c IN: setOrganizations];

		for(OrganizationPromotionMember__c member : listOrgPromotions )
		{
			OrganizationPromotionsWrapper organizationPromotion = new OrganizationPromotionsWrapper();
			organizationPromotion.OrganizationId = member.Organization__c;
			organizationPromotion.PromotionId = member.Promotion__c;
			listOrganizationPromotions.add(organizationPromotion);
		}		
		return listOrganizationPromotions;
	}

	public static List<AccountDirectPromotionsWrapper> getAccountsPromotions(List<Account> lstAccounts) {

		List<AccountDirectPromotionsWrapper> listAccountsPromotions = new List<AccountDirectPromotionsWrapper>();
		List<AccountPromotionMember__c> listAccountsPromotionsMember = [SELECT Account__c,Promotion__c
		                                                                FROM AccountPromotionMember__c 
		                                                                WHERE Account__c IN: lstAccounts];

		for(AccountPromotionMember__c member : listAccountsPromotionsMember)
		{
			AccountDirectPromotionsWrapper accountsPromotions = new AccountDirectPromotionsWrapper();
			accountsPromotions.AccountId = member.Account__c;
			accountsPromotions.PromotionId = member.Promotion__c;
			listAccountsPromotions.add(accountsPromotions);
		}		
		return listAccountsPromotions;
	}

	public static PromotionWrapper getPromotion(String strPromotionId) {
		Promotion__c promotionMember = [SELECT Id, Name,StartDate__c,EndDate__c
		                                FROM Promotion__c 
		                                WHERE Id =: strPromotionId];
		         
		PromotionWrapper promotion = new PromotionWrapper();
		promotion.PromotionId = promotionMember.Id;
		promotion.PromotionName = promotionMember.Name;
		promotion.StartDate = promotionMember.StartDate__c;
		promotion.EndDate = promotionMember.EndDate__c;
		return promotion;
	}

	public class AccountPromotionsWrapper {
		public Id accountId {get; set;}
		public List<PromotionWrapper> promotions {get; set;}
	}

	public class OrganizationWrapper {
		public Id organizationId {get; set;}
		public Id accountId {get; set;}				
	}

	public class OrganizationPromotionsWrapper {
		public Id organizationId {get; set;}	
		public Id promotionId	{get; set;}		
	}

	public class AccountDirectPromotionsWrapper {

		public Id accountId {get; set;}
		public Id promotionId {get; set;}
	}

	public class PromotionWrapper {
		public Id promotionId {get; set;}		
		public String promotionName {get; set;}	
		public Date startDate {get; set;}
		public Date endDate {get; set;}
	}

}