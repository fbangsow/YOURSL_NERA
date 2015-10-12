/*
@Company:Your SL
@Author:Veera
@Creation date:4/6/2015
Reference: Ticket no 463
*/
@RestResource(urlmapping = '/BusinessProcess/*')

global class WsBusinessProcess implements UcbWs{

    public static UcbWsResponse doReply(UcbWsRequest request){
        return new UcbWsResponse();
    }

    // This method returns all business process and business process parameters

    @HttpGet
    global static void wsGet(){      
        
        List<BussinessProcess> businessProcessData = retrunBussinessProcess();
        if(!businessProcessData.isEmpty()){
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(businessProcessData));
            RestContext.response.addHeader('statusCode', '200');
            RestContext.response.addHeader('Message', 'Query Executed Successfully');
            
        }else{
            RestContext.response.addHeader('statusCode', '400');
            RestContext.response.addHeader('Message', 'No data Found');
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
    }

    public static List<BussinessProcess> retrunBussinessProcess(){
        
        List<BussinessProcess> busProcess  = new List<BussinessProcess>();
        List <Businessprocess__c> listBusinessProcess = [SELECT Id, Name, (select id, BusinessprocessId__c, Name,IsPotential__c,Values__c, value__c,ValueNumber__c from BusinessProcessParameters__r) FROM BusinessProcess__c];       
        
        for(Businessprocess__c bus: listBusinessProcess){
            BussinessProcess obj = new BussinessProcess();
                obj.Id = bus.Id;
                obj.Name = bus.Name;
                if(!bus.BusinessProcessParameters__r.isEmpty())
                obj.BusinessProcessRecords = returParameters(bus.BusinessProcessParameters__r);
            busProcess.add(obj);
        }
        return busProcess;           
    }

    // This method returns all the buniess process parameters
    public static List<BusinessprocessParameter> returParameters(List<BusinessProcessParameter__c> busParameters){
        
        List<BusinessprocessParameter> listPara = new List<BusinessprocessParameter>();
        for(BusinessProcessParameter__c obj : busParameters){
            BusinessprocessParameter wrap = new BusinessprocessParameter();
                wrap.Id = obj.Id;
                wrap.Name = obj.Name;
                wrap.IsPotential = obj.IsPotential__c;
                wrap.Values = obj.Values__c;
                wrap.ValueNumber = obj.ValueNumber__c;
                wrap.Value = obj.Value__c;
                wrap.BusinessProcessId = obj.BusinessprocessId__c;
            listPara.add(wrap);
        }
        return listPara;
    }

    //Warpper class for busniess process
    public class BussinessProcess{
        public String Id;
        public String Name;
        public List <BusinessprocessParameter> BusinessProcessRecords;
    }

    // Warper class for business process parameters
    public class BusinessprocessParameter{
        public String Id;
        public String Name;
        public Boolean IsPotential;
        public String Values;
        public Decimal ValueNumber;
        public Boolean Value;
        public String BusinessProcessId;
    }
}