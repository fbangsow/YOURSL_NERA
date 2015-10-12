/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no 
*/

@RestResource(urlmapping = '/PoiDeviceType/*')

global class Wspoidevice implements WsPos {

    public static WsPosResponse doReply(WsPosRequest request) {
        return new WsPosResponse();

    }

    @HttpGet

    global static PoiDeviceType wsDeviceGet() {
        try {

            List < POIDeviceType__c > listPoiDevicetype = [SELECT Id, Name, (select id,Name,POIDeviceType__c From POIDevices__r) FROM POIDeviceType__c];

            
            return new PoiDeviceType('true', 'Query Executed Successfully.', listPoiDevicetype);
            
        } catch (Exception e) {


            return new PoiDeviceType('false', e.getMessage(), null);
        }
    }

    Global class PoiDeviceType {
        public String success {get;set;}
        public String message{get;set;} 
        public List < POIDeviceType__c > poiDevicetypevalue {get;set;}
            
    global PoiDeviceType(String success, String message, List < POIDeviceType__c > poiDevicetypevalue) {
            this.success = success;
            this.message = message;
            this.poiDevicetypevalue = poiDevicetypevalue;
        }

    }
}