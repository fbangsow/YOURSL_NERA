/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no
*/

@RestResource(urlMapping = '/POSData/*')

global class WsPosPageconfig implements WsPos {

  public static WsPosResponse  doReply(WsPosRequest request) {
    return new WsPosResponse ();
  }

  @HttpGet
  global static void wsGet() {

    //create Request
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    // do businesslogic
    Map<String, PageConfig__c> myPOSPages = getPOSPages();
    List<POSPageDataWrapper> dataSet =  getDataSet(myPOSPages);

    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(dataSet));
    RestContext.response.addHeader('size', String.valueOf(dataSet.Size()));
    RestContext.response.addHeader('Content-Type', 'application/json');
  }


  public static List<POSPageDataWrapper> getDataSet(Map<String, PageConfig__c> myPOSPages) {
    List<POSPageDataWrapper> dataSet = new List<POSPageDataWrapper>();

    Set<String> setPosPageIds = new Set<String> ();
    for (String posPageId : myPOSPages.keySet()) {
      setPosPageIds.add(posPageId);
    }

    Map<String, UIControl__c> mapPOIs = getPOIs(setPosPageIds);
    Set<String> setPoiIds = new Set<String> ();
    for (String poiId : mapPOIs.keySet()) {
      setPoiIds.add(poiId);
    }

    Map<String, POIHeader__c> mapPOIsHeaders = getPOIsHeaders(setPoiIds);
    Set<String> setPoiHeaderIds = new Set<String> ();
    for (String poiHeaderId : mapPOIsHeaders.keySet()) {
      setPoiHeaderIds.add(poiHeaderId);
    }
    Map<String, POIQuestion__c> mappoiQuestion = new  Map<String, POIQuestion__c>();
    Map<String, POIQuestion__c> mapPOIQuestions = getPOIAuditQuestions(setPoiIds);
    Set<String> setPoiQuestionIds = new Set<String> ();
    for (String poiQuestionId : mapPOIQuestions.keySet()) {
      setPoiQuestionIds.add(poiQuestionId);
    }
    for (POIQuestion__c poiQuestion : mapPOIQuestions.values()) {
      mappoiQuestion.put(poiQuestion.UIControl__r.Id, poiQuestion);
    }

    for (String posPageId : setPosPageIds) {
      POSPageDataWrapper myCurrentPosPage = new POSPageDataWrapper(myPOSPages.get(posPageId));
      List<POIWrapper> listPOI = new List<POIWrapper>();
      for (String poiId : mapPOIs.keySet()) {
        if (mappoiQuestion.containsKey(poiId)) {
          List<POIQuestionsWrapper> listPOIQuestions;
          POIWrapper poi = new POIWrapper(mapPOIs.get(poiId));
          if (poi.posPageId == posPageId) {
            listPOIQuestions = new List<POIQuestionsWrapper>();
            for (String poiHeaderId : mapPOIsHeaders.keySet()) {
              POIHeaderWrapper objPoiHeader = new POIHeaderWrapper(mapPOIsHeaders.get(poiHeaderId));
              if (objPoiHeader.poiId == poiId) {
                poi.poiHeader = objPoiHeader;
                break;
              }
            }

            for (String poiQuestionId : mapPOIQuestions.keySet()) {
              POIQuestionsWrapper poiQuestion = new POIQuestionsWrapper(mapPOIQuestions.get(poiQuestionId));
              if (poiQuestion.poiId == poiId  ) {
                listPOIQuestions.add(poiQuestion);
              }
            }
            poi.poiQuestions = listPOIQuestions;
            listPOI.add(poi);
          }
        }

      }

      myCurrentPosPage.pois = listPOI;
      dataSet.add(myCurrentPosPage);
    }
    return dataSet;
  }

  public static Map<String, PageConfig__c> getPOSPages() {
    //return new Map<String, PageConfig__c>([SELECT Id, Name, IsActive__c
    //                                       From  PageConfig__c ]);
    return new Map<String, PageConfig__c>([SELECT Id, Name, IsActive__c
                                           From  PageConfig__c
                                           WHERE IsActive__c = true and
                                               PageConfigTypeId__r.Name = 'POS']);
  }

  public class POSPageDataWrapper {
    public Id posPageConfigId;
    public String posPageConfigName;
    public String isActive {get; set;}
    public List<POIWrapper> pois {get; set;}

    public POSPageDataWrapper(PageConfig__c posPageConfig) {
      posPageConfigId = posPageConfig.Id;
      posPageConfigName = posPageConfig.Name;
      isActive = String.valueOf(posPageConfig.IsActive__c);
      pois = new List<POIWrapper>();
    }
  }

  public static Map<String, UIControl__c> getPOIs(Set<String> setPageConfigIds) {


    return new Map<String, UIControl__c>([SELECT  Id, Name,
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

  public class POIWrapper {
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
    public POIWrapper(UIControl__c poi) {
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

  public class POIHeaderWrapper {
    public Id poiHeaderId;
    public String poiHeaderName;
    public String poiId;
    public String poiName;
    public String poiHeaderTitle;
    public String poiHeadersubtitle;
    public String poiHeaderDescription;
    public String poiPopupHeaderImage;
    public POIHeaderWrapper(POIHeader__c poiHeader) {
      poiHeaderId = poiHeader.Id;
      poiHeaderName = poiHeader.Name;
      poiId = poiHeader.UIControl__r.Id;
      poiName = poiHeader.UIControl__r.Name;
      poiHeaderTitle = poiHeader.Name;
      poiHeaderDescription = poiHeader.Description__c;
      poiPopupHeaderImage = poiHeader.AttachmentId__c;
      poiHeadersubtitle = poiHeader.SubTitle__c;
    }
  }

  public static Map<String, POIHeader__c> getPOIsHeaders(Set<String> setPoiIds) {

    return new Map<String, POIHeader__c>([SELECT Id, Name, AttachmentId__c,SubTitle__c,
                                          Description__c,
                                          UIControl__r.Id,
                                          UIControl__r.Name
                                          FROM POIHeader__c
                                          WHERE UIControl__r.Id IN: setPoiIds]);
  }

  public static Map<String, POIQuestion__c> getPOIAuditQuestions(Set<String> setPoiIds) {

    return new Map<String, POIQuestion__c>([SELECT   Id, Name, IsMandatory__c,
                                            UIControl__r.Id,
                                            UIControl__r.Name,
                                            AuditQuestion__r.Id,
                                            AuditQuestion__r.AuditQuestionType__r.Name,
                                            AuditQuestion__r.MaximumValue__c,
                                            AuditQuestion__r.AuditQuestionType__r.Step__c,
                                            AuditQuestion__r.AuditQuestionType__r.Weightage__c,
                                            AuditQuestion__r.AuditQuestionType__r.HasWeightage__c,
                                            AuditQuestion__r.Description__c,
                                            AuditQuestion__r.Potential__c
                                            FROM POIQuestion__c
                                            WHERE UIControl__r.Id = : setPoiIds]);
  }

  public class POIQuestionsWrapper {
    public Id poiQuestionId;
    public String poiQuestionName;
    Public Boolean IsMandatory;
    public String poiId;
    // public String poipotential;
    public String poiName;
    public String questionTypeName;
    public Decimal questionTypeMinValue;
    public Decimal questionTypeMaxValue;
    public Decimal questionTypeStepValue;
    public String questionDecription;
    public String questionPotential;
    public Decimal questionTypeWeightage;
    public Boolean questionTypeHasWeightage;
    public POIQuestionsWrapper(POIQuestion__c poiQuestion) {
      poiQuestionId = poiQuestion.AuditQuestion__r.Id;
      poiQuestionName = poiQuestion.Name;
      IsMandatory = poiQuestion.IsMandatory__c;
      poiId = poiQuestion.UIControl__r.Id;
      poiName = poiQuestion.UIControl__r.Name;
      questionTypeName = poiQuestion.AuditQuestion__r.AuditQuestionType__r.Name;
      //questionTypeMinValue = poiQuestion.AuditQuestion__r.AuditQuestionType__r.MinimumValue__c;
      questionTypeMinValue = 0;
      //questionTypeMaxValue = poiQuestion.AuditQuestion__r.AuditQuestionType__r.MaximumValue__c;
      questionTypeMaxValue = poiQuestion.AuditQuestion__r.MaximumValue__c;
      questionTypeStepValue = poiQuestion.AuditQuestion__r.AuditQuestionType__r.Step__c;
      questionDecription = poiQuestion.AuditQuestion__r.Description__c;
      questionPotential = poiQuestion.AuditQuestion__r.Potential__c;
      questionTypeWeightage = poiQuestion.AuditQuestion__r.AuditQuestionType__r.Weightage__c;
      questionTypeHasWeightage = poiQuestion.AuditQuestion__r.AuditQuestionType__r.HasWeightage__c;
    }
  }
}