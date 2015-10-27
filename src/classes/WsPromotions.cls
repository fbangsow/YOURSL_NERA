/*
@Company:Your SL
@Author:Pavan
@Creation date:19/8/2015
@Reference: 
*/
@RestResource(urlMapping = '/Promotions/*')
global class WsPromotions implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request){
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet(){

        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        List<PromotionWrapper> listPromotions = getPromotions();
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listPromotions));           
        RestContext.response.addHeader('size', String.valueOf(listPromotions.size()));
        RestContext.response.addHeader('Content-Type', 'application/json'); 
    }  
    
    public static List<PromotionWrapper> getPromotions(){

        //Map<ID,ID> mapPromoAttIds = new Map<ID,ID>();
        Map<Id,List<Id>> mapaprentatt = new Map<Id,List<Id>>();
        List<Id> attIds = new List<ID>();
        
        List<Promotion__c> listPromotions =  [SELECT Id,Name,AttachmentId__c,
                                                        StartDate__c,EndDate__c,ActionValidityEndDate__c,ActionValidityStartDate__c,
                                                        LastModifiedDate,Description__c,SellingValidityStartDate__c,SellingValidityEndDate__c,
                                                        CreatedDate
                                              FROM Promotion__c];

        for(Promotion__c promo:listPromotions){

           // mapPromoAttIds.put(promo.id, promo.AttachmentId__c);
           attIds.add(promo.AttachmentId__c);

        }                                      
                                              
        
        
        for(Attachment att:[SELECT Id,Name,body,parentId FROM Attachment WHERE parentId IN:listPromotions AND Id NOT IN:attIds]){
            If(att.parentId!=NULL){
                IF(!mapaprentatt.containskey(att.parentId)){
                    mapaprentatt.Put(att.parentId,new List<Id>());
                }
                mapaprentatt.get(att.parentId).add(att.id);
                
            }
        }
        
        List<PromotionWrapper> listPromotion = new List<PromotionWrapper>();
        for(Promotion__c myPromotion:listPromotions){
            
            PromotionWrapper promotionWrapper = new PromotionWrapper(myPromotion,mapaprentatt.containskey(myPromotion.id)? mapaprentatt.get(myPromotion.id):NULL);
            listPromotion.add(promotionWrapper);
        }
        return listPromotion;

    }

    public class PromotionWrapper{

        public String promotionid {get;set;}
        public String promotionname {get; set;}
        public String image;
        public Datetime lastModifiedDateTime;
        public Datetime  createdDateTime;
        public Date startDate;
        public Date endDate;
        public Date actionValidityStartDate;
        public Date actionValidityEndDate;
        public Date sellingValidityStartDate;
        public Date sellingValidityEndDate;
        public String Description;  
        public List<Id> pdfattid;

        public PromotionWrapper(Promotion__c myPromotion,List<id> attid){

            this.promotionid = myPromotion.Id;
            this.promotionname = myPromotion.Name;
            this.image = myPromotion.AttachmentId__c;
            this.lastModifiedDateTime = myPromotion.LastModifiedDate;
            this.createdDateTime = myPromotion.CreatedDate;
            this.startDate = myPromotion.StartDate__c;
            this.endDate = myPromotion.EndDate__c;
            this.Description = myPromotion.Description__c;
            this.sellingValidityEndDate = myPromotion.SellingValidityEndDate__c;
            this.sellingValidityStartDate = myPromotion.SellingValidityStartDate__c;
            this.actionValidityEndDate = myPromotion.ActionValidityEndDate__c;
            this.actionValidityStartDate = myPromotion.ActionValidityStartDate__c;
            this.pdfattid = attid;
            
        }
    }
    
}