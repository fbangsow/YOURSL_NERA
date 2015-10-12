/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no 
*/
@RestResource(urlMapping = '/PosProductGroup/*')


global class WsPosProductGroup implements WsPos
{
public static WsPosResponse  doReply(WsPosRequest request) {
        return new WsPosResponse ();
    }

    @HttpGet
  global static void wsGet() {
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    List <PosProductGroup__c> listDataset = getPosProductGroup();

    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listDataset));
    RestContext.response.addHeader('Content-Type', 'application/json');
    }


    public static List<PosProductGroup__c> getPosProductGroup()
    {
      List <PosProductGroup__c> posProductGroupList =[SELECT id,Name,AttachmentId__c FROM PosProductGroup__c];

      return posProductGroupList;
    }

}