/*
@Company:Your SL
@Author:Veera
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/Attachments/*')

global class WsAttachments implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void returnImages() {

        String imageIds = RestContext.request.params.get('ImageIds');
        List < String > imageIdList = (List < String > ) JSON.deserialize(imageIds, List < String > .class);
        system.debug('imageIdList----------' + imageIdList);
        //create request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        //do businesslogic
        List < clsImage > lstImages = WsAttachments.getBlobAttachments(imageIdList);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(lstImages));

    }

    public static List < clsImage > getBlobAttachments(List < String > imageIdList) {

        List < clsImage > lstImages = new List < clsImage > ();
        List < Attachment > lstAttachments = new List < Attachment > ();

        lstAttachments = [Select Id,Name, body 
                          FROM Attachment 
                          WHERE id IN: imageIdList];
        
        for (Attachment objAttch: lstAttachments) {
            clsImage objImage = new clsImage();
            objImage.id = objAttch.Id;
            objImage.content = objAttch.body;
            objImage.Name=objAttch.Name;
            lstImages.add(objImage);
        }

        return lstImages;
    }

    class clsImage {
        public String id { get;set; }            
        public Blob content { get;set; }
        public String name { get;set; }
            
    }
}