/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no
*/

@RestResource(urlMapping = '/SurveyExecutionData/*')

global class WsPosPageconfig implements WsPos{

  public static WsPosResponse  doReply(WsPosRequest request){
    return new WsPosResponse ();
  }

  @HttpGet
  global static void wsGet(){

    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    Map<Id, PageConfig__c> myPOSPages = getPOSPages();
    List<POSPageDataWrapper> dataSet =  getDataSet(myPOSPages);

    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(dataSet));
    RestContext.response.addHeader('size', String.valueOf(dataSet.Size()));
    RestContext.response.addHeader('Content-Type', 'application/json');
  }

  public static List<POSPageDataWrapper> getDataSet(Map<Id, PageConfig__c> myPOSPages){

    List<POSPageDataWrapper> dataSet = new List<POSPageDataWrapper>();
    Map<Id, UIControl__c> mapPOIs = getPOIs(myPOSPages.keySet());
    Map<Id, POIHeader__c> mapPOIsHeaders = getPOIsHeaders(mapPOIs.keySet());
    Map<Id, POIQuestion__c> mapPOIQuestions = getPOIAuditQuestions(mapPOIs.keySet());

    for (Id posPageId : myPOSPages.keySet()){
      POSPageDataWrapper myCurrentPosPage = new POSPageDataWrapper(myPOSPages.get(posPageId));
      List<POIWrapper> listPOI = new List<POIWrapper>();
      for (Id poiId : mapPOIs.keySet()){
        List<POIQuestionsWrapper> listPOIQuestions;
        POIWrapper poi = new POIWrapper(mapPOIs.get(poiId));
        if (poi.posPageId == posPageId){
          listPOIQuestions = new List<POIQuestionsWrapper>();
          for (Id poiHeaderId : mapPOIsHeaders.keySet()){
            POIHeaderWrapper objPoiHeader = new POIHeaderWrapper(mapPOIsHeaders.get(poiHeaderId));
            if (objPoiHeader.poiId == poiId){
              poi.poiHeader = objPoiHeader;
              break;
            }
          }

          for (Id poiQuestionId : mapPOIQuestions.keySet()){
            POIQuestionsWrapper poiQuestion = new POIQuestionsWrapper(mapPOIQuestions.get(poiQuestionId));
            if (poiQuestion.poiId == poiId) {
              listPOIQuestions.add(poiQuestion);
            }
          }
          poi.poiQuestions = listPOIQuestions;
          listPOI.add(poi);
        }
      }
      myCurrentPosPage.pois = listPOI;
      dataSet.add(myCurrentPosPage);
    }
    return dataSet;
  }

  public static Map<Id, PageConfig__c> getPOSPages(){

    return new Map<Id, PageConfig__c>([SELECT Id, Name, IsActive__c
                                           From  PageConfig__c
                                           WHERE IsActive__c = true and
                                               PageConfigTypeId__r.Name = 'POS']);
  }

  public class POSPageDataWrapper{

    public Id posPageConfigId;
    public String posPageConfigName;
    public String isActive {get; set;}
    public List<POIWrapper> pois {get; set;}

    public POSPageDataWrapper(PageConfig__c posPageConfig){

      posPageConfigId = posPageConfig.Id;
      posPageConfigName = posPageConfig.Name;
      isActive = String.valueOf(posPageConfig.IsActive__c);
      pois = new List<POIWrapper>();
    }
  }

  public static Map<Id, UIControl__c> getPOIs(Set<Id> setPageConfigIds){

    return new Map<Id, UIControl__c>([SELECT  Id, Name,
                                                  Image__c,
                                                  PageConfigName__r.Id,
                                                  PageConfigName__r.Name,
                                                  POIType__r.Id,
                                                  POIType__r.Name,
                                                  POIType__r.HasWeightage__c,
                                                  POIType__r.Weightage__c,
                                                  POIType__r.AttachmentId__c,
                                                  UIControlTypeId__r.Name
                                          From UIControl__c
                                          WHERE PageConfigName__r.Id IN: setPageConfigIds and
                                          UIControlTypeId__r.Name = 'POI']);
  }

  public class POIWrapper{

    public Id poiId;
    public String poiName;
    public String posPageId;
    public String posPageName;
    public String poiTypeId;
    public String poiTypeName;
    public Boolean poiTypeHasWeightage;
    public Decimal poiTypeWeightage;
    public POIHeaderWrapper poiHeader;
    public List<POIQuestionsWrapper> poiQuestions;

    public POIWrapper(UIControl__c poi){

      poiId = poi.Id;
      poiName = poi.Name;
      posPageId = poi.PageConfigName__r.Id;
      posPageName = poi.PageConfigName__r.Name;
      poiTypeId = poi.POIType__r.Id;
      poiTypeName = poi.POIType__r.Name;
      poiTypeHasWeightage = poi.POIType__r.HasWeightage__c;
      poiTypeWeightage = poi.POIType__r.Weightage__c;
    }
  }

  public class POIHeaderWrapper{
  
    public Id poiHeaderId;
    public String poiHeaderName;
    public String poiId;
    public String poiName;
    public String poiHeaderTitle;
    public String poiHeaderDescription;
    public String poiPopupHeaderImage;

    public POIHeaderWrapper(POIHeader__c poiHeader){

      poiHeaderId = poiHeader.Id;
      poiHeaderName = poiHeader.Name;
      poiId = poiHeader.UIControl__r.Id;
      poiName = poiHeader.UIControl__r.Name;
      poiHeaderTitle = poiHeader.Name;
      poiHeaderDescription = poiHeader.Description__c;
      poiPopupHeaderImage = poiHeader.AttachmentId__c;
    }
  }

  public static Map<Id, POIHeader__c> getPOIsHeaders(Set<Id> setPoiIds){

    return new Map<Id, POIHeader__c>([SELECT Id, Name, AttachmentId__c,
                                                 Description__c,
                                                 UIControl__r.Id,
                                                 UIControl__r.Name
                                          FROM POIHeader__c
                                          WHERE UIControl__r.Id IN: setPoiIds]);
  }

  public static Map<Id, POIQuestion__c> getPOIAuditQuestions(Set<Id> setPoiIds){

    return new Map<Id, POIQuestion__c>([SELECT  Id, Name, IsMandatory__c,
                                                    UIControl__r.Id,
                                                    UIControl__r.Name,
                                                    AuditQuestion__r.Id,
                                                    AuditQuestion__r.AuditQuestionType__r.Name,
                                                    AuditQuestion__r.AuditQuestionType__r.MinimumValue__c,
                                                    AuditQuestion__r.AuditQuestionType__r.MaximumValue__c,
                                                    AuditQuestion__r.AuditQuestionType__r.Step__c,
                                                    AuditQuestion__r.AuditQuestionType__r.Weightage__c,
                                                    AuditQuestion__r.AuditQuestionType__r.HasWeightage__c,
                                                    AuditQuestion__r.Description__c,
                                                    AuditQuestion__r.Potential__c
                                            FROM POIQuestion__c
                                            WHERE UIControl__r.Id =: setPoiIds]);
  }

  public class POIQuestionsWrapper{

    public Id poiQuestionId;
    public String poiQuestionName;
    public Boolean isMandatory;
    public String poiId;
    public String poiName;
    public String questionTypeName;
    public Decimal questionTypeMinValue;
    public Decimal questionTypeMaxValue;
    public Decimal questionTypeStepValue;
    public String questionDecription;
    public String questionPotential;
    public Decimal questionTypeWeightage;
    public Boolean questionTypeHasWeightage;

    public POIQuestionsWrapper(POIQuestion__c poiQuestion){
   
      poiQuestionId = poiQuestion.AuditQuestion__r.Id;
      poiQuestionName = poiQuestion.Name;
      isMandatory = poiQuestion.IsMandatory__c;
      poiId = poiQuestion.UIControl__r.Id;
      poiName = poiQuestion.UIControl__r.Name;
      questionTypeName = poiQuestion.AuditQuestion__r.AuditQuestionType__r.Name;
      questionTypeMinValue = poiQuestion.AuditQuestion__r.AuditQuestionType__r.MinimumValue__c;
      questionTypeMaxValue = poiQuestion.AuditQuestion__r.AuditQuestionType__r.MaximumValue__c;
      questionTypeStepValue = poiQuestion.AuditQuestion__r.AuditQuestionType__r.Step__c;
      questionDecription = poiQuestion.AuditQuestion__r.Description__c;
      questionPotential = poiQuestion.AuditQuestion__r.Potential__c;
      questionTypeWeightage = poiQuestion.AuditQuestion__r.AuditQuestionType__r.Weightage__c;
      questionTypeHasWeightage = poiQuestion.AuditQuestion__r.AuditQuestionType__r.HasWeightage__c;
    }
  }
}