/*
@Company:Your SL
@Author:unkown
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/AppErrorLog/*')
global class WsAppErrorLog implements Ucbws{

	public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

	@HttpPost
	global static void wsPost() {
		String userId = RestContext.request.params.get('userId');
		String logs = RestContext.request.params.get('logs');
		System.debug('logs----------------'+logs);
		System.debug('userId----------------'+userId);
		List<AppErrorLogWrapper> listApperror = insertAppError(userId,logs);
		System.debug('listApperror-------------'+listApperror);
		 if (listApperror.size() > 0) {
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listApperror));
        } else {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Error');
        }
	}
	 public static List<AppErrorLogWrapper> insertAppError(String userId,String logs) {
	 	List<AppErrorLog__c> listAppErrorLog = new List<AppErrorLog__c>();
	 	List<AppErrorLogWrapper> listAppErrorLogWrapper = new List<AppErrorLogWrapper>();
	 	System.debug('jsonData-------------'+logs);
	 	if(!String.isEmpty(userId) && !String.isEmpty(logs)){
	 		List<ApexErrorLog> jsonData =  (List<ApexErrorLog>) System.JSON.deserialize(logs, List<ApexErrorLog>.class);	 	
		 	
		 	for(ApexErrorLog appError : jsonData){
		 		AppErrorLog__c appLog = new AppErrorLog__c();
		 		appLog.AppVersion__c = appError.AppVersion;
		 		appLog.DeviceId__c = appError.DeviceId;
		 		appLog.DeviceOs__c = appError.DeviceOs;
		 		appLog.ErrorDump__c = appError.ErrorDump;
		 		appLog.ExceptionId__c = appError.ExceptionId;
		 		appLog.UserId__c = userId;
		 		listAppErrorLog.add(appLog);
	 		} 	
	 		
	 	insert listAppErrorLog;
	 	} 	
	 	for(AppErrorLog__c obj : listAppErrorLog)
	 	{
	 			AppErrorLogWrapper errorLog = new AppErrorLogWrapper();
	 			errorLog.AppVersion =obj.AppVersion__c;
	 			errorLog.DeviceId = obj.DeviceId__c;
	 			errorLog.DeviceOs = obj.DeviceOs__c;
	 			errorLog.ErrorDump = obj.ErrorDump__c;
	 			errorLog.ExceptionId = obj.ExceptionId__c;
	 			errorLog.UserId = obj.UserId__c;
	 			errorLog.Id = obj.Id;
 			listAppErrorLogWrapper.add(errorLog);
	 	}

	 	return listAppErrorLogWrapper;
 	}
 	public class ApexErrorLog{
		public String AppVersion;	
		public String DeviceId;	
		public String DeviceOs ;	
		public String ErrorDump;
		public String ExceptionId;	
		public String Id;	
		public String UserId;
	}	
	public class AppErrorLogWrapper{
		public String AppVersion ;
		public String DeviceId ;
		public String DeviceOs ;
		public String ErrorDump ;
		public String ExceptionId ;
		public String UserId ;
		public String Id;
	}
}