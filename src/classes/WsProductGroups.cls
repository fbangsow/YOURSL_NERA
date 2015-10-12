/*
@Company:Your SL
@Author:Parasuram
@Creation date:06/08/2015
Reference:
*/

@RestResource(urlMapping = '/ProductGroups/*')
global class WsProductGroups implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
    	// do businesslogic
    	UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
    	List<ProductGroup> listProductGroup = getProductGroups();
    	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listProductGroup));
    	RestContext.response.addHeader('size', String.valueOf(listProductGroup.Size()));
    	RestContext.response.addHeader('Content-Type', 'application/json');
    }

    // To get all Product groups
    public static List<ProductGroup> getProductGroups(){
    	List<ProductGroup__c> listProductGroups = [SELECT Id,Name,
    												    ParentGroup__c,EndDate__c,
    													StartDate__c,Image__c,
    													IsDefault__c,ParentGroup__r.Name,
                                                        LastModifiedDate,
                                                        CreatedDate 
												    FROM ProductGroup__c
                                                    LIMIT 50000];
		List<ProductGroup> listProductGroup = new List<ProductGroup>();
		for(ProductGroup__c productGroup : listProductGroups){
			ProductGroup productGroupwrapper = new ProductGroup(productGroup);
			listProductGroup.add(productGroupwrapper);
		}
    	return listProductGroup;
    }

    public class ProductGroup{
    	public String name{get; set;}
    	public String id{get; set;}
    	public String image{get; set;}
    	public String parentGroupId{get; set;}
    	public String parentGroupName{get; set;}
        public Datetime lastModifiedDateTime;
        public Datetime  createdDateTime;  
    	public ProductGroup(ProductGroup__c productGroup){
    		this.name = productGroup.Name;
    		this.id = productGroup.Id;
    		this.image = productGroup.Image__c;
    		this.parentGroupId = productGroup.ParentGroup__c;
    		this.parentGroupName = productGroup.ParentGroup__r.Name;
            this.lastModifiedDateTime =productGroup.LastModifiedDate;
            this.createdDateTime = productGroup.CreatedDate;
    	}
    }
}