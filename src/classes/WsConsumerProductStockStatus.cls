/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no 
*/

@RestResource(urlMapping = '/ConsumerProductStockStatus/*')


global class WsConsumerProductStockStatus implements WsPos
{
public static WsPosResponse  doReply(WsPosRequest request) {
        return new WsPosResponse ();
    }
    @HttpGet
    global static void wsGet() {
    
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    List<ConsumerProductStockStatus__c> listDataset = getConsumerProductStockStatus();
     RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listDataset));
    RestContext.response.addHeader('Content-Type', 'application/json');
}

public static List<ConsumerProductStockStatus__c> getConsumerProductStockStatus()
{
List<ConsumerProductStockStatus__c> lstConsumerProductStockStatus =[Select id, Name, Potential__c From ConsumerProductStockStatus__c ];

return lstConsumerProductStockStatus;
}

}