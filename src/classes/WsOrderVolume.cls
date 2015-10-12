/**
 * Created by Sreenath Guduru for Order Volume Data retrieval
 */
@RestResource(urlMapping = '/OrderVolume/*')
global class WsOrderVolume implements UcbWs {

	public static string debugVar {get; set;}
	public enum OrderVolumerCategory {DAILY, WEEKLY, MONTHLY}

	static OrderVolumerCategory currentCategory = OrderVolumerCategory.MONTHLY;

	public static UcbWsResponse doReply(UcbWsRequest request) {
		return new UcbWsResponse();
	}

	/**
	 * Created by Sreenath Guduru
	 * [wsGet - Retrieves Order Volume based on Day/Week/Month]
	 * @return [description]
	 */
	@HttpGet
	global static void wsGet() {

		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);

		if(myRequest.resquestedByUser != null) {

			string category = RestContext.request.params.get('category');
			string account = RestContext.request.params.get('account');

			WsOrderVolume.setCurrentOrderVolCategory(category);

			List<myOrderVolumeResult> mapVolumes = WsOrderVolume.getOrderVolumes(account);

			if(!mapVolumes.isEmpty()) {
				RestContext.response.responseBody = Blob.valueOf(JSON.serialize(mapVolumes));
			} else {
				RestContext.response.addHeader('size', '0');
			}

		} else {

			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
			RestContext.response.statusCode = myRequest.statusCode;

		}

	}
	/**
	 * Created by Sreenath Guduru
	 * This method is to set Order volume category based on User request
	 * @param Category [description]
	 */
	public static void setCurrentOrderVolCategory(string Category) {
		if(!string.isEmpty(Category)) {
			if(Category == 'M')
				currentCategory = OrderVolumerCategory.MONTHLY;
			else if(Category == 'W')
				currentCategory = OrderVolumerCategory.WEEKLY;
			if(Category == 'D')
				currentCategory = OrderVolumerCategory.DAILY;

		}
	}

	public static List<myOrderVolumeResult> getOrderVolumes(string account) {

		Map<ID, List<myOrderVolume>> mapLstVolumes = new Map<ID, List<myOrderVolume>> ();
		List<myOrderVolumeResult> lstVolumeResult = new List<myOrderVolumeResult>();

		//List<OrderMonthlyVolume__c> lstOrderMnthlyValues = [select id, name, account__C, year__c, month__C, ordevolumetype__C, volume__C from OrderMonthlyVolume__c  where account__C = :account];
		List<OrderMonthlyVolume__c> lstOrderMnthlyValues = [SELECT id, name, account__C, year__c, month__C, volume__C 
															FROM OrderMonthlyVolume__c  
															WHERE account__C in :getAccountsFromRequest(account)];

		for(OrderMonthlyVolume__c sObj : lstOrderMnthlyValues) {

			List<myOrderVolume> lstVolumes = new List<myOrderVolume>();
			myOrderVolume item = new   myOrderVolume();

			item.Category = string.valueOf(currentCategory);
			item.Month = string.valueOf(sObj.month__C);
			item.Year = string.valueOf(sObj.year__c);
			item.Volume = string.valueOf(sObj.volume__C);
			item.OrderVolumeType = 'HL'; //string.valueOf(sobj.ordevolumetype__C);

			if(mapLstVolumes.containsKey(sobj.account__C)) {
				lstVolumes = mapLstVolumes.get(sObj.account__C);
				lstVolumes.add(item);
				mapLstVolumes.put(sObj.account__C, lstVolumes);
			} else {
				lstVolumes.add(item);
				mapLstVolumes.put(sObj.account__C, lstVolumes);
			}
		}

		for(ID accountiditr : mapLstVolumes.keySet()) {
			myOrderVolumeResult obj = new myOrderVolumeResult();
			obj.AccountID = accountiditr;
			obj.ordermonthlyvolume = mapLstVolumes.get(accountiditr);

			lstVolumeResult.add(obj);
		}

		return lstVolumeResult;
	}

	public static List<Account> getAccountsFromRequest(string accountIDs) {

		List<Account> lstAccounts = new List<Account>();		
		List<Id> lLstAccountIDs = (List<Id>) JSON.deserialize(accountIDs, List<Id>.class);
		return  [SELECT Id 
		         FROM Account 
                 WHERE Id in: lLstAccountIDs];
		
	}

	public class myOrderVolumeResult {

		public ID AccountID {get; set;}
		public List<myOrderVolume> ordermonthlyvolume {get; set;}
	}

	/**
	 * Created by Sreenath Guduru
	 * This Class is for request and response hand shaking between Service and User interface
	 */
	public class myOrderVolume {

		public String category {get; set;} // This property is to quote whether details are for Daily/Weekly/Monthly
		public String orderVolumeType {get; set;}
		public String year {get; set;}
		public String month {get; set;}
		public String volume {get; set;}

	}

}