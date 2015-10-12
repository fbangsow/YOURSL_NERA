/*
@Company:Your SL
@Author:Pavan
@Creation date:03/08/2015
Reference: Ticket no 766
*/

@RestResource(urlMapping = '/PriceBookEntries/*')
global class WsPriceBookEntries implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {

        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        List<PriceBookEntryWrapper> listPriceBookEntryWrapper = getPriceBookentries();
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listPriceBookEntryWrapper));      
    RestContext.response.addHeader('size', String.valueOf(listPriceBookEntryWrapper.size()));
    RestContext.response.addHeader('Content-Type', 'application/json'); 
    }
    
    public static List<PriceBookEntryWrapper> getPriceBookentries(){

       List<PriceBookEntry> listPriceBookEntries=[SELECT Id, Name,
                                                          IsActive,Product2Id,
                                                          ProductCode,UnitPrice,
                                                          IsFreeOfCharge__c,IsSampleWare__c,
                                                          UseStandardPrice,Pricebook2.Name,
                                                          Pricebook2Id,IsCan__c,Quantity__c,Description__c,
                                                          IsMandatoryForCooler__c,Product2.Image__c,
                                                          Nan__c,Delivery__c,Display__c,Unit__c,
                                                          LastModifiedDate,CreatedDate
                                                    FROM PricebookEntry 
                                                    WHERE IsActive = true
                                  ];
        List<PriceBookEntryWrapper> listPriceBookEntry = new List<PriceBookEntryWrapper>();
        for(PriceBookEntry myPrice:listPriceBookEntries){
            PriceBookEntryWrapper priceBookWrapper = new PriceBookEntryWrapper(myPrice);
            listPriceBookEntry.add(priceBookWrapper);
        }
        return listPriceBookEntry;
    }
    public class PriceBookEntryWrapper{

        public String priceBookEntryId;
        public String name;
        public String isActive;
        public String product2Id;
        public String productCode;
        public String unitPrice;
        public String useStandardPrice;
        public String priceBook2Id;
        public String can;
        public String image;
        public Decimal quantity;
        public Boolean mandatoryForCooler;
        public Boolean freeOfCharge;
        public Boolean sampleWare;
        public Datetime lastModifiedDateTime;
        public Datetime  createdDateTime;
        public String description;
        public Decimal nan;
        public Date delivery;
        public String display;
        public Decimal unit;

        public PriceBookEntryWrapper(PricebookEntry myPriceBookentry) {

            this.quantity = myPriceBookentry.Quantity__c;
            this.priceBookEntryId = myPriceBookentry.Id;
            this.name = myPriceBookentry.Name;
            this.isActive = String.valueOf(myPriceBookentry.IsActive);
            this.product2Id = myPriceBookentry.Product2Id;
            this.productCode = myPriceBookentry.ProductCode;
            this.unitPrice = String.valueOf(myPriceBookentry.UnitPrice);
            this.useStandardPrice = String.valueOf(myPriceBookentry.UseStandardPrice);
            this.priceBook2Id = myPriceBookentry.Pricebook2Id;
            this.can = String.valueof(myPriceBookentry.IsCan__c);
            this.image = myPriceBookentry.Product2.Image__c;
            this.description = myPriceBookentry.Description__c;
            this.mandatoryForCooler = myPriceBookentry.IsMandatoryForCooler__c;
            this.freeOfCharge = myPriceBookentry.IsFreeOfCharge__c;
            this.sampleWare = myPriceBookentry.IsSampleWare__c;
            this.nan = myPriceBookentry.Nan__c;
            this.delivery = myPriceBookentry.Delivery__c;
            this.display = myPriceBookentry.Display__c;
            this.unit = myPriceBookentry.Unit__c;
            this.lastModifiedDateTime = myPriceBookentry.LastModifiedDate;
            this.createdDateTime = myPriceBookentry.CreatedDate;
        }
    }
}