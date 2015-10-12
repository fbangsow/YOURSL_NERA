@RestResource(urlmapping = '/SurveyExecutionDeployment/*')

global class WsSurveyEcutionDeployment implements UcbWs {

	public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void wsGet() {
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	if(myRequest.appSetting == 'AccountPosMember'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAccountPosMember()));
        } 
        else if(myRequest.appSetting == 'POIType'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPOIType()));
        } 
        else if(myRequest.appSetting == 'POIHeader'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPOIHeader()));
        } 
        else if(myRequest.appSetting == 'POIQuestion'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPOIQuestion()));
        }
        else if(myRequest.appSetting == 'AuditQuestion'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAuditQuestion()));
        }
        else if(myRequest.appSetting == 'AuditQuestionType'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAuditQuestionType()));
        }
        
        RestContext.response.addHeader('Content-Type', 'application/json');
    }
    public static List<AccountPosMember__c> returnAccountPosMember(){
    	List<AccountPosMember__c> listAccPosMember = new List<AccountPosMember__c>();
    		listAccPosMember = [SELECT Name,Account__c,PageConfig__c FROM AccountPosMember__c LIMIT 50000];
		return listAccPosMember;
    }

    public static List<POIType__c> returnPOIType(){
    	List<POIType__c> listPoiType = new List<POIType__c>();
    	listPoiType = [SELECT Name,AttachmentId__c,HasWeightage__c,Order__c,Weightage__c FROM POIType__c LIMIT 50000];
    	return listPoiType;
    }

    public static List<POIHeader__c> returnPOIHeader(){
    	List<POIHeader__c> listPOIHeader = new List<POIHeader__c>();
    	listPOIHeader = [SELECT Name,AttachmentId__c,Description__c,UIControl__c FROM POIHeader__c LIMIT 50000];
    	return listPOIHeader;
    }

    public static List<POIQuestion__c> returnPOIQuestion(){
    	List<POIQuestion__c> listPOIQuestion = new List<POIQuestion__c>();
    	listPOIQuestion = [SELECT Name,AuditQuestion__c,UIControl__c FROM POIQuestion__c LIMIT 50000];
    	return listPOIQuestion;
    }

    public static List<AuditQuestion__c> returnAuditQuestion(){
    	List<AuditQuestion__c> listAuditQuestion = new List<AuditQuestion__c>();
    	listAuditQuestion = [SELECT Name,AuditQuestionType__c,Description__c,Potential__c FROM AuditQuestion__c LIMIT 50000];
    	return listAuditQuestion;
    }

    public static List<AuditQuestionType__c> returnAuditQuestionType(){
    	List<AuditQuestionType__c> listAuditQuestionType = new List<AuditQuestionType__c>();
    	listAuditQuestionType = [SELECT Name,HasWeightage__c,MaximumValue__c,Minimum_value__c,MultiSelectFields__c,MultiSelectPredicate__c,MultiSelectSource__c,Step__c,Weightage__c 
    								FROM AuditQuestionType__c LIMIT 50000];
		return listAuditQuestionType;
    }
}