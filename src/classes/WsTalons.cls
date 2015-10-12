/*
@Company:Your SL
@Author:Pavan
@Creation date:9/1/2015
@Reference: Ticket no 1114
*/

@RestResource(urlMapping='/Talons/*')
global class WsTalons implements UcbWs{

     public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void wsGet() {
       
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        List<TalonWrapper> listTalons = getTalons();
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listTalons));           
        RestContext.response.addHeader('size', String.valueOf(listTalons.size()));
        RestContext.response.addHeader('Content-Type', 'application/json'); 
    }
    public static List<TalonWrapper> getTalons(){

        List<Talon__c> listTalons =[SELECT Id,Name,StartDate__c,
                                          EndDate__c,LastModifiedDate,
                                          AttachmentId__c,IsZa__c,
                                          CreatedDate
                                    FROM Talon__c
                                    LIMIT 50000];

        List<TalonWrapper> listTalonWrap = new List<TalonWrapper>();        
        for(Talon__c myTalon:listTalons){
            TalonWrapper talonwrapper = new TalonWrapper(myTalon);
            listTalonWrap.add(talonwrapper);
        }
        return listTalonWrap;
    }
    public class TalonWrapper{

        public String talonId;
        public String name;
        public Date startDate;
        public Date endDate;
        public Boolean za;
        public String attachmentId;
        public Datetime lastModifiedDateTime;
        public Datetime  createdDateTime;

        public TalonWrapper(Talon__c talon){

            this.talonId = talon.Id;
            this.name = talon.Name;
            this.startDate = talon.StartDate__c;
            this.endDate = talon.EndDate__c;
            this.za = talon.IsZa__c;
            this.attachmentId = talon.AttachmentId__c;
            this.lastModifiedDateTime = talon.LastModifiedDate;
            this.createdDateTime = talon.CreatedDate;
        }

    }
}