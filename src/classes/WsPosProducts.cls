/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no 
*/


@RestResource(urlMapping = '/PosProducts/*')


global class WsPosProducts implements WsPos
{
public static WsPosResponse  doReply(WsPosRequest request) {
        return new WsPosResponse ();
    }
    @HttpGet
    global static void wsGet() {
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    List<Product2> listDataset = getPosProducts();
    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listDataset));
    RestContext.response.addHeader('Content-Type', 'application/json');
    }

    public static List<Product2> getPosProducts()
    {
 
 List<Product2> productlist = [SELECT Id,Name FROM Product2 limit 100];

return productlist;
    }
}