/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :14/07/2015
@Reference      :
*/
@istest
public class TestCleanUpTestData {

	//Creating Test Data
	private static void testDataForCleanUp() {

		TestDataUtility.createNeraTriggerCustomSetting();
		//Inserting MobileDevice
		MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'Samsung', height__c = 4, width__c = 4, IsDefault__c = True);
		insert objmobileDevice;

		//Inserting AppSettings
		List<AppSettings__c> listAppSettings = new List<AppSettings__c>();
		listAppSettings.add( new AppSettings__c( mobileDevice__c = objmobileDevice.Id, Name = 'IPadAir1', AppVersion__c = 123, IsDefault__c = True));
		listAppSettings.add( new AppSettings__c( mobileDevice__c = objmobileDevice.Id, Name = 'IPadAir3', AppVersion__c = 123, IsDefault__c = True));
		listAppSettings.add( new AppSettings__c( mobileDevice__c = objmobileDevice.Id, Name = 'IPadAir4', AppVersion__c = 123, IsDefault__c = True));
		insert listAppSettings;

		//Inserting PageConfigType
		List<PageConfigType__c> listPageConfigType = new List<PageConfigType__c>();
		listPageConfigType.add( new PageConfigType__c(Name = 'WeeklyViewPage', IsDefault__c = True));
		listPageConfigType.add( new PageConfigType__c(Name = 'DialyViewPage', IsDefault__c = True));
		listPageConfigType.add( new PageConfigType__c(Name = 'Weekly2ViewPage', IsDefault__c = True));
		insert listPageConfigType;

		//Inserting PageConfig
		List<PageConfig__c>  listPageConfig = new List<PageConfig__c>();
		listPageConfig.add( new PageConfig__c(Name = 'LoginPage', AppSetting__c = listAppSettings[0].Id, IsDefault__c = True));
		listPageConfig.add( new PageConfig__c(Name = 'ProductListingPage', AppSetting__c = listAppSettings[0].Id, IsDefault__c = True));
		listPageConfig.add( new PageConfig__c(Name = 'SplashScreen', AppSetting__c = listAppSettings[0].Id, IsDefault__c = True));
		insert  listPageConfig;

		//Inserting UIControlGroup
		List<UIControlGroup__c> listUIControlGroup = new List<UIControlGroup__c>();
		listUIControlGroup.add( new UIControlGroup__c(Name = 'AppointmenTableMapPinGroup', IsDefault__c = True));
		listUIControlGroup.add( new UIControlGroup__c(Name = 'DayViewScreenSubControlsGroup', IsDefault__c = True));
		listUIControlGroup.add( new UIControlGroup__c(Name = 'VisitPreparationSubControlsGroup', IsDefault__c = True));
		insert listUIControlGroup;

		//Inserting UIControlType
		List<UIControlType__c> listUIControlType = new List<UIControlType__c>();
		listUIControlType.add( new UIControlType__c(Name = 'View', IsDefault__c = True));
		listUIControlType.add( new UIControlType__c(Name = 'Label', IsDefault__c = True));
		listUIControlType.add( new UIControlType__c(Name = 'MapView', IsDefault__c = True));
		insert listUIControlType;

		List<PoiType__c> listPoitype = new List<PoiType__c>();
		listPoitype.add(new PoiType__c(Name = 'TestPoitype'));
		listPoitype.add(new PoiType__c(Name = 'TestPoitype1'));
		insert listPoitype;
		Attachment attach = new Attachment(Name = 'icon_login.svg', ParentId = listPoitype[0].Id, Body = blob.valueOf('Test attachment body'));
		insert attach;
		listPoitype[0].AttachmentId__c = attach.Id;
		update listPoitype[0];
		Attachment attach1 = new Attachment(Name = 'icon_login.svg', ParentId = listPoitype[1].Id, Body = blob.valueOf('Test attachment body'));
		insert attach1;
		listPoitype[1].AttachmentId__c = attach1.Id;
		update listPoitype[1];


		//Inserting UIControll
		List<UIControl__c> listUIControl = new List<UIControl__c>();
		listUIControl.add( new UIControl__c(Name = 'UserName', Height__c = 43.651865008880996, YCoordinate__c = 360.0, IsDefault__c = True,POIType__c=listPoitype[0].Id));
		listUIControl.add( new UIControl__c(Name = 'Password', Height__c = 42.0, YCoordinate__c = 360.0000138765536, IsDefault__c = True,POIType__c=listPoitype[0].Id));
		listUIControl.add( new UIControl__c(Name = 'Settings', Height__c = 43.651865008880996, YCoordinate__c = 525.0, IsDefault__c = True,POIType__c=listPoitype[1].Id));
		insert listUIControl ;

		//Inserting UIControlAttributeGroup
		List<UIControlAttributeGroup__c>  listUiControlAttributeGroup = new List<UIControlAttributeGroup__c>();
		listUiControlAttributeGroup.add( new UIControlAttributeGroup__c(Name = 'ProductListingGridColumnGroup', IsDefault__c = True));
		listUiControlAttributeGroup.add( new UIControlAttributeGroup__c(Name = 'CustomerSegmentTabGroups', IsDefault__c = True));
		listUiControlAttributeGroup.add( new UIControlAttributeGroup__c(Name = 'AppointmentTableViewAttributeGroup', IsDefault__c = True));
		insert listUiControlAttributeGroup;

		//Inserting UIControlAttributeType
		List<UIControlAttributeType__c> listUiControlAttributeType = new List<UIControlAttributeType__c>();
		listUiControlAttributeType.add( new UIControlAttributeType__c(Name = 'Image', IsDefault__c = True));
		listUiControlAttributeType.add( new UIControlAttributeType__c(Name = 'BorderColor', IsDefault__c = True));
		listUiControlAttributeType.add( new UIControlAttributeType__c(Name = 'TimeFormat', IsDefault__c = True));
		insert listUiControlAttributeType;

		//Inserting UIControlAttribute
		List<UIControlAttribute__c> listUiControlAttribute = new List<UIControlAttribute__c>();
		listUiControlAttribute.add(new UIControlAttribute__c(Name = 'ForeGroundColor', IsDefault__c = True));
		listUiControlAttribute.add(new UIControlAttribute__c(Name = 'FontName', IsDefault__c = True));
		listUiControlAttribute.add(new UIControlAttribute__c(Name = 'BackgroundColor', IsDefault__c = True));
		insert listUiControlAttribute;

		//Inserting StringCatalogItem
		List<StringCatalogItem__c> listStringCatalogItem = new  List<StringCatalogItem__c>();
		listStringCatalogItem.add(new StringCatalogItem__c(EnumCode__c = 'LoginFailed', Language__c = 'en_US', IsDefault__c = true) );
		listStringCatalogItem.add(new StringCatalogItem__c(EnumCode__c = 'SandboxMessage', Language__c = 'en_US', IsDefault__c = true) );
		listStringCatalogItem.add(new StringCatalogItem__c(EnumCode__c = 'ProductionMessage', Language__c = 'en_US', IsDefault__c = true) );
		insert listStringCatalogItem;
	}

	//This method checks whether all records(Whose Default value is checked) of objects deleted or not  by passing the parameter False
	static testMethod void cleanUpTestData() {

		testDataForCleanUp();
		CleanupTestData.run(false);

		//Deleting StringCatalogItem
		List<StringCatalogItem__c> lststringCatalogItems = new List<StringCatalogItem__c>([SELECT Id
		        FROM StringCatalogItem__c
		        WHERE IsDefault__c != : false]);
		if (!lststringCatalogItems.isEmpty()) {
			delete lststringCatalogItems;
			System.assert(!lststringCatalogItems.isEmpty());
		}
		//Deleting UIControlAttribute
		List<UIControlAttribute__c> lstUiControlAttribute = new List<UIControlAttribute__c>([SELECT Id, IsDefault__c
		        FROM UIControlAttribute__c
		        WHERE IsDefault__c != : false]);
		if (!lstUiControlAttribute.isEmpty()) {
			delete lstUiControlAttribute;
			System.assert(!lstUiControlAttribute.isEmpty());
		}
		//Deleting UIControlAttributeType
		List<UIControlAttributeType__c> lstUiControlAttributeType = new List<UIControlAttributeType__c>([SELECT Id, IsDefault__c
		        FROM UIControlAttributeType__c
		        WHERE IsDefault__c != : false]);
		if (!lstUiControlAttributeType.isEmpty()) {
			delete lstUiControlAttributeType;
			System.assert(!lstUiControlAttributeType.isEmpty());
		}

		//Deleting UIControlAttributeGroup
		List<UIControlAttributeGroup__c> lstUiControlAttributeGroup = new List<UIControlAttributeGroup__c>([SELECT Id, IsDefault__c
		        FROM UIControlAttributeGroup__c
		        WHERE IsDefault__c != : false]);
		if (!lstUiControlAttributeGroup.isEmpty()) {
			delete lstUiControlAttributeGroup;
			System.assert(!lstUiControlAttributeGroup.isEmpty());
		}

		//Deleting UIControl
		List<UIControl__c> lstUIControl = new List<UIControl__c>([SELECT Id, IsDefault__c
		        FROM UIControl__c
		        WHERE IsDefault__c != : false]);
		if (!lstUIControl.isEmpty()) {
			delete lstUIControl;
			System.assert(!lstUIControl.isEmpty());
		}

		//Deleting UIControlType
		List<UIControlType__c> lstUIControlType = new List<UIControlType__c>([SELECT Id, IsDefault__c
		        FROM UIControlType__c
		        WHERE IsDefault__c != : false]);
		if (!lstUIControlType.isEmpty()) {
			delete lstUIControlType;
			System.assert(!lstUIControlType.isEmpty());
		}

		//Deleting UIControlGroup
		List<UIControlGroup__c> lstUIControlGroup = new List<UIControlGroup__c>([SELECT Id, IsDefault__c
		        FROM UIControlGroup__c
		        WHERE IsDefault__c != : false]);
		if (!lstUIControlGroup.isEmpty()) {
			delete lstUIControlGroup;
			System.assert(!lstUIControlGroup.isEmpty());
		}
		//Deleting Pageconfig
		List<PageConfig__c> lstPageConfig = new List<PageConfig__c>([SELECT Id, IsDefault__c
		        FROM PageConfig__c
		        WHERE IsDefault__c != : false]);
		if (!lstPageConfig.isEmpty()) {
			delete lstPageConfig;
			System.assert(!lstPageConfig.isEmpty());
		}
		//Deleting PageconfigType
		List<PageConfigType__c> lstPageConfigType = new List<PageConfigType__c>([SELECT Id, IsDefault__c
		        FROM PageConfigType__c
		        WHERE IsDefault__c != : false]);
		if (!lstPageConfigType.isEmpty()) {
			delete lstPageConfigType;
			System.assert(!lstPageConfigType.isEmpty());

		}
		//Deleting AppSetting
		List<AppSettings__c> lstAppSettings = new List<AppSettings__c>([SELECT Id, IsDefault__c
		        FROM AppSettings__c
		        WHERE IsDefault__c != : false]);
		if (!lstAppSettings.isEmpty()) {
			delete lstAppSettings;
			System.assert(!lstAppSettings.isEmpty());
		}

		//Deleting MobileDevice
		List<MobileDevice__c> lstmobileDevice = new List<MobileDevice__c>([SELECT Id, IsDefault__c
		        FROM MobileDevice__c
		        WHERE IsDefault__c != : false ]);
		if (!lstmobileDevice.isEmpty()) {
			delete lstmobileDevice;
			System.assert(!lstmobileDevice.isEmpty());

			CleanupTestData testObj = new CleanupTestData();
			//CleanupTestData.run(false);

		}
	}

	//This method checks whether all records(Whose Default value is Unchecked) of objects deleted or not  by passing the parameter True
	static testMethod void cleanUpTestDataNegative() {

		testDataForCleanUp();
		CleanupTestData.run(true);

		//Deleting StringCatalogItem
		List<StringCatalogItem__c> lststringCatalogItems = new List<StringCatalogItem__c>([SELECT Id
		        FROM StringCatalogItem__c
		        WHERE IsDefault__c != : false]);
		if (!lststringCatalogItems.isEmpty()) {
			delete lststringCatalogItems;
			System.assert(!lststringCatalogItems.isEmpty());
		}

		//Deleting UIControlAttribute
		List<UIControlAttribute__c> lstUiControlAttribute = new List<UIControlAttribute__c>([SELECT Id, IsDefault__c
		        FROM UIControlAttribute__c
		        WHERE IsDefault__c != : false]);
		if (!lstUiControlAttribute.isEmpty()) {
			delete lstUiControlAttribute;
			System.assert(!lstUiControlAttribute.isEmpty());
		}

		//Deleting UIControlAttributeType
		List<UIControlAttributeType__c> lstUiControlAttributeType = new List<UIControlAttributeType__c>([SELECT Id, IsDefault__c
		        FROM UIControlAttributeType__c
		        WHERE IsDefault__c != : false]);
		if (!lstUiControlAttributeType.isEmpty()) {
			delete lstUiControlAttributeType;
			System.assert(!lstUiControlAttributeType.isEmpty());
		}

		//Deleting UIControlAttributeGroup
		List<UIControlAttributeGroup__c> lstUiControlAttributeGroup = new List<UIControlAttributeGroup__c>([SELECT Id, IsDefault__c
		        FROM UIControlAttributeGroup__c
		        WHERE IsDefault__c != : false]);
		if (!lstUiControlAttributeGroup.isEmpty()) {
			delete lstUiControlAttributeGroup;
			System.assert(!lstUiControlAttributeGroup.isEmpty());
		}

		//Deleting UIControl
		List<UIControl__c> lstUIControl = new List<UIControl__c>([SELECT Id, IsDefault__c
		        FROM UIControl__c
		        WHERE IsDefault__c != : false]);
		if (!lstUIControl.isEmpty()) {
			delete lstUIControl;
			System.assert(!lstUIControl.isEmpty());
		}

		//Deleting UIControlType
		List<UIControlType__c> lstUIControlType = new List<UIControlType__c>([SELECT Id, IsDefault__c
		        FROM UIControlType__c
		        WHERE IsDefault__c != : false]);
		if (!lstUIControlType.isEmpty()) {
			delete lstUIControlType;
			System.assert(!lstUIControlType.isEmpty());
		}

		//Deleting UIControlGroup
		List<UIControlGroup__c> lstUIControlGroup = new List<UIControlGroup__c>([SELECT Id, IsDefault__c
		        FROM UIControlGroup__c
		        WHERE IsDefault__c != : false]);
		if (!lstUIControlGroup.isEmpty()) {
			delete lstUIControlGroup;
			System.assert(!lstUIControlGroup.isEmpty());
		}

		//Deleting Pageconfig
		List<PageConfig__c> lstPageConfig = new List<PageConfig__c>([SELECT Id, IsDefault__c
		        FROM PageConfig__c
		        WHERE IsDefault__c != : false]);
		if (!lstPageConfig.isEmpty()) {
			delete lstPageConfig;
			System.assert(!lstPageConfig.isEmpty());
		}

		//Deleting PageconfigType
		List<PageConfigType__c> lstPageConfigType = new List<PageConfigType__c>([SELECT Id, IsDefault__c
		        FROM PageConfigType__c
		        WHERE IsDefault__c != : false]);
		if (!lstPageConfigType.isEmpty()) {
			delete lstPageConfigType;
			System.assert(!lstPageConfigType.isEmpty());

		}

		//Deleting AppSetting
		List<AppSettings__c> lstAppSettings = new List<AppSettings__c>([SELECT Id, IsDefault__c
		        FROM AppSettings__c
		        WHERE IsDefault__c != : false]);
		if (!lstAppSettings.isEmpty()) {
			delete lstAppSettings;
			System.assert(!lstAppSettings.isEmpty());
		}

		//Deleting MobileDevice
		List<MobileDevice__c> lstmobileDevice = new List<MobileDevice__c>([SELECT Id, IsDefault__c
		        FROM MobileDevice__c
		        WHERE IsDefault__c != : false ]);
		if (!lstmobileDevice.isEmpty()) {
			delete lstmobileDevice;
			System.assert(!lstmobileDevice.isEmpty());
		}
	}
}