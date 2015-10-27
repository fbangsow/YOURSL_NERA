/*
@Company: YOUR SL
@Author: Ravi AND Sunny
@Creation date:
@Ref:
*/
public with sharing class CtrlPOSAppBuilder {

  public static List<AppSettings__c> listappsettings {get; set;}
  public static List<MobileDevice__c> listMobileDevices {get; set;}
  public static List<AuditQuestionType__c> listAuditQuestionTypes {get; set;}
  public String pageConfigName {get; set;}
  public static PageConfig__c pagecon {get; set;}
  public static UIControl__c uIControls {get; set;}
  public String uIControlid {get; set;}
  public static List<POIType__c> listPOIType {get; set;}
  public String appsettingsid {get; set;}
  public String poitypeid {get; set;}
  public static List<Businessprocess__c> listbprocessparameters {get; set;}
  public static List<POIHeader__c> listPOIheader {get; set;} 
  public static List<UIControlType__c> listUIcontroltype {get; set;}
  public static List<PageConfigType__c> listPageConfigType {get; set;}
  
  // passing appsettings id to get the pageconfigs
  @RemoteAction
  public static String getPosList(String appsettingsid){

    listappsettings = [SELECT id, name, mobileDevice__r.attachmentId__c,
                       (SELECT id, name, attachmentId__c, createdBy.name, pageConfigTypeId__c, createdDate
                        FROM PageConfigs__r WHERE PageConfigTypeId__r.Name = 'POS')
                        FROM AppSettings__c WHERE id = :appsettingsid];
    String appsettJSON = JSON.serializePretty(listappsettings);

    return appsettJSON;
  }

  // Based on the appsettings get a mobiledevice
   @RemoteAction
  public static String getMobileDeviceList(){

    listappsettings = [SELECT id, name, mobileDevice__r.attachmentId__c, mobileDevice__r.height__c, mobileDevice__r.width__c, mobileDevice__r.xBezel__c,
                          mobileDevice__r.yBezel__c, mobileDevice__r.xFrame__c, mobileDevice__r.yFrame__c
                          FROM AppSettings__c LIMIT 50000];
                         
    String mobileDevJSON = JSON.serializePretty(listappsettings);

    return mobileDevJSON;
  }
    // get a uicontroltypeid
  @RemoteAction
  public static String getUicontroltypeid(){

    listUIcontroltype = [SELECT id, name FROM UIControlType__c WHERE Name=:'POI'];
    String uitypejson = JSON.serializePretty(listUIcontroltype);

    return uitypejson;
  }
  // get a PageConfigTypeId
  @RemoteAction
  public static String getPageConfigTypeId(){

    listPageConfigType = [SELECT id, name FROM PageConfigType__c WHERE Name=:'POS'];
    String uiPageconfigTypejson = JSON.serializePretty(listPageConfigType);

    return uiPageconfigTypejson;
  }
  //list of poitypes
  @RemoteAction
  public static String getPOITypeList(){

    listPOIType = [SELECT id, name, attachmentId__c, (SELECT id, name FROM attachments) FROM POIType__c LIMIT 50000];
    String pOITypeListJSON = JSON.serializePretty(listPOIType);

    return pOITypeListJSON;
  }

  //passing the poitype id to get attachment name
  @RemoteAction
  public static String getPOITypeListattname(String poitypeid){

    listPOIType = [SELECT id, name, attachmentId__c, (SELECT id, name FROM attachments) FROM POIType__c WHERE id = :poitypeid];
    String pOITypeListJSON = JSON.serializePretty(listPOIType);

    return pOITypeListJSON;
  }

  //List of auditquestions 
  @RemoteAction
  public static String getAuditQuestionTypeList() {

    listAuditQuestionTypes = [SELECT id, name, (SELECT id, name FROM AuditQuestions__r)
                              FROM AuditQuestionType__c LIMIT 50000];
    String auditQuestionTypesJSON = JSON.serializePretty(listAuditQuestionTypes);

    return auditQuestionTypesJSON;

  }

  // passing pageconfigid to get uicontrols
  @RemoteAction
  public static String getpageconfigUIcon(String pageConfigName){

    pageCon = [SELECT id, name, backGround_Color__c, attachmentId__c, width__c, height__c, yCoordinate__c, xCoordinate__c, pageConfigTypeId__r.name,
               (SELECT id, name, height__c, width__c, xCoordinate__c, yCoordinate__c, type__c, attachmentId__c, poiIconImageId__c, createdBy.name, pOIType__c, createdDate, uIControlTypeId__c FROM UIControls__r WHERE uIControlTypeId__r.Name = 'POI'),
               (SELECT id, name FROM attachments)
               FROM PageConfig__c WHERE id = :pageConfigName];
    String uiControlsJSON = JSON.serializePretty(pageCon);

    return uiControlsJSON;
  }
  
  // passing uicontrolid to get POIQuestion,PosHeader,POIBusinessMember
  @RemoteAction
  public static String getPOIQuestions(String uIControlid){

    uIControls = [SELECT id, name, pOIType__r.name, pOIType__r.attachmentId__c,uIControlTypeId__c, 
                  (SELECT name, id, auditQuestion__r.description__c, auditQuestion__r.potential__c, uIControl__r.name, uIControl__r.id, auditQuestion__r.auditQuestionType__r.name, auditQuestion__r.id, isMandatory__c, auditQuestion__r.maximumValue__c FROM POIQuestions__r),
                  (SELECT id, name FROM attachments),
                  (SELECT id, name, uIControl__r.id, description__c, attachmentId__c FROM PosHeaders__r),
                  (SELECT id, name, uIControl__r.id, filter__c FROM POIBusinessMembers__r)
                  FROM UIControl__c WHERE id = :uIControlid ];

    String uIControlsJSON = JSON.serializePretty(uIControls);

    return uIControlsJSON;
  }

  //get the BusinessProcessParameters
  @remoteaction
  public Static String getBProcessParameters(){

    listbprocessparameters = [SELECT id, name, (SELECT id, name FROM BusinessProcessParameters__r) 
                                                FROM Businessprocess__c WHERE name = 'POIvisibility'];
    String bbprocessJSON = JSON.serializePretty(listbprocessparameters);

    return bbprocessJSON;

  }
  @RemoteAction
  public static String getpoiheaderattIcon(String uiControlId) {
   

      listPOIheader = [Select Id,UIControl__c ,AttachmentId__c,(Select Id, Name FROM attachments) 
                                                        FROM POIHeader__c  Where UIControl__c = :uiControlId];
      String poiheaderjson = JSON.serializePretty(listPOIheader);
      return poiheaderjson;
          
  }

  //insert and update the pageconfig 
  @RemoteAction
  public static void insertDataPOS(String jsondata){

    InsertWrapperjson listposwrapper = new InsertWrapperjson();
    JSONParser parser = JSON.createParser(jsondata);
    while (parser.nextToken() != null){
      if (parser.getCurrentToken() == JSONToken.START_ARRAY){
        while (parser.nextToken() != null){

          if (parser.getCurrentToken() == JSONToken.START_OBJECT){

            InsertWrapperjson jsoncls = (InsertWrapperjson) parser.readValueAs(InsertWrapperjson.class);
            listposwrapper.name = jsoncls.name;
            listposwrapper.blobdata = jsoncls.blobdata;
            listposwrapper.mobiledeviceid = jsoncls.mobiledeviceid;
            listposwrapper.posattname = jsoncls.posattname;
            listposwrapper.pageConfigID = jsoncls.pageConfigID;
            listposwrapper.pageConfigTypeId = jsoncls.pageConfigTypeId;
            listposwrapper.appsettingid = jsoncls.appsettingid;

            parser.skipChildren();
          }
        }
      }
    }

    PageConfig__c pageconfig = new PageConfig__c();

    if (listposwrapper.pageConfigID != null){
      pageconfig.name = listposwrapper.name;
      pageconfig.id = listposwrapper.pageConfigID;
    } else {
      pageconfig.name = listposwrapper.name;
      pageconfig.pageConfigTypeId__c = listposwrapper.pageConfigTypeId;
      pageconfig.appSetting__c = listposwrapper.appsettingid;
    }
    upsert pageconfig;
    

    Attachment attachment = new Attachment();

    if (listposwrapper.posattname != null ){

      if (listposwrapper.pageConfigID != null){
        attachment.id = [SELECT id FROM Attachment WHERE parentId = :listposwrapper.pageConfigID].id;
        attachment.name = listposwrapper.posattname;
        attachment.body = listposwrapper.blobdata;
      } else {
        attachment.parentId = pageconfig.Id;
        attachment.name = listposwrapper.posattname;
        attachment.body = listposwrapper.blobdata;
      }
      upsert attachment;

      pageconfig.AttachmentId__c = attachment.ID;
      update pageconfig;
    }
  }

  //upadte uicontrol xy-coordinates
  @RemoteAction
  public static void uiconxyupdate(String jsondatafordata){

    List<jSONUicontrols> lstJSONUicon = new List<jSONUicontrols>();
    JSONParser parserui = JSON.createParser(jsondatafordata);
    while (parserui.nextToken() != null){
      if (parserui.getCurrentToken() == JSONToken.START_ARRAY){
        while (parserui.nextToken() != null){

          if (parserui.getCurrentToken() == JSONToken.START_OBJECT){

            jSONUicontrols jsonclsui = (jSONUicontrols)parserui.readValueAs(jSONUicontrols.class);
            lstJSONUicon.add(jsonclsui);
            parserui.skipChildren();
          }
        }
      }
    }

    List<UIControl__c> lstUIcontrols = new  List<UIControl__c>();

    Map<String, UIControl__c> mapStringUIControlId = new  Map<String, UIControl__c>();

    for (jSONUicontrols rec : lstJSONUicon){

      UIControl__c uicon = new UIControl__c();

      if (rec.uiconid != null && rec.uiconid != ''){
        uicon.id = rec.uiconid;
        uicon.xCoordinate__c = decimal.valueof(rec.xaxisi);
        uicon.yCoordinate__c = decimal.valueof(rec.yaxiss);
        mapStringUIControlId.put(Uicon.id, Uicon);
      }

    }

    if (!mapStringUIControlId.values().isempty())
      upsert mapStringUIControlId.values();

  }

  //insert and update the AuditQuestions,POIQuestions
  @RemoteAction
  public static void insertNewpoiion(String jsondata){

    QuestionWrapper insertQuestionType = new QuestionWrapper();
    JSONParser parser = JSON.createParser(jsondata);
    system.debug('fgggg'+parser);
    while (parser.nextToken() != null){
      if (parser.getCurrentToken() == JSONToken.START_ARRAY){
        while (parser.nextToken() != null){

          if (parser.getCurrentToken() == JSONToken.START_OBJECT){

            QuestionWrapper questionwrapperjson = (QuestionWrapper) parser.readValueAs(QuestionWrapper.class);
            insertQuestionType.question = questionwrapperjson.question;
            insertQuestionType.potential = questionwrapperjson.potential;
            insertQuestionType.potentialupdate = questionwrapperjson.potentialupdate;
            insertQuestionType.uiid = questionwrapperjson.uiid;
            insertQuestionType.pagecongfigid = questionwrapperjson.pagecongfigid;
            insertQuestionType.questiontypenew = questionwrapperjson.questiontypenew;
            insertQuestionType.questionid = questionwrapperjson.questionid;
            insertQuestionType.questionupdate = questionwrapperjson.questionupdate;
            insertQuestionType.poiquestionid = questionwrapperjson.poiquestionid;
            insertQuestionType.questionMandotary = questionwrapperjson.questionMandotary;
            insertQuestionType.questionSlider = questionwrapperjson.questionSlider;
            parser.skipChildren();
          }
        }
      }

    }

    AuditQuestion__c auditqustion = new AuditQuestion__c();

    if (insertQuestionType.questionid != null){
      auditqustion.id = insertQuestionType.questionid;
      auditqustion.description__c = insertQuestionType.questionupdate;
      auditqustion.potential__c = insertQuestionType.potentialupdate;
      auditqustion.auditQuestionType__c = insertQuestionType.questiontypenew;
      auditqustion.maximumValue__c = insertQuestionType.questionSlider;

    } else {
      auditqustion.description__c = insertQuestionType.question;
      auditqustion.potential__c = insertQuestionType.potential;
      auditqustion.auditQuestionType__c = insertQuestionType.questiontypenew;
      auditqustion.maximumValue__c = insertQuestionType.questionSlider;
    }

    upsert auditqustion;

    POIQuestion__c objpostion = new POIQuestion__c();

    if (insertQuestionType.poiquestionid != null){
      system.debug('dadada' + insertQuestionType.poiquestionid);
      objpostion.name = insertQuestionType.questionupdate;
      objpostion.auditQuestion__c = insertQuestionType.questionid;
      objpostion.uIControl__c = insertQuestionType.uiid;
      objpostion.id = insertQuestionType.poiquestionid;
      objpostion.isMandatory__c = insertQuestionType.questionMandotary;


      update objpostion;

    } else {
      objpostion.auditQuestion__c = auditqustion.id;
      objpostion.name = insertQuestionType.question;
      objpostion.uIControl__c = insertQuestionType.uiid;
      objpostion.isMandatory__c = insertQuestionType.questionMandotary;

      insert objpostion;
    }

  }

  //delete POIQuestions,AuditQuestions 
  @RemoteAction
  public static void deletequestions(String jsonquestiondelete){

    DeleteWrapperQustionjson deleteNewpointInterset = new DeleteWrapperQustionjson();
    JSONParser parser = JSON.createParser(jsonquestiondelete);
    while (parser.nextToken() != null) {
      if (parser.getCurrentToken() == JSONToken.START_ARRAY){
        while (parser.nextToken() != null){

          if (parser.getCurrentToken() == JSONToken.START_OBJECT){


            DeleteWrapperQustionjson deltewrapperjson = (DeleteWrapperQustionjson) parser.readValueAs(DeleteWrapperQustionjson.class);

            deleteNewpointInterset.questionid = deltewrapperjson.questionid;
            deleteNewpointInterset.poiquestionid = deltewrapperjson.poiquestionid;
            parser.skipChildren();
          }
        }
      }
    }
    POIQuestion__c listPOIQuestion = new POIQuestion__c();
    listPOIQuestion.id = deleteNewpointInterset.poiquestionid;
    listPOIQuestion.AuditQuestion__c = listPOIQuestion.id;
    delete listPOIQuestion;

    AuditQuestion__c listquestion = new AuditQuestion__c();
    listquestion.Id = deleteNewpointInterset.questionid;
    delete listquestion;

  }

  //delete uicontrol,POIHeader,POIQuestion,AuditQuestion 
  @RemoteAction
  public Static void deleteUicontrols(String deletepoijsondata){

    DeleteUicontrolsWrapperjson deleteobjulconrollwrapper = new DeleteUicontrolsWrapperjson();
    JSONParser parser = JSON.createParser(deletepoijsondata);
    while (parser.nextToken() != null){
      if (parser.getCurrentToken() == JSONToken.START_ARRAY){
        while (parser.nextToken() != null){

          if (parser.getCurrentToken() == JSONToken.START_OBJECT){


            DeleteUicontrolsWrapperjson deleteuiwrapper = (DeleteUicontrolsWrapperjson) parser.readValueAs(DeleteUicontrolsWrapperjson.class);
            deleteobjulconrollwrapper.uiid = deleteuiwrapper.uiid;
            deleteobjulconrollwrapper.poiquestionid = deleteuiwrapper.poiquestionid;
            deleteobjulconrollwrapper.questionid = deleteuiwrapper.questionid;
            deleteobjulconrollwrapper.poiheaderid = deleteuiwrapper.poiheaderid;


            parser.skipChildren();
          }
        }
      }
    }
    List<POIHeader__c>poiheder = new List<POIHeader__c>();
    List<POIQuestion__c>poiqustions = new List<POIQuestion__c>();
    List<POIBusinessMember__c> poiBusinessmember = new List<POIBusinessMember__c>();
    List<AuditResult__c> poiAuditResult = new List<AuditResult__c>();
    List<UIControl__c>   listUIControl = [SELECT Id,
                                          (SELECT Id, Name FROM PosHeaders__r),
                                          (SELECT Id, Name FROM POIQuestions__r),
                                          (SELECT Id FROM POIBusinessMembers__r),
                                          (SELECT Id FROM AuditResults__r)
                                          FROM  UIControl__c WHERE Id = :deleteobjulconrollwrapper.uiid];

    if (listUIControl != null && !listUIControl.isEmpty()){

      for (UIControl__c objUICon : listUIControl){

        if (!objUICon.PosHeaders__r.isEmpty()){
          poiheder.add(objUICon.PosHeaders__r);
        }
        if (!objUICon.POIQuestions__r.isEmpty()){
          poiqustions.addAll(objUICon.POIQuestions__r);
        }
        if (!objUICon.POIBusinessMembers__r.isEmpty()){     
          poiBusinessmember.addAll(objUICon.POIBusinessMembers__r);     
        }
        if (!objUICon.AuditResults__r.isEmpty()){     
          poiAuditResult.addAll(objUICon.AuditResults__r);     
        }

      }
    }

    Set<Id> idAuditQuestin = new Set<Id>();
    List<POIQuestion__c> lisPOIQuestions = [Select Id, name , uIControl__c, auditQuestion__c  FROM POIQuestion__c  WHERE Id IN :poiqustions];
    
    for (POIQuestion__c objPOIQuest : lisPOIQuestions){
      idAuditQuestin.add(objPOIQuest.AuditQuestion__c);
    }
    
    List<AuditQuestion__c> objAuditQuestion = [SELECT Id FROM AuditQuestion__c WHERE Id IN :idAuditQuestin];
    if (!objAuditQuestion.isEmpty()){
      Database.Delete(objAuditQuestion);
    }
    if (!poiqustions.isEmpty()){
      Database.Delete(poiqustions);
    }
    if (!poiheder.isEmpty()){
      Database.Delete(poiheder);
    }
    if (!poiBusinessmember.isEmpty()){      
      Database.Delete(poiBusinessmember);       
    }
    if (!poiAuditResult.isEmpty()){      
      Database.Delete(poiAuditResult);       
    }
    if (!listUIControl.isEmpty()){
      Database.Delete(listUIControl);
    }

  }
  //insert uicontrol,POIHeader,POIType and POIBusinessMember
  @RemoteAction
  public static String insertNewPointInters(string jsondata){

    InsertNewpointIntersetWrapperjson insertNewpointInterset = new InsertNewpointIntersetWrapperjson();

    JSONParser parser = JSON.createParser(jsondata);

    while (parser.nextToken() != null){
      if (parser.getCurrentToken() == JSONToken.START_ARRAY){
        while (parser.nextToken() != null){
System.debug('kkkk'+jsondata);
          if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                  
            InsertNewpointIntersetWrapperjson wrapperjson = (InsertNewpointIntersetWrapperjson) parser.readValueAs(InsertNewpointIntersetWrapperjson.class);
            System.debug(wrapperjson.uicontypeid);
            insertNewPointInterset.uicontypeid = wrapperjson.uicontypeid;
            insertNewpointInterset.title = wrapperjson.title;
            insertNewpointInterset.imageicon = wrapperjson.imageicon;
            insertNewpointInterset.imagesicontwo = wrapperjson.imagesicontwo;
            insertNewpointInterset.description = wrapperjson.description;
            insertNewpointInterset.poitypeid = wrapperjson.poitypeid;
            insertNewPointInterset.pageconfigid = wrapperjson.pageconfigid;
            insertNewPointInterset.poitypeiconname = wrapperjson.poitypeiconname;
            insertNewPointInterset.poiheaderimagename = wrapperjson.poiheaderimagename;
            insertNewPointInterset.uiid = wrapperjson.uiid;
            insertNewPointInterset.xcoordinatevalue = wrapperjson.xcoordinatevalue;
            insertNewPointInterset.ycoordinatevalue = wrapperjson.ycoordinatevalue;
            insertNewPointInterset.poitypeattid = wrapperjson.poitypeattid;
            insertNewPointInterset.poiheaderid = wrapperjson.poiheaderid;
            insertNewPointInterset.poiheaderattid = wrapperjson.poiheaderattid;
            insertNewPointInterset.bbprocessoldid = wrapperjson.bbprocessoldid;

            parser.skipChildren();
          }
        }
      }
    }

    UIControl__c objuiControl = new UIControl__c();

    if (insertNewPointInterset.uiid != null){

      objuiControl.Name = insertNewpointInterset.title;
      objuiControl.Id = insertNewPointInterset.uiid;
      objuiControl.POIType__c = insertNewpointInterset.poitypeid;
      objuiControl.PageConfigName__c = insertNewPointInterset.pageconfigid;
      objuiControl.UIControlTypeId__c = insertNewPointInterset.uicontypeid;


    } else {
      objuiControl.XCoordinate__c = insertNewPointInterset.xcoordinatevalue;
      objuiControl.YCoordinate__c = insertNewPointInterset.ycoordinatevalue;
      objuiControl.Name = insertNewpointInterset.title;
      objuiControl.POIType__c = insertNewpointInterset.poitypeid;
      objuiControl.PageConfigName__c = insertNewPointInterset.pageconfigid;
      objuiControl.UIControlTypeId__c = insertNewPointInterset.uicontypeid;
      objuiControl.Height__c = 52.00;
      objuiControl.Width__c = 52.00;

    }

    upsert objuiControl;

    POIBusinessMember__c poibusmem = new POIBusinessMember__c();

    if(insertNewPointInterset.bbprocessoldid != null){
    poibusmem.uIControl__c = insertNewPointInterset.uiid;
    poibusmem.id = insertNewPointInterset.bbprocessoldid;
    update poibusmem;
    } 
    else if(objuiControl.id!=null){
    poibusmem.uIControl__c = objuiControl.id;
    insert poibusmem;
    }

    

    POIHeader__c poiHeder = new POIHeader__c();

    if (insertNewPointInterset.poiheaderimagename != null && insertNewPointInterset.poiheaderimagename != ''){

     if (!String.isEmpty(insertNewPointInterset.poiheaderid)){

        poiHeder.Name = insertNewPointInterset.poiheaderimagename;
        poiHeder.Description__c = insertNewpointInterset.description;
        poiHeder.id = insertNewPointInterset.poiheaderid;

      } else{
         poiHeder.Name = insertNewPointInterset.poiheaderimagename;
         poiHeder.Description__c = insertNewpointInterset.description;
         poiHeder.UIControl__c = objuiControl.id;

      }
      upsert poiHeder;

      Attachment attachments = new Attachment();

      if (!String.isEmpty(insertNewPointInterset.poiheaderid) && objuiControl.id != null){
        try {
   
          attachments.id = [SELECT id FROM Attachment WHERE parentId = :insertNewPointInterset.poiheaderid].id;
        } catch (Exception ex){   
          attachments.name = insertNewPointInterset.poiheaderimagename;
          attachments.body = insertNewpointInterset.imagesicontwo;
          attachments.parentId = insertNewPointInterset.poiheaderid;
        } 
        attachments.name = insertNewPointInterset.poiheaderimagename;
        attachments.body = insertNewpointInterset.imagesicontwo;
      } else {
        attachments.name = insertNewPointInterset.poiheaderimagename;
        attachments.body = insertNewpointInterset.imagesicontwo;
        attachments.parentId = poiHeder.id;

      }
      upsert attachments;

      poiHeder.attachmentId__c = attachments.id;
      update poiHeder;
    }

    Attachment attid = new Attachment();

    if (insertNewPointInterset.poitypeiconname != '' &&  insertNewPointInterset.poitypeiconname != null){
      if (insertNewpointInterset.poitypeid != null && objuiControl.id != null ){
        try{
           System.debug('12kkkk'+ insertNewpointInterset.description);
          attid.id = [SELECT id FROM Attachment WHERE parentId = :insertNewpointInterset.poitypeid].id;
        } catch (Exception ex){
               System.debug('13kkkk'+ insertNewpointInterset.description);
          attid.name = insertNewPointInterset.poitypeiconname;
          attid.parentId = insertNewpointInterset.poitypeid;
          attid.body = insertNewpointInterset.imageicon;
        }
        System.debug('14kkkk'+ insertNewpointInterset.description);
        attid.body = insertNewpointInterset.imageicon;
        attid.name = insertNewPointInterset.poitypeiconname;
      } else {
           System.debug('15kkkk'+ insertNewpointInterset.description); 
        attid.name = insertNewPointInterset.poitypeiconname;
        attid.parentId = insertNewpointInterset.poitypeid;
        attid.body = insertNewpointInterset.imageicon;
      }

      upsert attid;
    }

    POIType__c objPOIType = new POIType__c();

    if (attid.id != null){
      System.debug('16kkkk'+ insertNewpointInterset.description);
        objPOIType.attachmentId__c = attid.id;
      objPOIType.id = insertNewpointInterset.poitypeid;
      update objPOIType;

      if (insertNewPointInterset.uiid != null){
System.debug('17kkkk'+ insertNewpointInterset.description);
              objuiControl.attachmentId__c = attid.id;
        objuiControl.id = insertNewPointInterset.uiid;
      } else {
             System.debug('18kkkk'+ insertNewpointInterset.description);     
        objuiControl.attachmentId__c = attid.id;
        objuiControl.id = objuiControl.id;
      }
      update objuiControl;
    }


    

    String uiconnewid = JSON.serializePretty(objuiControl.id);
    return uiconnewid;
  }

  //update POIBusinessMember
  @RemoteAction
  public static void updatebbprocess(String bbprocessjsondata){

    Bbprocessfilterwrapper listbbprocesswrapper = new Bbprocessfilterwrapper();
    JSONParser parser = JSON.createParser(bbprocessjsondata);
    while (parser.nextToken() != null){
      if (parser.getCurrentToken() == JSONToken.START_ARRAY){
        while (parser.nextToken() != null){

          if (parser.getCurrentToken() == JSONToken.START_OBJECT){

            Bbprocessfilterwrapper jsoncls = (Bbprocessfilterwrapper) parser.readValueAs(Bbprocessfilterwrapper.class);
            listbbprocesswrapper.uiid = jsoncls.uiid;
            listbbprocesswrapper.filtervalues = jsoncls.filtervalues;
            listbbprocesswrapper.bbprocessid = jsoncls.bbprocessid;
            parser.skipChildren();
          }
        }
      }
    }

    POIBusinessMember__c poibusiness = new POIBusinessMember__c();

    if(listbbprocesswrapper.bbprocessid!=null){
    poibusiness.uIControl__c = listbbprocesswrapper.uiid;
    poibusiness.id = listbbprocesswrapper.bbprocessid;
    poibusiness.filter__c = listbbprocesswrapper.filtervalues;
    update poibusiness;
    }

  }

  public class InsertWrapperjson {

    public String name;
    public Blob blobdata;
    public String posattname;
    public Id mobiledeviceid;
    public Id pageConfigID;
    public Id pageConfigTypeId;
    public Id appsettingid;
  }

  public class InsertNewpointIntersetWrapperjson {

    public String title;
    public Blob imageicon;
    public Id poitypeid;
    public Id pageconfigid;
    public Id uiid;
    public String poitypeiconname;
    public Decimal xcoordinatevalue;
    public Decimal ycoordinatevalue;
    public Id poitypeattid;
    public Id poiheaderid;
    public Id poiheaderattid;
    public Blob imagesicontwo;
    public String description;
    public String poiheaderimagename;
    public Id uicontypeid;
    public Id bbprocessoldid;


  }
  public class Insertnewuicontrolxycoo {

    public String xcoordinates;
    public String ycoordinates;
  }

  public class QuestionWrapper {

    public String questiontype;
    public String question;
    public Id uiid;
    public Id pagecongfigid;
    public Id questiontypeupdate;
    public Id poiquestionid;
    public String questionupdate;
    public Id questiontypeid;
    public Id questionid;
    public String questionsave;
    public String potential;
    public String potentialupdate;
    public Id uiconid;
    public Id questionsaveid;
    public Id questionsaveupdate;
    public Id pageConfigID;
    public String questiontypenew;
    public Boolean questionMandotary;
    public Decimal questionSlider; 

  }
  public class jSONUicontrols {

    public String uiconid;
    public String xaxisi;
    public String yaxiss;
  }

  public class DeleteWrapperQustionjson {

    public Id questionid;
    public Id poiquestionid;
  }
  public class DeleteUicontrolsWrapperjson {

    public Id uiid;
    public Id poiquestionid;
    public Id questionid;
    public Id poiheaderid;
  }
  public class Bbprocessfilterwrapper {

    public Id uiid;
    public String filtervalues;
    public Id bbprocessid;
  }

}