/*
@Company:Your SL
@Author:Pavan
@Creation date:9/3/2015
@Reference: ticket no:1114
*/
@RestResource(urlMapping = '/TalonPriceBookEntryMember/*')
global class WsTalonPriceBookEntryMember implements UcbWs {

    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpGet
    global static void wsGet() {
    	//create request
    	UcbWsRequest myrequest = new UcbWsRequest(RestContext.request);
    	List<TalonPriceBookentryWrapper> listTalonWrapper = getTalonPriceBookentries();
    	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listTalonWrapper));
    	RestContext.response.addHeader('size', String.valueOf(listTalonWrapper.Size()));
    	RestContext.response.addHeader('Content-Type', 'application/json');
    }
    public static List<TalonPriceBookentryWrapper> getTalonPriceBookentries(){
    	List<TalonPriceBookEntryMember__c> listTalonPriceBooks =[SELECT Id,Name,Talon__c,
    																	PriceBookEntryId__c,
    																	LastModifiedDate,
                                                                        CreatedDate
    															 FROM TalonPriceBookEntryMember__c
                                                                 LIMIT 50000];
    	List<TalonPriceBookentryWrapper> listTalonWrapper = new List<TalonPriceBookentryWrapper>();
    	for(TalonPriceBookEntryMember__c myTalons:listTalonPriceBooks){
    		TalonPriceBookentryWrapper talonpriceBook = new TalonPriceBookentryWrapper(myTalons);
    		listTalonWrapper.add(talonpriceBook);
    	}
    	return listTalonWrapper;
    }
   public class TalonPriceBookentryWrapper{
		public String talonPriceBookEntryId;
		public String priceBookEntryId;
		public String talonId;
		public String name;
		public Datetime lastModifiedDate;
		public Datetime createdDate;
		public TalonPriceBookentryWrapper(TalonPriceBookEntryMember__c myTalonPriceBook){
			this.talonPriceBookEntryId = myTalonPriceBook.Id;
			this.name = myTalonPriceBook.Name;
			this.talonId = myTalonPriceBook.Talon__c;
			this.priceBookEntryId = myTalonPriceBook.PriceBookEntryId__c;
			this.lastModifiedDate = myTalonPriceBook.LastModifiedDate;
			this.createdDate = myTalonPriceBook.CreatedDate;
		}
	}	
}