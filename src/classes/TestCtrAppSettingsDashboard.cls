/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :29/07/2015
@Reference      :
*/

@IsTest
private class TestCtrAppSettingsDashboard {

	static testmethod void appSettingsDashboard() {
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

		AppSettings__c appSettingJsonData = [SELECT id, name, mobileDevice__r.attachmentId__c, mobileDevice__r.height__c, mobileDevice__r.width__c, mobileDevice__r.xBezel__c,
		                                     mobileDevice__r.yBezel__c, mobileDevice__r.xFrame__c, mobileDevice__r.yFrame__c
		                                     FROM AppSettings__c 
		                                     WHERE id = :objAppSettings.Id];
		PageConfig__c pageconfigUIconJsonData = [SELECT id, name, backGround_Color__c, attachmentId__c,
										                    (SELECT name, height__c, width__c, xCoordinate__c, yCoordinate__c, type__c, attachmentId__c FROM UIControls__r),
										                    (SELECT id, name from attachments)
		                                         FROM PageConfig__c 
		                                         WHERE id = :objPageConfig.Id];

		CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
		objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;

		//This method for getting Appsettings
		objCtrAppSettingsDashboard.getAppSettings();
		System.assertEquals(objAppSettings.Name,objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Name);

		//This method for getting Appsetting related pageconfigs
		objCtrAppSettingsDashboard.getPageConfig();
		System.assertEquals(objPageConfig.Name,objCtrAppSettingsDashboard.listpageConfig[0].Name);

		//This method for inserting Appsettings
		objCtrAppSettingsDashboard.saveAppSettings();
	
		//This method for getting Pageconfig related Uicontrols
		String pageconfigUIconData = CtrAppSettingsDashboard.getpageconfigUIcon(objPageConfig.id);
		System.assertEquals(JSON.serializePretty(pageconfigUIconJsonData),pageconfigUIconData);

		//This method for getting Mobile device fields by passing Pageconfig Id
		String jsonAppSetingData = CtrAppSettingsDashboard.getAppSettingsImages(objAppSettings.Id);
		System.assertEquals(JSON.serializePretty(appSettingJsonData),jsonAppSetingData);

		String jsonObjPageconfig = '[{"pagiconfigid1":"' + objPageConfig.Id + '","backgroundcolor1":"#444444"}]';
		String jsondata = '[{"height1":"69.57015985790409","id":"' + objUIControl.Id + '","parentid1":null,"uiname1":null,"width1":"363.40027510316366","xCoordinate1":"328","YCoordinate1":"210"}]';
		//
		CtrAppSettingsDashboard.getUIControl(jsondata, jsonObjPageconfig);
	}

}