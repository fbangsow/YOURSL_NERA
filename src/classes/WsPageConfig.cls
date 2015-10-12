@RestResource(urlMapping ='/PageConfig/*')
global class WsPageConfig
{
@Httpget
global static Attachment  WsGet()
{
    RestRequest request = RestContext.request;
   // PageConfig__c result = [select Id,ImageBlob__c,Photo__c,Images__c FROM PageConfig__c  where Id = :'a0224000002Hvtf'];
    Attachment listAttachments=[Select Id, body from Attachment Where Parent.Type = 'PageConfig__c'];

    return listAttachments;
}   
}