/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :29/07/2015
@Reference      :
*/

@isTest
private class TestCtrAppSettingsDashboard {

	public static MobileDevice__c objmobileDevice;
	public static Attachment attach1;
	public static AppSettings__c objAppSettings;
	public static PageConfig__c objPageConfig;
	public static Attachment attach2;
	public static UIControlType__c objUIControlType;
	public static UIControl__c objUIControl;
	public static Attachment attach3;

	//Creating testData
	static testmethod void testData() {

		TestDataUtility.createNeraTriggerCustomSetting();
		objmobileDevice = new MobileDevice__c(Name = 'Samsung', height__c = 4, width__c = 4, XBezel__c = 90.0, YBezel__c = 34.0, XFrame__c = 727.0, YFrame__c = 563.0 );
		insert objmobileDevice;
		attach1 = new Attachment (Name = 'iPadAir2vector.svg', body = Blob.valueOf('attachBody'), parentId = objmobileDevice.Id);
		insert attach1;
		objmobileDevice.attachmentId__c = attach1.id;
		update objmobileDevice;

		objAppSettings = new AppSettings__c(mobileDevice__c = objmobileDevice.Id, Name = 'IPadAir2', AppVersion__c = 123);
		insert objAppSettings;

		objPageConfig = new PageConfig__c(Name = 'LoginPage', AppSetting__c = objAppSettings.Id, BackGround_Color__c = '#465568');
		insert objPageConfig;
		attach2 = new Attachment (Name = 'iPadAir2vector.svg', body = Blob.valueOf('attachBody'), parentId = objPageConfig.Id);
		insert attach2;
		objPageConfig.attachmentId__c = attach2.Id;
		update objPageConfig;

		objUIControlType = new UIControlType__c(Name = 'Button');
		insert objUIControlType;

		objUIControl = new UIControl__c(Name = 'Phone', Height__c = 40.0, Width__c = 40.0, XCoordinate__c = 10.0, YCoordinate__c = 7.0, Type__c = objUIControlType.Id, PageConfigName__c = objPageConfig.Id);
		insert objUIControl;
		attach3 = new Attachment (Name = 'iPadAir2vector.svg', body = Blob.valueOf('attachBody'), parentId = objUIControl.Id);
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
	}

	//This method checks whether Appsettings are getting or not
	static testmethod void getAppSetting() {

		testData();
		CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
		objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;
		objCtrAppSettingsDashboard.getAppSettings();
		System.assertEquals(objAppSettings.Name, objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Name);
	}

	//This method checks whether Appsetting related pageconfigs getting or not
	//static testmethod void getPageConfg(){

	//	testData();
	//	CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
	//	objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;
	//	objCtrAppSettingsDashboard.getPageConfig();
	//	System.assertEquals(objPageConfig.Name, objCtrAppSettingsDashboard.listpageConfig[0].Name);
	//}

	//This method checks  Appsettings records are saved in to the AppSetting object or not
	static testmethod void saveAppSetting() {

		testData();
		CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
		objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;
		objCtrAppSettingsDashboard.saveAppSettings();
		AppSettings__c objAppSettings1 = [SELECT Id, Name FROM AppSettings__c LIMIT 1];
		System.assertEquals(objAppSettings.Name, objAppSettings1.Name);
	}

	//This method checks whether Pageconfig related Uicontrols getting or not

	static testmethod void getpageconfigUIcon() {

		testData();
		PageConfig__c pageconfigUIconJsonData = [SELECT id, name, backGround_Color__c, attachmentId__c,
		              (SELECT name, height__c, width__c, xCoordinate__c, yCoordinate__c, type__c, attachmentId__c FROM UIControls__r),
		              (SELECT id, name from attachments)
		              FROM PageConfig__c
		              WHERE id = :objPageConfig.Id];
		CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
		objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;
		String pageconfigUIconData = CtrAppSettingsDashboard.getpageconfigUIcon(objPageConfig.id);
		System.assertEquals(JSON.serializePretty(pageconfigUIconJsonData), pageconfigUIconData);
	}

	//This method checks whether Mobile device fields are getting or not by passing AppSetting Id
	static testmethod void getAppSettingsImages() {

		testData();
		AppSettings__c appSettingJsonData = [SELECT id, name, mobileDevice__r.attachmentId__c, mobileDevice__r.height__c, mobileDevice__r.width__c, mobileDevice__r.xBezel__c,
		                                     mobileDevice__r.yBezel__c, mobileDevice__r.xFrame__c, mobileDevice__r.yFrame__c
		                                     FROM AppSettings__c
		                                     WHERE id = :objAppSettings.Id];
		CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
		objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;
		String jsonAppSetingData = CtrAppSettingsDashboard.getAppSettingsImages(objAppSettings.Id);
		System.assertEquals(JSON.serializePretty(appSettingJsonData), jsonAppSetingData);
	}

	static testmethod void getUIControl() {

		testData();
		CtrAppSettingsDashboard objCtrAppSettingsDashboard = new CtrAppSettingsDashboard();
		objCtrAppSettingsDashboard.selectedAppSettings = objAppSettings.Id;
		String jsonObjPageconfig = '[{"pagiconfigid1":"' + objPageConfig.Id + '","backgroundcolor1":"#444444"}]';
		String jsondata = '[{"height1":"69.57015985790409","id":"' + objUIControl.Id + '","parentid1":null,"uiname1":null,"width1":"363.40027510316366","xCoordinate1":"328","YCoordinate1":"210"}]';
		CtrAppSettingsDashboard.getUIControl(jsondata, jsonObjPageconfig);
	}
}