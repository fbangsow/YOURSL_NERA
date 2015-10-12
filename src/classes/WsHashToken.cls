/*
@Company:Your SL
@Author:Jyothi 
@Creation date:06/08/2015
Reference:
*/
@RestResource(urlMapping = '/HashToken/*')
global class WsHashToken implements UcbWs {

	public static UcbWsResponse doReply(UcbWsRequest request) {
		return new UcbWsResponse();
	}

	@HttpGet
	global static void wsGet() {
		//create Request
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);	

		RestContext.response.responseBody = Blob.valueOf(JSON.serialize(getDataset1(myRequest.tokenType)));
		//RestContext.response.addHeader('size', String.valueOf(dataset.Size()));
		RestContext.response.addHeader('Content-Type', 'application/json');
	}

	public static HashKey getDataset1(String tokenType){
		HashKey hs = new HashKey();
			hs.HashKey = getDataset(tokenType); 
		return hs ;
	}
	
	public class HashKey{
		public List<HashKey1> HashKey;
	}
	public static List<HashKey1> getDataset(String tokenType) {
		List<HashKey1> hasKeyList = new List<HashKey1>();
		List<HashKey__c> listHasKey = new List<HashKey__c>();
		if(tokenType == 'all'){
			listHasKey = [SELECT Id, Name,key__c, value__c FROM HashKey__c];
		}else if(tokenType == 'dataToken'){
			listHasKey = [SELECT Id, Name,key__c, value__c FROM HashKey__c where TokenType__c ='DataType'];
		}else if(tokenType == 'appToken'){
			listHasKey = [SELECT Id, Name,key__c, value__c FROM HashKey__c where TokenType__c ='AppType'];
		}
		for(HashKey__c hsKey: listHasKey){
			HashKey1 hasKey = new HashKey1();
				hasKey.key = hsKey.key__c;
				hasKey.value = hsKey.value__c;
				hasKey.id = hsKey.Id;
				hasKeyList.add(hasKey);
		}
		return hasKeyList;
	}
	public class HashKey1{
		public String id;
		public String key;
		public String value;
	}
}