@RestResource(urlmapping = '/Deployment1/*')
global class WsDeployment1 implements UcbWs {
    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    
    @HttpGet
    
    global static void wsGet() {
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        if(myRequest.appSetting == 'Account'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAccount()));
        } 
        if(myRequest.appSetting == 'Organization'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnOrganization()));
        }
        if(myRequest.appSetting == 'OrganizationAccountMember'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnOrganizationAccountMember()));
        }
        if(myRequest.appSetting == 'Promotion'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPromotion()));
        }
        if(myRequest.appSetting == 'AccPromotionMember'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAccountPromotionMember()));
        }
        if(myRequest.appSetting == 'PriceBook2'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPricebook()));
        }
        if(myRequest.appSetting == 'AccpriceBookMember'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnAccountPricebookMember()));
        }
        if(myRequest.appSetting == 'PriceBookEntry'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPricebookEntry()));
        }
        if(myRequest.appSetting == 'Product'){ 
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnproduct()));
        }
        if(myRequest.appSetting == 'ProductGroup'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnProductGroup()));
        }
        if(myRequest.appSetting == 'ProductGroupMember'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnProductgroupMember()));
        }
        if(myRequest.appSetting == 'OrganizationPricebookMember'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnOrgPriceBookMember()));
        }
        if(myRequest.appSetting == 'OrganizationPromotionMember'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnOrgPromotionMember()));
        }
        if(myRequest.appSetting == 'PromotionMember'){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnPromotionmember()));
        }
        RestContext.response.addHeader('Content-Type', 'application/json');  
    }
    public static List<Account> returnAccount(){
        /*
        String sobjectApiName = 'Account';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sobjectApiName).getDescribe().fields.getMap();
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            commaSepratedFields = commaSepratedFields + ', ' + fieldName;
        }
        String query = 'SELECT ' + commaSepratedFields.removeStart(',') + ' FROM ' + sobjectApiName;
        return Database.query(query);
        */
        List<Account> listAccount = [SELECT Id, SicDesc, DWDArea__c, Company__c, MarketArea__c, TMSNo__c, Rowguid__c, Remark__c, MWBoxFacingsAFGTotal__c, MWBoxFacingsWaterWithoutCO2__c, TradePrivateCooler__c, EWDWDBrandBlock__c, EWShelvesWaterWithoutCO2__c, EWAquaDrinkBlock__c, EWControlSystem__c, EWNWBlock__c, Cooler__c, Multiplacement__c, TDNo__c, BuildingPlots__c, NumberOfFacingsGesNearwater__c, NumberOfFacingsGesWater__c, PlacementOpportunities__c, NIELSEN__c, SalesType__c, TelVorw__c, Outlet__c, NationalHeadquarters__c, InstructionForm__c, DynamicField__c, VisitScore__c, GeoLocations__Longitude__s, GeoLocations__c, GeoLocations__Latitude__s, SLAExpirationDate__c, SLASerialNumber__c, UpsellOpportunity__c, NumberofLocations__c, Active__c, SLA__c, CustomerPriority__c, YearStarted, NaicsDesc, NaicsCode, Tradestyle, DunsNumber, AccountSource, JigsawCompanyId, Jigsaw, Site, Rating, Description, TickerSymbol, Ownership, NumberOfEmployees, AnnualRevenue, Industry, Sic, PhotoUrl, Fax, Phone, BillingAddress, BillingLongitude, BillingLatitude, BillingCountry, BillingPostalCode, BillingState, BillingCity, BillingStreet, ParentId, Name, Type FROM Account where GeoLocations__Latitude__s != null LIMIT 50000];
        return listAccount;

    }
    public static List<Organization__c> returnOrganization(){
        List<Organization__c> listOrganization = new List<Organization__c>();
            listOrganization = [SELECT Name,ParentOrganization__c FROM Organization__c LIMIT 50000];
            return listOrganization;
    }
    public static List<OrganizationAccountMember__c> returnOrganizationAccountMember(){
        List<OrganizationAccountMember__c> listOrganizationAccMember = new List<OrganizationAccountMember__c>();
            listOrganizationAccMember = [SELECT Name,Account__c,Organization__c FROM OrganizationAccountMember__c LIMIT 50000];
        return listOrganizationAccMember;
    }
    public static List<Product2> returnproduct(){
        List<Product2> listProduct = new List<Product2>();
            listProduct = [SELECT Name, Id, ProductCode, Description, IsActive, Family, IsDeleted,Image__c FROM Product2 LIMIT 50000];
            return listProduct;
    }
    public static List<Promotion__c> returnPromotion(){
        List<Promotion__c> listPromotion = new List<Promotion__c>();
            listPromotion = [SELECT Name, Id,EndDate__c, StartDate__c,AttachmentId__c FROM Promotion__c LIMIT 50000];
            return listPromotion;
    }
    public static List<AccountPromotionMember__c> returnAccountPromotionMember(){
        List<AccountPromotionMember__c> listAccpromotionMember = new List<AccountPromotionMember__c>();
            listAccpromotionMember = [SELECT Name,Account__c,Promotion__c FROM AccountPromotionMember__c LIMIT 50000];
            return listAccpromotionMember;
    }
    public static List<Pricebook2> returnPricebook(){
        List<Pricebook2> listPriceBook = new List<Pricebook2>();
            listPriceBook = [SELECT IsStandard, Description, IsActive, Name, Id FROM Pricebook2 WHERE IsStandard=false LIMIT 50000];
        return listPriceBook;
    }
    public static List<AccountPriceBookMember__c> returnAccountPricebookMember(){
        List<AccountPriceBookMember__c> listaccPricebookmember = new List<AccountPriceBookMember__c>();
            listaccPricebookmember = [SELECT Name,AccountId__c,PriceBookId__c,EndDate__c,StartDate__c FROM AccountPriceBookMember__c LIMIT 50000];
            return listaccPricebookmember;
    }
    public static List<PricebookEntry> returnPricebookEntry(){
        List<PricebookEntry> listPriceBookEntry = new List<PricebookEntry>();
            listPriceBookEntry = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive, UseStandardPrice, IsDeleted, FreeOfCharge__c, Talons__c, SampleWare__c, Can__c, Quantity__c, IsMandatoryForCooler__c FROM PricebookEntry LIMIT 50000];
        return listPriceBookEntry;
    }
    public static List<ProductGroup__c> returnProductGroup(){
        List<ProductGroup__c> listProductGroup = new List<ProductGroup__c>();
            listProductGroup = [SELECT Name,IsDefault__c,EndDate__c,StartDate__c,ParentGroup__c,Image__c FROM ProductGroup__c LIMIT 50000];
        return listProductGroup;
    }
    public static List<ProductGroupMember__c> returnProductgroupMember(){
        List<ProductGroupMember__c> listProductGroupmember = new List<ProductGroupMember__c>();
            listProductGroupmember = [SELECT Name,Product2Id__c,ProductGroup__c FROM ProductGroupMember__c LIMIT 50000];
        return listProductGroupmember;
    }
    public static List<OrganizationPriceBookMember__c> returnOrgPriceBookMember(){
        List<OrganizationPriceBookMember__c> listOrgPriceBookMember = new List<OrganizationPriceBookMember__c>();
            listOrgPriceBookMember = [SELECT Name,EndDate__c,OrganizationId__c,PriceBookId__c,StartDate__c FROM OrganizationPriceBookMember__c LIMIT 50000];
        return listOrgPriceBookMember;
    }
    public static List<OrganizationPromotionMember__c> returnOrgPromotionMember(){
        List<OrganizationPromotionMember__c> listOrgPromotionmember = new List<OrganizationPromotionMember__c>();
            listOrgPromotionmember = [SELECT Name,Organization__c,Promotion__c FROM OrganizationPromotionMember__c LIMIT 50000];
        return listOrgPromotionmember;
    }
    public static List<PromotionMember__c> returnPromotionmember(){
        List<PromotionMember__c> listPromotionMember = new List<PromotionMember__c>();
            listPromotionMember = [SELECT Name,PriceBookEntryId__c,Promotion__c FROM PromotionMember__c LIMIT 50000];
        return listPromotionMember;
    }
    public static AttachmentWrapper returnAttachMent(String attachMentId){
        if(attachMentId <> null && attachMentId <> ''){
            try{
                    Attachment att = [SELECT Id,Name,Body,ParentId FROM Attachment where ID=:attachMentId];
                    AttachmentWrapper attWrap = new AttachmentWrapper();      
                        attWrap.id = att.ID;
                        attWrap.name = att.Name;
                        attWrap.body = att.Body;
                        attWrap.parentId = att.ParentId;
                    return attWrap;
                }catch(Exception e){
                    
            }            
        } 
        return null;      
    }
    public class AttachmentWrapper{
        public String name;
        public Id id;
        public Blob body;
        public String parentId;
    }
}