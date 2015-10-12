/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no 
*/

@RestResource(urlMapping = '/Potential/*')

global class WsposPotential implements WsPos {

  public static WsPosResponse  doReply(WsPosRequest request) {
    return new WsPosResponse ();
  }
  
  @HttpPost
  global static void wsPost() {
   // RestRequest req = RestContext.request;
RestRequest req = RestContext.request;
        String createAuditJsonRequest = EncodingUtil.urlDecode(RestContext.request.params.get('AuditResults'), 'UTF-8');
        System.debug('test params.........'+createAuditJsonRequest);
        //System.debug('test params.........'+EncodingUtil.urlDecode(createAuditJsonRequest, 'UTF-8'));
        //Deserailze data
        //Potential orderInfo = (OrderInformation)JSON.deserialize(createEventsJsonRequest, OrderInformation.class);
       // Potential jsonwrap = (Potential) System.JSON.deserialize(createEventsJsonRequest, AuditResults.class);
       AuditResult jsonwrap = (AuditResult) System.JSON.deserialize(createAuditJsonRequest, AuditResult.class);
       system.debug('...........testjsonwrap.........'+jsonwrap);
        //String orderId = WsOrders.insertOrder(orderInfo);
        String auditid =WsposPotential.insertAuditResult(jsonwrap,jsonwrap.Potentials,jsonwrap.AuditAnswers);
 //String auditid ='';
          RestContext.response.responseBody = Blob.valueOf(JSON.serialize(auditid));
          RestContext.response.addHeader('Content-Type', 'application/json');

        //RestContext.response.responseBody = Blob.valueOf(JSON.serialize(orderId));
        //RestContext.response.addHeader('Content-Type', 'application/json');



    //Blob body = req.requestBody;
    //String bodyString = body.toString();

   // Potential jsonwrap = (Potential) System.JSON.deserialize(createEventsJsonRequest, Potential.class);
    //System.debug('.........jsonwrap.......'+jsonwrap.Potentials[0].ProductId);

    //String auditid= insertAuditResult(jsonwrap,jsonwrap.Potentials);
    //RestContext.response.responseBody = Blob.valueOf(JSON.serialize(auditid));
    //RestContext.response.addHeader('Content-Type', 'application/json');
  }

  // Added by Parasuram on 07/08/2015
  // To get user related Account potentials
  @HttpGet
  global static void wsGet() {
    // do businesslogic
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    if(myRequest.resquestedByUser != null){    
      System.debug('RequestedUserId........'+myRequest.resquestedByUser.Id);
      System.debug('RequestedUserName........'+myRequest.resquestedByUser.Name);
      Map<String, AuditResult__c>  mapAccountAuditResults=getAccountAuditResults(myRequest.resquestedByUser.Id);
      List<AccountAuditWrapper> listAccountAuditWrapper=getDataSet(mapAccountAuditResults);
      RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listAccountAuditWrapper));
      RestContext.response.addHeader('size', String.valueOf(listAccountAuditWrapper.Size()));
    }
    else{
      RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
      RestContext.response.statusCode = myRequest.statusCode;
      //RestContext.response.addHeader('Content-Type', 'application/json');
    }
    RestContext.response.addHeader('Content-Type', 'application/json');
  }

  

public static List<AccountAuditWrapper> getDataSet(Map<String, AuditResult__c> myAuditResult) {
List<AccountAuditWrapper> listAccountAudit= new List<AccountAuditWrapper>();
    Map<String, PosPotential__c> mapAuditPotentials=getAuditPotentails();
    for(AuditResult__c objAuditResult : myAuditResult.values())
    {
    List<AuditRestultsWrapper> listAuditResults=new  List<AuditRestultsWrapper>();
    AccountAuditWrapper objAccountAuditWrapper=new AccountAuditWrapper(objAuditResult.AccountId__c);
    for(AuditResult__c auditResult : myAuditResult.values())
    {
      AuditRestultsWrapper objAuditResults=new AuditRestultsWrapper(auditResult);
      List<PotentialWrapper> listPotentials=new  List<PotentialWrapper>();
      for(PosPotential__c objPotential:mapAuditPotentials.values())
      {   
        PotentialWrapper potential;
        if(objPotential.AuditResult__c==auditResult.Id)
        {
          potential=new PotentialWrapper(objPotential);
          listPotentials.Add(potential);
        }
      }
      objAuditResults.Potentials=listPotentials;
      listAuditResults.add(objAuditResults);
      system.debug('...........'+listAuditResults);
    }
    objAccountAuditWrapper.AuditRestults=listAuditResults;
    }
    return listAccountAudit;

  }


   public class AccountAuditWrapper{
    public String accountId{get; set;}
    public List<AuditRestultsWrapper> AuditRestults{get; set;}
    public AccountAuditWrapper(String accountId){
      this.accountId = accountId;
      AuditRestults=new List<AuditRestultsWrapper>();
    }
  }

public static Map<String, AuditResult__c> getAccountAuditResults(String userId) {
return new Map<String, AuditResult__c>([SELECT Id,Name,AccountId__c,
                                              EventId__c,Potential__c,
                                              Score__c
                                        FROM AuditResult__c 
                                        WHERE AccountId__r.OwnerId =: userId
                                        order by AccountId__c, LastModifiedDate desc]);
}

public static Map<String, PosPotential__c> getAuditPotentails() {
return new Map<String, PosPotential__c>([SELECT Id,Name,
                                                PotentialType__c,ProductId__c,
                                                AuditResult__c 
                                         FROM PosPotential__c]);
}

  public class AuditRestultsWrapper
  {  
  public String accountId{get; set;}
  public Decimal Score{get; set;}
  public String  EventId{get; set;}
  public List<PotentialWrapper> Potentials {get; set;}
  public AuditRestultsWrapper(AuditResult__c audits)
  {
   this.accountId=audits.AccountId__c;
   this.Score=audits.Score__c;
   this.EventId=audits.EventId__c;
   Potentials=new List<PotentialWrapper>();
  }
}

public class PotentialWrapper{
   public String potentialId{get; set;}
    public String product2Id{get; set;}
    public String potentialType{get; set;}   
    public PotentialWrapper(PosPotential__c potential){
      this.product2Id = potential.ProductId__c;
      this.potentialId = potential.Id;
      this.potentialType = potential.PotentialType__c;
    }
  }


 public static String insertAuditResult(AuditResult auditresultData,List<cls_Potentials> Potentials,
                                          List<cls_AuditAnswers> auditAnswers){

        AuditResult__c audit  = new AuditResult__c();
        audit.EventId__c =auditresultData.EventId;
        audit.AccountId__c = auditresultData.AccountId;
        //Audit.ProductId__c= auditresultData.productId;
        audit.Score__c= auditresultData.Score;
        insert audit;

        List<PosPotential__c> listPotentials = new List<PosPotential__c>();
        for(cls_Potentials potential : Potentials){
          PosPotential__c pos = new PosPotential__c ();
          if(potential.ProductId <> null && potential.ProductId <> ''){
            pos.ProductId__c = potential.ProductId;
          }else{
            pos.ProductId__c = null;
          }       
          pos.AuditResult__c = audit.Id;
          pos.PotentialType__c = potential.Type;
          listPotentials.add(pos);
        }
        
        if(!listPotentials.isEmpty())
          insert listPotentials;

        Map<String, string> mapAudiotQuestionTypes=getAuditQuestionTypes();


        List<AuditAnswer__c> listAuditAnswers = new List<AuditAnswer__c>();
        List<AuditProductAnswer__c> listAuditProductAnswers = new List<AuditProductAnswer__c>();
        for(cls_AuditAnswers auditAnswerWrapper : auditAnswers){
          system.debug('auditAnswerWrapper.QuestionId---------------'+auditAnswerWrapper.QuestionId);
          if(mapAudiotQuestionTypes.get(auditAnswerWrapper.QuestionId)=='Beverage' || mapAudiotQuestionTypes.get(auditAnswerWrapper.QuestionId)=='Cooler')
          //if(!mapAudiotQuestionTypes.containsKey(auditAnswerWrapper.QuestionId))
          {
                system.debug('QuestionId------------------------'+auditAnswerWrapper.QuestionId);
                system.debug('-------------Inside If loop-----------');
                for(cls_ChosenProducts choseProduct : auditAnswerWrapper.chosenproducts){
                    AuditProductAnswer__c auditProductAnswer = new AuditProductAnswer__c ();
                    auditProductAnswer.Quantity__c = choseProduct.Quantity;
                    auditProductAnswer.Availability__c = choseProduct.AvailabilityStatus;
                    auditProductAnswer.Facing__c = String.valueOf(choseProduct.FacingValue);
                    auditProductAnswer.Price__c = choseProduct.SellingPrice;
                    auditProductAnswer.AuditResultId__c = audit.Id;
                    auditProductAnswer.AuditQuestionId__c = auditAnswerWrapper.QuestionId;
                    auditProductAnswer.ProductId__c = choseProduct.CrmId;
                
                listAuditProductAnswers.add(auditProductAnswer);
                }               
              }
          else
          {
             system.debug('-------------Inside Else loop-----------');
              AuditAnswer__c auditAnswer = new AuditAnswer__c ();

              auditAnswer.AuditResultId__c = audit.Id;
              if(auditAnswerWrapper.Text != null && auditAnswerWrapper.Text != ''){
                   auditAnswer.Name = auditAnswerWrapper.Text;
               }
              else if(auditAnswerWrapper.Value != 0){
                auditAnswer.Name = String.valueOf(auditAnswerWrapper.Value);
                }
              //---Need to correct json data for text filed // because it is creating as saparate class 
              else{
                auditAnswer.Name = String.valueOf(auditAnswerWrapper.IsSelected);
                }

              auditAnswer.AuditQuestionId__c = auditAnswerWrapper.QuestionId;

              //auditAnswer.AvailabilityStatus = auditAnswerWrapper.

              listAuditAnswers.add(auditAnswer);
          }        
        
        }
        
        if(!listAuditProductAnswers.isEmpty())
          insert listAuditProductAnswers;

        if(!listAuditAnswers.isEmpty())
          insert listAuditAnswers;


       System.debug('Potentials----------------'+Potentials);

return audit.id;

}

public static Map<String, String> getAuditQuestionTypes() {
Map<String, AuditQuestionType__c> auidMap =  new Map<String, AuditQuestionType__c> ([SELECT Id,Name FROM AuditQuestionType__c]);
    Map<String, String> auditQuestionMap = getAuditQuestions(auidMap.keySet());
return auditQuestionMap;
}

public static Map<String, String> getAuditQuestions(Set<String> questionId) {
    Map<String, String> questionIdList = new Map<String, String>();
    for(AuditQuestion__c qa : [SELECT Id,Name,AuditQuestionType__c,AuditQuestionType__r.Name FROM AuditQuestion__c  WHERE AuditQuestionType__c IN: questionId]){
        questionIdList.put(qa.Id,qa.AuditQuestionType__r.Name);
    }
    return questionIdList;
}


///Post wrapper///



public class AuditResult{
  public String AccountId;  
  public String EventId;  
  public Double Score;  
  public String AuditId;  
  public cls_Potentials[] Potentials;
  public cls_AuditAnswers[] AuditAnswers;
  
}
class cls_Potentials {
  public String Description;  
  public Integer Quantity;  
  public String Type; 
  public String ProductId;  
  public String AuditId;  
}
public class cls_AuditAnswers {
  public String AuditId;  
  public String QuestionId; 
  public String PoiId;  
  public String CoolerId; 
  public boolean IsSelected;
  public Decimal Value; 
  public cls_ChosenProducts[] ChosenProducts;
  public String Text;
}
public class cls_Text {
}
public class cls_ChosenProducts {
  public String Description;  
  public String CrmId;  
  public boolean IsSelected;
  public Integer Quantity;  
  public String AvailabilityStatus; 
  public Integer FacingValue; 
  public Integer PerpendicularFacingValue;  
  public Decimal SellingPrice;  
}
  
  }