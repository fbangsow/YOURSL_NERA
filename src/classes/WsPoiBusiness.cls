/*
@Company:Your SL
@Author:Veera
@Creation date:7/9/2015
Reference: 
*/
@RestResource(urlmapping = '/PoiBusiness/*')

global class WsPoiBusiness implements WsPos{

    public static WsPosResponse doReply(WsPosRequest request) {
        return new WsPosResponse();

    }

    @HttpGet

    global static UicontrolBusinessWrapper wsGet() {
        try {

            List < UIControl__c> listBusinessPoi = [SELECT Id, Name, (select id,UIControl__c, Name from UIControl__c.POIBusinessMembers__r) FROM UIControl__c];

            // if(listBusinessprocess != null)
            //{
            return new UicontrolBusinessWrapper('true', 'Query Executed Successfully.', listBusinessPoi);
            // }
        } catch (Exception e) {


            return new UicontrolBusinessWrapper('false', e.getMessage(), null);
        }
    }

    Global class UicontrolBusinessWrapper{
        public String success {get;set;}
        public String message{get;set;} 
        public List < UIControl__c> PoiBusiness {get;set;}
            
    global UicontrolBusinessWrapper(String success, String message, List < UIControl__c> PoiBusiness) {
            this.success = success;
            this.message = message;
            this.PoiBusiness= PoiBusiness;
        }

    }
}