/*
 @Company: YOUR SL
 @Author: KVE
 @Creation date: 16/06/2015
 @Modified date: 22/07/2015
 @Ref: 621
*/
global class BatchPostDeployment implements Database.Batchable<Id>, Database.AllowsCallouts{

    public Map<Id,Map<Id,Id>>  mapIds {get;set;}
    public Map<Id,Id>  mapNewIds {get;set;}
    // OldAttachmentID  Map<  OldParentId, NewParentId >
    public BatchPostDeployment(Map<Id,Map<Id,Id>>  mapIdId){
        system.debug('mapIdId-------------'+mapIdId.size());
        this.mapIds = mapIdId;
        this.mapNewIds = new Map<Id,Id>();
        for(Id oldAttachmentId : mapIds.keySet()){
            this.mapNewIds.put(oldAttachmentId, oldAttachmentId);
        }
        system.debug('mapNewIds----------------'+mapNewIds.size());
    }

    global Iterable<Id> start(database.batchablecontext BC){

        return mapNewIds.values();

    }

    global void execute(Database.BatchableContext BC, list<Id> scope){      
       // get the Mobile and AppSettings
        system.debug('execute-----------------'+scope);
        for(Id myId : scope){
            doIt(myId);
        }
    }


    public void doIt(Id scope){
        system.debug('scope----------------'+scope);
        //String clientId = '3MVG9Rd3qC6oMalUEvDDsZ.dGitMn77csJYM2GPSb11n5tDEvUayiGSmmmbSSsIEHItJPZXEPJmPIDrYwizOP';
        //String clientSecret = '1184065286610443678';
        //String username = 'k.verheyden@nera.centralhub';
        //String password = 'Wasbeer1!G63X9QZCAruidgtRNHlI5N1fN';
        //String url = 'https://eu5.salesforce.com';
        String clientId = '3MVG9Rd3qC6oMalUEvDDsZ.dGigns8FuEpVMh5FD2sLNa3eN1JptaXH1UnR6bzUC5n86ddAhAY4qteuQYVEgU';
        String clientSecret = '9004469196367839452';
        String username = 'imran.s@nera.demodev';
        String password = '1q2w3e4r5th05fZJW9QxSWSh5O8XPe7Agy';
        String url = 'https://eu5.salesforce.com';

        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('GET');
        req.setEndpoint( url +'/services/oauth2/token');//Note if my domain is set up use the proper domain name else use login.salesforce.com for prod or developer or test.salesforce.com for sandbox instance

        HttpResponse res = h.send(req);

        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
        
        if(objAuthenticationInfo.access_token!=null){
                Attachment myAttachment = getResponse(objAuthenticationInfo,scope);
                /*
                System.Debug('PARENT ID -----> ' + myAttachment.ParentId);
                System.Debug('BODY ID -----> ' + myAttachment.Body);
                System.Debug('NAME ID -----> ' + myAttachment.Name);
                System.Debug(' ID -----> ' + myAttachment.Id);
                */
            //Id oldAttachmentId = myAttachment.Id;
            //myAttachment.ParentId = this.mapIds.get(myAttachment.id).get(myAttachment.ParentId);
            myAttachment.Id = null;
            if(myAttachment.Name != null && myAttachment.Body != null){
                myAttachment.ParentId = this.mapIds.get(scope).get(myAttachment.ParentId);      
                insert myAttachment;
            }           
        }
        //get new parentId based on the old parentId
    }

    global void finish(Database.BatchableContext info){
    }

    public static Attachment getResponse(OAuth2 objAuthenticationInfo, String attachmentId){
        String url = 'https://eu5.salesforce.com';
        Http h1 = new Http();
        HttpRequest requestMobileAndApp = new HttpRequest();
        requestMobileAndApp.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
        requestMobileAndApp.setHeader('Content-Type','application/json');
        requestMobileAndApp.setHeader('accept','application/json');
        requestMobileAndApp.setMethod('GET');
        requestMobileAndApp.setEndpoint(url +'/services/apexrest/Deployment/?attachMentId='+attachmentId);

        HttpResponse myResponse = h1.send(requestMobileAndApp);
        String myJson = myResponse.getBody();
        //myJson = '{"MobileDevice__c":' + myJson + '}';
        System.debug('KIM ----> ' + myJson);
        JSONParser parser = JSON.createParser(myJson);
        
        Attachment att = new Attachment();
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'ParentId') {
                    att.parentId = parser.getText();
                }else if(fieldName == 'Body'){
                    att.body = EncodingUtil.base64Decode(parser.getText());
                }else if(fieldName == 'Name'){
                    att.name = parser.getText();
                }else if(fieldName == 'Id'){
                    att.id = parser.getText();
                }
            }
        }
        system.debug('att-------------------'+att);
        return att;
    }

    public class OAuth2{

         public String id{get;set;}
         public String issued_at{get;set;}
         public String instance_url{get;set;}
         public String signature{get;set;}
         public String access_token{get;set;}

    }

}
