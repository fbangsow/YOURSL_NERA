/*
 @Company: YOUR SL
 @Author: KVE
 @Creation date: 16/06/2015
 @Modified date: 22/07/2015
 @Ref: 621
*/
public with sharing class PostDeployment {

	public PostDeployment() {

		if (validate()) {

		} else {
			System.debug('something went wrong');
		}
	}
	// preliminary checks will be executed here
	public boolean validate() {
		return true;
	}

	public static void doDeployment() {

		//String clientId = '3MVG9Rd3qC6oMalUEvDDsZ.dGitMn77csJYM2GPSb11n5tDEvUayiGSmmmbSSsIEHItJPZXEPJmPIDrYwizOP';
		//String clientSecret = '1184065286610443678';
		//String username = 'k.verheyden@nera.centralhub';
		//String password = 'Wasbeer1!G63X9QZCAruidgtRNHlI5N1fN';
		//String url = 'https://eu5.salesforce.com';
		String clientId = '3MVG9Rd3qC6oMalUEvDDsZ.dGigns8FuEpVMh5FD2sLNa3eN1JptaXH1UnR6bzUC5n86ddAhAY4qteuQYVEgU';
		String clientSecret = '9004469196367839452';
		String username = 'imran.s@nera.demodev';
		String password = '1q2w3e4r5th05fZJW9QxSWSh5O8XPe7Agy';
		String url = 'https://eu5.salesforce.com';
		String reqbody = 'grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password;
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setBody(reqbody);
		req.setMethod('GET');
		req.setEndpoint( url + '/services/oauth2/token');
		HttpResponse res = h.send(req);

		OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);

		// get the Mobile,AppSettings and Business Process
		if (objAuthenticationInfo.access_token != null) {
			List<MobileDevice__c> myResponse = getResponse(objAuthenticationInfo, 'mobileDevice');
			List<AppSettings__c> myResponseAppsettings = getResponse(objAuthenticationInfo, 'appSetting');
			List<PageConfigType__c> myResponsePageConfigType = getResponse(objAuthenticationInfo, 'pageConfigType');

			List<PageConfig__c> myResponsepageConfig = getResponse(objAuthenticationInfo, 'pageConfig');

			List<UIControlGroup__c> myResponseUiControlGroup = getResponse(objAuthenticationInfo, 'uiControlGroup');
			List<UIControlType__c> myResponseUiControlType = getResponse(objAuthenticationInfo, 'uiControlType');
			List<UIControl__c> myResponseUiControl = getResponse(objAuthenticationInfo, 'uiControl');


			List<UIControlAttribute__c> myResponseUiControlAttribute = getResponse(objAuthenticationInfo, 'uiControlAttribute');
			List<UIControlAttributeType__c> myResponseUiControlAttributeType = getResponse(objAuthenticationInfo, 'uiControlAttributeType');
			List<UIControlAttributeGroup__c> myResponseUiControlAttributeGroup = getResponse(objAuthenticationInfo, 'uiControlAttributeGroup');
			List<Businessprocess__c> myBusinessProcess = getResponse(objAuthenticationInfo, 'businessProcess');
			List<BusinessProcessParameter__c> myBusinessProcessParameters = getResponse(objAuthenticationInfo, 'businessProcessParameter');
			List<StringCatalogItem__c> myStringCatlogItem = getResponse(objAuthenticationInfo, 'stringCatlogItem');
			//-------------------------------------------------

			// OldAttachmentID  Map<  OldParentId, NewParentId >
			Map<Id, Map<Id, Id>> mapOldAttachmentIdNewParentId = new Map<Id, Map<Id, Id>>();

			Map<Id, MobileDevice__c> mapMobileDevices = new Map<Id, MobileDevice__c>();
			for (MobileDevice__c obj : myResponse) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapMobileDevices.put(oldId, obj);
				if (obj.AttachmentId__c <> null) {
					Map<Id, Id> oldMap = new Map<Id, Id>();
					oldMap.put(oldId, null);
					mapOldAttachmentIdNewParentId.put(obj.AttachmentId__c, oldMap);
				}
			}
			insert mapMobileDevices.values();
			for (Id key : mapMobileDevices.keySet()) {
				//the key is the old object Id
				Id oldAttachmentId = mapMobileDevices.get(key).AttachmentId__c;
				(mapOldAttachmentIdNewParentId.get(oldAttachmentId)).put(key, mapMobileDevices.get(key).Id);
			}

			//-------------------------------------------------
			Map<Id, AppSettings__c> mapAppsettings = new Map<Id, AppSettings__c>();
			for (AppSettings__c obj : myResponseAppsettings) {

				Id oldId = obj.Id;
				obj.Id = null;
				//obj.AttachmentId__c = null;
				obj.mobileDevice__c = mapMobileDevices.get(obj.mobileDevice__c).id;
				mapAppsettings.put(oldId, obj);
			}
			insert mapAppsettings.values();

			Map<Id, PageConfigType__c> mapPageConfigType = new Map<Id, PageConfigType__c>();
			for (PageConfigType__c obj : myResponsePageConfigType) {

				Id oldId = obj.Id;
				obj.Id = null;
				mapPageConfigType.put(oldId, obj);
			}
			insert mapPageConfigType.values();

			Map<Id, PageConfig__c> mapPageConfig = new Map<Id, PageConfig__c>();
			for (PageConfig__c obj : myResponsepageConfig) {
				Id oldId = obj.Id;
				obj.Id = null;
				//obj.AttachmentId__c = null;//Comment By Imran

				if (obj.AppSetting__c <> null) {
					obj.AppSetting__c = mapAppsettings.get(obj.AppSetting__c).id;
				}
				if (obj.PageConfigTypeId__c != null) {
					obj.PageConfigTypeId__c = mapPageConfigType.get(obj.PageConfigTypeId__c).id;
				}
				mapPageConfig.put(oldId, obj);
				if (obj.AttachmentId__c <> null) {
					Map<Id, Id> oldMap = new Map<Id, Id>();
					oldMap.put(oldId, null);
					mapOldAttachmentIdNewParentId.put(obj.AttachmentId__c, oldMap);
				}
			}
			insert mapPageConfig.values();
			for (Id key : mapPageConfig.keySet()) {
				//the key is the old object Id
				Id oldAttachmentId = mapPageConfig.get(key).AttachmentId__c;
				if (mapOldAttachmentIdNewParentId.containskey(oldAttachmentId)) {
					(mapOldAttachmentIdNewParentId.get(oldAttachmentId)).put(key, mapPageConfig.get(key).Id);
				}
			}

			Map<Id, UIControlType__c> mapUiControlType = new Map<Id, UIControlType__c>();
			for (UIControlType__c obj : myResponseUiControlType) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapUiControlType.put(oldId, obj);
			}
			insert mapUiControlType.values();

			Map<Id, UIControlGroup__c> mapUiControlGroup = new Map<Id, UIControlGroup__c>();
			for (UIControlGroup__c obj : myResponseUiControlGroup) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapUiControlGroup.put(oldId, obj);
			}
			insert mapUiControlGroup.values();

			Map<Id, UIControl__c> mapUiControl = new Map<Id, UIControl__c>();
			for (UIControl__c obj : myResponseUiControl) {

				Id oldId = obj.Id;
				obj.Id = null;
				//if(mapPageConfig.containsKey(obj.PageConfigName__c)){
				obj.PageConfigName__c = mapPageConfig.containsKey(obj.PageConfigName__c) ? mapPageConfig.get(obj.PageConfigName__c).id : null;
				//}else{
				//obj.PageConfigName__c = null;
				//}

				if (obj.UIControlTypeId__c != null) {
					obj.UIControlTypeId__c = mapUiControlType.get(obj.UIControlTypeId__c).id;
				}

				//if(mapUiControlGroup.containsKey(obj.UIControlGroupId__c)){
				obj.UIControlGroupId__c = mapUiControlGroup.containsKey(obj.UIControlGroupId__c) ? mapUiControlGroup.get(obj.UIControlGroupId__c).id : null;
				//}
				mapUiControl.put(oldId, obj);
				if (obj.AttachmentId__c <> null) {
					Map<Id, Id> oldMap = new Map<Id, Id>();
					oldMap.put(oldId, null);
					mapOldAttachmentIdNewParentId.put(obj.AttachmentId__c, oldMap);
				}
			}
			insert mapUiControl.values();
			for (Id key : mapUiControl.keySet()) {
				//the key is the old object Id
				Id oldAttachmentId = mapUiControl.get(key).AttachmentId__c;
				if (mapOldAttachmentIdNewParentId.containskey(oldAttachmentId)) {
					(mapOldAttachmentIdNewParentId.get(oldAttachmentId)).put(key, mapUiControl.get(key).Id);
				}
			}

			Map<Id, UIControlAttributeType__c> mapUiControlAttributeType = new Map<Id, UIControlAttributeType__c>();
			for (UIControlAttributeType__c obj : myResponseUiControlAttributeType) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapUiControlAttributeType.put(oldId, obj);
			}
			insert mapUiControlAttributeType.values();

			Map<Id, UIControlAttributeGroup__c> mapUIControlAttributeGroup = new Map<Id, UIControlAttributeGroup__c>();
			for (UIControlAttributeGroup__c obj : myResponseUiControlAttributeGroup) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapUIControlAttributeGroup.put(oldId, obj);
			}
			insert mapUIControlAttributeGroup.values();

			Map<Id, UIControlAttribute__c> mapUIControlAttribute = new Map<Id, UIControlAttribute__c>();
			for (UIControlAttribute__c obj : myResponseUiControlAttribute) {
				Id oldId = obj.Id;
				obj.Id = null;
				obj.UIControlAttributeTypeId__c = obj.UIControlAttributeTypeId__c != null ? mapUiControlAttributeType.get(obj.UIControlAttributeTypeId__c).id : null;
				obj.UIControlAttributeGroupId__c = obj.UIControlAttributeGroupId__c != null ? mapUIControlAttributeGroup.get(obj.UIControlAttributeGroupId__c).id : null;
				//if(mapUiControl.containskey(obj.UIControlId__c)){
				obj.UIControlId__c = mapUiControl.containskey(obj.UIControlId__c) ? mapUiControl.get(obj.UIControlId__c).id : null ;
				//}
				//else{
				//obj.UIControlId__c = null;
				//}
				mapUIControlAttribute.put(oldId, obj);
				if (obj.AttachmentId__c <> null) {
					Map<Id, Id> oldMap = new Map<Id, Id>();
					oldMap.put(oldId, null);
					mapOldAttachmentIdNewParentId.put(obj.AttachmentId__c, oldMap);
				}
			}
			insert mapUIControlAttribute.values();
			for (Id key : mapUIControlAttribute.keySet()) {
				//the key is the old object Id
				Id oldAttachmentId = mapUIControlAttribute.get(key).AttachmentId__c;
				if (mapOldAttachmentIdNewParentId.containskey(oldAttachmentId)) {
					(mapOldAttachmentIdNewParentId.get(oldAttachmentId)).put(key, mapUIControlAttribute.get(key).Id);
				}
			}

			//---Business Process---Start---------------

			Map<Id, Businessprocess__c> mapBusinessProcess = new Map<Id, Businessprocess__c>();
			for (Businessprocess__c obj : myBusinessProcess) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapBusinessProcess.put(oldId, obj);
			}
			insert mapBusinessProcess.values();

			Map<Id, BusinessProcessParameter__c> mapBusinessProcessParameters = new Map<Id, BusinessProcessParameter__c>();
			for (BusinessProcessParameter__c obj : myBusinessProcessParameters) {
				Id oldId = obj.Id;
				obj.Id = null;
				obj.BusinessprocessId__c = mapBusinessProcess.get(obj.BusinessprocessId__c).Id;
				mapBusinessProcessParameters.put(oldId, obj);
			}
			insert mapBusinessProcessParameters.values();

			//---Business Process---End---------------
			Map<Id, StringCatalogItem__c> mapStringCatlogItem = new Map<Id, StringCatalogItem__c>();
			for (StringCatalogItem__c obj : myStringCatlogItem) {
				Id oldId = obj.Id;
				obj.Id = null;
				mapStringCatlogItem.put(oldId, obj);
			}
			insert mapStringCatlogItem.values();

			//Map<Id,Map<Id,Id>> mapOldAttachmentIdNewParentId
			System.debug('SIZE OF BATCH ---->  ' + mapOldAttachmentIdNewParentId.size());
			Database.executeBatch(new BatchPostDeployment(mapOldAttachmentIdNewParentId), 1);
		}
	}
	//attachment oldId / parentId

	public static List<Sobject> getResponse(OAuth2 objAuthenticationInfo, String objectType) {
		String url = 'https://eu5.salesforce.com';
		Http h1 = new Http();
		HttpRequest requestMobileAndApp = new HttpRequest();
		requestMobileAndApp.setHeader('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
		requestMobileAndApp.setHeader('Content-Type', 'application/json');
		requestMobileAndApp.setHeader('accept', 'application/json');
		requestMobileAndApp.setMethod('GET');
		requestMobileAndApp.setEndpoint(url + '/services/apexrest/Deployment/?requestType=' + objectType);

		HttpResponse myResponse = h1.send(requestMobileAndApp);
		String myJson = myResponse.getBody();
		myJson = '{"MobileDevice__c":' + myJson + '}';

		JSONParser parser = JSON.createParser(myJson);

		List<Sobject> listMyResponseObjects = new List<Sobject>();
		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while (parser.nextToken() != null) {
					if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
						Sobject mobile = (Sobject)parser.readValueAs(Sobject.class);
						listMyResponseObjects.add(mobile);
						//parser.skipChildren();
					}
				}
			}
		}
		return listMyResponseObjects;
	}
	//#region wrappers {
	public class OAuth2 {

		public String id {get; set;}
		public String issued_at {get; set;}
		public String instance_url {get; set;}
		public String signature {get; set;}
		public String access_token {get; set;}

	}
	//
	//}
}