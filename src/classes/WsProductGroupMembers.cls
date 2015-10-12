/*
@Company:Your SL
@Author:Parasuram
@Creation date:06/08/2015
Reference:
*/

@RestResource(urlMapping = '/ProductGroupMembers/*')
global class WsProductGroupMembers implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
    	// do businesslogic
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);    	
    	List<ProductGroupMember> listProductGroupMember = getProductGroupMembers();
    	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listProductGroupMember));
    	RestContext.response.addHeader('size', String.valueOf(listProductGroupMember.Size()));
    	RestContext.response.addHeader('Content-Type', 'application/json');
    }

    // To get all Product group members
    public static List<ProductGroupMember> getProductGroupMembers(){
    	List<ProductGroupMember__c> listProductGroupMembers = [SELECT Name,
																	  Product2Id__c,
																	  ProductGroup__c,
                                                                      LastModifiedDate,
                                                                      CreatedDate 
    														   FROM ProductGroupMember__c
                                                               LIMIT 50000];
		List<ProductGroupMember> listProductGpMembers = new List<ProductGroupMember>();
		for(ProductGroupMember__c productGroupMember : listProductGroupMembers){
			ProductGroupMember productGpMember = new ProductGroupMember(productGroupMember);
			listProductGpMembers.add(productGpMember);
		}
    	return ListProductGpMembers;
    }

    public class ProductGroupMember{
    	public String name{get; set;}
    	public String product2Id{get; set;}
    	public String groupId{get; set;}
        public Datetime lastModifiedDate;
        public Datetime  createdDate; 
    	public ProductGroupMember(ProductGroupMember__c member){
    		this.name = member.Name;
    		this.product2Id = member.Product2Id__c;
    		this.groupId = member.ProductGroup__c;
            this.lastModifiedDate = member.LastModifiedDate;
            this.createdDate = member.CreatedDate;
    	}
    }
}