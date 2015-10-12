/*
@Company:Your SL
@Author:veera
@Creation date:9/9/2015
@Reference: Ticket Number-1152
*/
@RestResource(urlMapping = '/UserProfile/*')
global class WsUserProfile {

    @HttpGet
    global static void wsGet(){

        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        if (myRequest.resquestedByUser != null){

            ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, myRequest.resquestedByUser.ID);
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndPoint(userPhoto.fullEmailPhotoUrl);
            req.setMethod('GET');
            HttpResponse res = new Http().send(req);
            Blob blobData = res.getBodyAsBlob();
            
            UserProfile usrProfile = new UserProfile();
            usrProfile.name = myRequest.resquestedByUser.Name;
            usrProfile.image = blobData;
            usrProfile.mapType = [SELECT Id,MapType__c FROM User WHERE Id =:myRequest.resquestedByUser.ID].MapType__c;
            usrProfile.locale = UserInfo.getLocale();
            
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(usrProfile));
            RestContext.response.statusCode = 200;
            RestContext.response.addHeader('Message', 'Query Executed Successfully');
        }else {
            RestContext.response.statusCode = myRequest.statusCode;
            RestContext.response.addHeader('Message', myRequest.errorMessage);
        }
    RestContext.response.addHeader('Content-Type', 'application/json');

}
public class UserProfile {
    public String name;
    public Blob image;
    public String mapType;
    public string locale;
}

}