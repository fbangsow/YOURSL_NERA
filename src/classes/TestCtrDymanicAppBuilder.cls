@isTest
private class TestCtrDymanicAppBuilder {

	static testmethod void dynamicAppBuilder() {
	    CleanupTestData.createNeraTriggerCustomSetting();
		MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'Samsung', height__c = 4, width__c = 4, XBezel__c = 90.0, YBezel__c = 34.0, XFrame__c = 727.0, YFrame__c = 563.0 );
		insert objmobileDevice;
		Attachment attach1 = new Attachment (Name = 'iPadAir2vector.svg', body = Blob.valueOf('attachBody'), parentId = objmobileDevice.Id);
		insert attach1;
		objmobileDevice.attachmentId__c = attach1.id;
		update objmobileDevice;
		AppSettings__c objAppSettings = new AppSettings__c(mobileDevice__c = objmobileDevice.Id, Name = 'IPadAir2', AppVersion__c = 123);
		insert objAppSettings;
		PageConfig__c objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.Id, BackGround_Color__c = '#465568');
		insert objPageConfig;
		Attachment attach2 = new Attachment (Name = 'iPadAir2vector.svg', body = Blob.valueOf('attachBody'), parentId = objPageConfig.Id);
		insert attach2;
		objPageConfig.attachmentId__c = attach2.Id;
		update objPageConfig;

		UIControlType__c objUIControlType = new UIControlType__c(Name = 'Button');
		insert objUIControlType;

		UIControl__c objUIControl = new UIControl__c(Name = 'Phone', Height__c = 40.0, Width__c = 40.0, XCoordinate__c = 10.0, YCoordinate__c = 7.0, Type__c = objUIControlType.Id, PageConfigName__c = objPageConfig.Id);
		insert objUIControl;
		Attachment attach3 = new Attachment (Name = 'iPadAir2vector.svg', body = Blob.valueOf('attachBody'), parentId = objUIControl.Id);
		insert attach3;
		objUIControl.attachmentId__c = attach3.Id;
		update objUIControl;
		UIControlAttribute__c objUIControlAttribute = new UIControlAttribute__c(Name = 'BackGroundColor', Value__c = 'Helvetica', UIControlId__c = objUIControl.Id);
		insert objUIControlAttribute;

		AppSettings__c appSettingJsonData = [SELECT id, name, mobileDevice__r.attachmentId__c, mobileDevice__r.height__c, mobileDevice__r.width__c, mobileDevice__r.xBezel__c,
		                                     mobileDevice__r.yBezel__c, mobileDevice__r.xFrame__c, mobileDevice__r.yFrame__c
		                                     FROM AppSettings__c
		                                     WHERE id = :objAppSettings.Id];
		PageConfig__c pageconfigUIconJsonData = [SELECT id, name, backGround_Color__c, attachmentId__c,
										              (SELECT name, height__c, width__c, xCoordinate__c, yCoordinate__c, type__c, attachmentId__c FROM UIControls__r),
										              (SELECT id, name from attachments)
									             FROM PageConfig__c
									             WHERE id = :objPageConfig.Id];
		UIControl__c uiControlattributeJsondata = [SELECT id, name,
								                      (SELECT name, value__c FROM UIControllerAttributes__r),
								                      (SELECT id, name from attachments)
								                   FROM UIControl__c
								                   WHERE id = :objUIControl.Id];


		CtrDymanicAppBuilder objCtrDymanicAppBuilder = new CtrDymanicAppBuilder();


		objCtrDymanicAppBuilder.selectedAppSettings = objAppSettings.Id;
		//This method for getting Appsettings
		objCtrDymanicAppBuilder.getAppSettings();
		System.assertEquals(objAppSettings.Name,objCtrDymanicAppBuilder.selectedAppSettings = objAppSettings.Name);

		//This method for getting Appsetting related pageconfigs
		objCtrDymanicAppBuilder.getPageConfig();
		System.assertEquals(objPageConfig.Name,objCtrDymanicAppBuilder.listpageConfig[0].Name);


		//This method for getting all custom object list
		  List<SelectOption> objNames=new List<SelectOption> ();
		 objNames=objCtrDymanicAppBuilder.getCustomObjectsList();
		//system.assertEquals(!objNames.con);
		//This method for getting all Standard object list
		objCtrDymanicAppBuilder.getStandardObjectsList();



		objCtrDymanicAppBuilder.standardObjects = 'Account';
		//This method for getting a Standard object related fields by passing object
		objCtrDymanicAppBuilder.getStandardObjectFields();

		//This method for returning a Standard object related fields
		objCtrDymanicAppBuilder.getStdObjectFields();


		objCtrDymanicAppBuilder.customObjects = 'PageConfig__c';
		//This method for getting a custom object related fields by passsing custom object
		objCtrDymanicAppBuilder.getCustomObjectFields();

		//This method for returning a custom object related fields
		objCtrDymanicAppBuilder.getCusObjectFields();

		//This method inserting Appsettings		 
		 PageReference pg = objCtrDymanicAppBuilder.saveAppSettings();		 
		//This method for getting Pageconfig related Uicontrols
		String jsonpageconfigUIconData = CtrDymanicAppBuilder.getpageconfigUIcon(objPageConfig.Id);
		System.assertEquals(JSON.serializePretty(pageconfigUIconJsonData),jsonpageconfigUIconData);


		//This method for getting Uicontrols related UicontrolAttribute
		String jsonUiControlAttributeData = CtrDymanicAppBuilder.getUIcontroluiAttributes(objUIControl.Id);
		System.assertEquals(JSON.serializePretty(uiControlattributeJsondata),jsonUiControlAttributeData);
		
		//This method for getting Mobile device fields by passing Pageconfig Id
		String jsonAppSetingData = CtrDymanicAppBuilder.getAppSettingsImages(objAppSettings.Id);
		System.assertEquals(JSON.serializePretty(appSettingJsonData),jsonAppSetingData);

		String jsonObjPageconfig = '[{"pagiconfigid1":"' + objPageConfig.Id + '","backgroundcolor1":"#444444"}]';
		String jsondata = '[{"height1":"69.57015985790409","id":"' + objUIControl.Id + '","parentid1":null,"uiname1":null,"width1":"363.40027510316366","xCoordinate1":"328","YCoordinate1":"210"}]';
		String jsonData2 = '[{"height1":"69.57015985790409","id":null,"parentid1":null,"uiname1":null,"width1":"363.40027510316366","xCoordinate1":"328","YCoordinate1":"210"}]';
		//This method for updating the changes in particular Uicontrol(Positive)
		CtrDymanicAppBuilder.getUIControl(jsondata,jsonObjPageconfig);
		//This method for inserting the  Uicontrol(Negative)
		CtrDymanicAppBuilder.getUIControl(jsonData2,jsonObjPageconfig);
	}
}