/*
@Company:Your SL
@Author:Parasuram
@Creation date:06/08/2015
Reference:
*/

@RestResource(urlMapping = '/PromotionMembers/*')
global class WsPromotionMembers implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
    	// do businesslogic
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);  
        List<PromotionMember> listPromotionMembers = getPromotionMembers();
    	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listPromotionMembers));
    	RestContext.response.addHeader('size', String.valueOf(listPromotionMembers.Size()));
    	RestContext.response.addHeader('Content-Type', 'application/json');        
    }

    // To get all Promotion members
    public static List<PromotionMember> getPromotionMembers(){
    	List<PromotionMember__c> listPromotionMembers = [SELECT Name,
                                                                OwnerId,
															    Promotion__c,
                                                                LastModifiedDate,
                                                                CreatedDate,
															    PriceBookEntryId__c 
														FROM PromotionMember__c
                                                        LIMIT 50000];
		List<PromotionMember> listPromotionMember = new List<PromotionMember>();
		for(PromotionMember__c member : listPromotionMembers){
			PromotionMember promotionMember = new PromotionMember(member);
			listPromotionMember.add(promotionMember);
		}
    	return listPromotionMember;
    }

    public class PromotionMember{
        public String promotionMemberId;
    	public String name{get; set;}
    	public String priceBookEntryId{get; set;}
    	public String promotionId{get; set;}
        public String ownerId {get;set;}
        public Datetime lastModifiedDateTime;
        public Datetime createdDateTime;
    	public PromotionMember(PromotionMember__c member){
    		this.name = member.Name;
    		this.priceBookEntryId = member.PriceBookEntryId__c;
    		this.promotionId = member.Promotion__c;
            this.ownerId = member.OwnerId;
            this.promotionMemberId = member.Id;
            this.lastModifiedDateTime = member.LastModifiedDate;
            this.createdDateTime = member.CreatedDate;
    	}
    }
}