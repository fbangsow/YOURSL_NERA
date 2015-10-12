/*
@Company:Your SL
@Author:veera
@Creation date:28/5/2015
Reference: Ticket no 369
*/
@RestResource(urlMapping = '/Products/*')

global class WsProducts implements UcbWs {
    
  public static UcbWsResponse doReply(UcbWsRequest request){
    return new UcbWsResponse();
  }

  @HttpGet
  global static void wsGet(){

    UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        List <Product2> listProduct2s = new List <Product2>();
        List<PriceBookWrapper> listProducts = new List<PriceBookWrapper>();
    // do businesslogic
    if(myRequest.resquestedByUser!= null) {
       listProduct2s = getProduct2s(myRequest.resquestedByUser.Id);
       if(!listProduct2s.isEmpty()) {
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listProduct2s));      
            RestContext.response.addHeader('size', String.valueOf(listProduct2s.size()));
        } 
            RestContext.response.addHeader('Content-Type', 'application/json');        
    }  
      else{
          listProducts = getPriceBookProducts();  
           if(!listProducts.isEmpty()){
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listProducts));      
                RestContext.response.addHeader('size', String.valueOf(listProducts.size()));
          }          
        else {
            RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }                                              
        RestContext.response.addHeader('Content-Type', 'application/json');
  }
}
  

  public static List<Product2> getProduct2s(Id owner) {
    //TODO: need to filter the products to get only the ones that the user has access to.
    return new List <Product2> ([SELECT Id,Image__c,
                                      Family, IsActive,Name, ProductCode 
                                 FROM Product2 
                                 WHERE IsActive = true]);
  }
  public static Map<Id, Pricebook2> getPriceBooks() {

        return new Map<Id, Pricebook2>([
                                           SELECT Id, Name, IsActive
                                           FROM PriceBook2
                                           WHERE IsActive = true
                                       ]);
    }
    //pavan
    public static List<PriceBookWrapper> getPriceBookProducts(){

      List<Pricebook2> listPriceBook = [SELECT Id,Name,IsActive,
                          (SELECT Id, Name, IsActive,
                                   Product2Id, ProductCode,
                                   UnitPrice, UseStandardPrice,
                                   IsFreeOfCharge__c,
                                   IsSampleWare__c, 
                                   Pricebook2Id 
                           FROM PriceBookEntries
                           WHERE IsActive = true)
                           From Pricebook2];

      List<PriceBookWrapper> listProducts = new List<PriceBookWrapper>();
      for(Pricebook2 priceBook : listPriceBook){
        PriceBookWrapper priceBookWrap = new PriceBookWrapper(pricebook);
        priceBookWrap.products = new List<ProductWrapper>();
        for(PriceBookEntry entry : priceBook.PriceBookEntries){
          ProductWrapper pw = new ProductWrapper(entry);
          priceBookWrap.products.add(pw);
        }
        listProducts.add(priceBookWrap);
      }

      return listProducts;
    }

  public static Map<Id, PricebookEntry> getPriceBookEntries(Set<Id> setPriceBookIds) {

        return new Map<Id, PricebookEntry>([SELECT  Id, Name, IsActive,
                                                    Product2Id, ProductCode,
                                                    UnitPrice, UseStandardPrice,
                                                    IsFreeOfCharge__c,
                                                    IsSampleWare__c, 
                                                    Pricebook2Id
                                            FROM PricebookEntry
                                            WHERE Pricebook2Id = : setPriceBookIds AND IsActive = true
                                           ]);
  }
  
    public class PriceBookWrapper {  

        public String priceBookId;
        public String name;
        public String isActive;
        public List<ProductWrapper> products;

      public PriceBookWrapper(Pricebook2 myPriceBook){

        this.priceBookId = myPriceBook.Id;
        this.name = myPriceBook.Name;
        this.products = new List<ProductWrapper>();
      }
    }
    public class ProductWrapper{

        public String priceBookEntryid;
        public String name;
        public String isActive;
        public String product2Id;
        public String productCode;
        public String unitPrice;
        public String useStandardPrice;
        public String freeOfCharge;
        public String sampleWare;
       
      public ProductWrapper(PricebookEntry mypriceBookentries){

        this.priceBookEntryid = mypriceBookentries.Id;
        this.name = mypriceBookentries.Name;
        this.isActive = String.valueOf(mypriceBookentries.IsActive);
        this.product2Id = mypriceBookentries.Product2Id;
        this.productCode = mypriceBookentries.ProductCode;
        this.unitPrice = String.valueOf(mypriceBookentries.UnitPrice);
        this.useStandardPrice = String.valueOf(mypriceBookentries.UseStandardPrice);
        this.freeOfCharge = string.valueof(mypriceBookentries.IsFreeOfCharge__c);
        this.sampleWare = string.valueof(mypriceBookentries.IsSampleWare__c);           
      }
    }
}