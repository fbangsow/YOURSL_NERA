/*
@Company:Your SL
@Author:Prakash
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/GenerateScript/*')

global class WsGenerateScript implements UcbWs {

	private static string output = '';
	public static UcbWsResponse doReply(UcbWsRequest request) {
		return new UcbWsResponse();
	}

	@HttpGet
	global static void wsGet() {

		//create Request
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		// do businesslogic
		if(myRequest.resquestedByUser != null) {

			//string outputs = 'public with sharing class PostDeployment {'+'\n'+
	  //                        'public PostDeployment() {'+'\n'+
			//				  'if(validate()){'+'\n'+
			//				'appSettings();'+'\n'+
			//				'businessParameters();'+'\n'+
			//				'populateDefaultValues();'+'\n'+
			//				'}else{'+'\n'+
			//				'System.debug(\'something went wrong\');'+'\n'+
			//				'}'+'\n'+
			//				'}'+'\n'+'\n'+
			//				'public boolean validate() {'+'\n'+
			//				'return true;'+'\n'+
			//				'}'+'\n'+'\n'+
			//				'public void appSettings() {'+'\n';
			string outputs ='';

			String[] arguments ;
			String formattedString;

			if(true) {

				//mobile device for ipad air 2
				string mobileDeviceTemplateString='MobileDevice__c mobleDevice = new MobileDevice__c('+
				'Name = \'\'{0}\'\',' +'\n'+
				'operatingSystem__c = \'\'{1}\'\','+'\n'+
				'XBezel__c = {2},'+'\n'+
				'XFrame__c = {3},'+'\n'+
				'YBezel__c = {4},'+'\n'+
				'YFrame__c = {5},'+'\n'+
				'width__c = {6},'+'\n'+
				'height__c = {7},'+'\n'+
				'IsDefault__c = {8}'+'\n'+
				');' + 
				'\n';

				//App Settings
				string appSettingsTemplateString='List<AppSettings__c> appSettingsList = new List<AppSettings__c>();'+
				'\n'+
				'appSettingsList.add( new AppSettings__c('+'\n'+
				'mobileDevice__c = mobleDevice.Id,'+'\n'+
				'Name = \'\'{0}\'\',' +'\n'+
				'version__c = \'\'{1}\'\',' +'\n'+
				'AppVersion__c = {2},'+'\n'+
				'IsDefault__c = {3}'+'\n'+
				')'+
				');'+ 
				'\n';

				//Page Config Type
				string pageConfigTypeTemplateString='pageConfigTypeList.add( new PageConfigType__c('+				
				'Name = \'\'{0}\'\',' +
				'IsDefault__c = {1}'+	
				')'+
				');'+ 
				'\n';
				
				//Page Config
				string pageConfigTemplateString='pageConfigList.add( new PageConfig__c('+
				'Name = \'\'{0}\'\',' +'\n'+
				'AppSetting__c = appSettingsList[0].Id,' +'\n'+
				'BackGround_Color__c = \'\'{1}\'\',' +'\n'+
				'PageConfigTypeId__c = pageConfigTypeMap.get(\'\'{2}\'\'),' +'\n'+
				'Height__c = {3},' +'\n'+
				'Width__c = {4},' +'\n'+
				'XCoordinate__c = {5},' +'\n'+
				'YCoordinate__c = {6},' +'\n'+
				'IsDefault__c = {7}'+'\n'+
				')'+
				');'+ 
				'\n';

				//UIControl Type
				string uiControlTypeTemplateString='uiControlTypeList.add( new UIControlType__c('+				
				'Name = \'\'{0}\'\',' +
				'IsDefault__c = {1}'+	
				')'+
				');'+ 
				'\n';

				//UIControl Group
				string uiControlGroupTemplateString='uiControlGroupList.add( new UIControlGroup__c('+				
				'Name = \'\'{0}\'\',' +
				'IsDefault__c = {1}'+	
				')'+
				');'+ 
				'\n';

				//UIControl
				string uiControlTemplateString='uiControlList.add( new UIControl__c('+
				'Name = \'\'{0}\'\',' +'\n'+
				'PageConfigName__c =  pageConfigMap.get(\'\'{1}\'\'),' +'\n'+
				'UIControlTypeId__c =  uiControlTypeMap.get(\'\'{2}\'\'),' +'\n'+
				'UIControlGroupId__c =  uiControlGroupMap.get(\'\'{3}\'\'),' +	'\n'+				
				'Height__c = {4},' +'\n'+
				'Width__c = {5},' +'\n'+
				'XCoordinate__c = {6},' +'\n'+
				'YCoordinate__c = {7},' +'\n'+
				'Type__c = \'\'{8}\'\',' +'\n'+
				'Value__c = \'\'{9}\'\',' +'\n'+
				'Order__c = {10},' +'\n'+
				'IsDefault__c = {11}'+'\n'+
				')'+
				');'+ 
				'\n';

				//UIControl Attribute Type
				string uiControlAttributeTypeTemplateString='uiControlAttributeTypeList.add( new UIControlAttributeType__c('+				
				'Name = \'\'{0}\'\',' +
				'IsDefault__c = {1}'+	
				')'+
				');'+ 
				'\n';

				//UIControl Attribute Group
				string uiControlAttributeGroupTemplateString='uiControlAttributeGroupList.add( new UIControlAttributeGroup__c('+				
				'Name = \'\'{0}\'\',' +
				'IsDefault__c = {1}'+	
				')'+
				');'+ 
				'\n';

				//UIControl Attribute
				string uiControlAttributeTemplateString='uiControlAttributeList.add( new UIControlAttribute__c('+
				'Name = \'\'{0}\'\',' +'\n'+
				'UIControlId__c =  uiControlMap.get(\'\'{1}\'\'),' +'\n'+
				'UIControlAttributeTypeId__c =  uiControlAttributeTypeMap.get(\'\'{2}\'\'),' +'\n'+
				'UIControlAttributeGroupId__c =  uiControlAttributeGroupMap.get(\'\'{3}\'\'),' +'\n'+				
				'DataObjectType__c = \'\'{4}\'\',' +'\n'+
				'Value__c = \'\'{5}\'\',' +'\n'+
				'Order__c = {6},' +'\n'+
				'IsDefault__c = {7}'+'\n'+
				')'+
				');'+ 
				'\n';

				//String Catalog Item
				string stringCatalogItemTemplateString='stringCatalogItemsList.add( new StringCatalogItem__c('+'\n'+				
				'EnumCode__c = \'\'{0}\'\',' +'\n'+
				'Language__c = \'\'{1}\'\',' +'\n'+
				'Type__c = \'\'{2}\'\',' +'\n'+
				'Text__c = \'\'{3}\'\','+'\n'+
				'IsDefault__c = {4}'+'\n'+
				')'+
				');'+ 
				'\n';

				List<MobileDevice__c> mobileDevicesList = [SELECT Name,
																  OperatingSystem__c,
														          XBezel__c,
														          XFrame__c,
														          YBezel__c,
														          YFrame__c,
														          Width__c,
														          Height__c,
														          IsDefault__c
														  FROM MobileDevice__c 
														  WHERE name='IPadAir2'];
				
				for(MobileDevice__c mobDevice : mobileDevicesList)
				{					
					arguments = new String[] {	mobDevice.Name ,
												mobDevice.OperatingSystem__c,
												String.valueOf(mobDevice.XBezel__c), 
												String.valueOf(mobDevice.XFrame__c),
												String.valueOf(mobDevice.YBezel__c),
												String.valueOf(mobDevice.YFrame__c),
												String.valueOf(mobDevice.Width__c),
												String.valueOf(mobDevice.Height__c),
												String.valueOf(mobDevice.IsDefault__c)
											};
					formattedString = String.format(mobileDeviceTemplateString, arguments);

					outputs += formattedString+'\n';

					outputs += 'insert mobleDevice;'+
						'\n'+
						'System.debug(\'Mobile Device is inserted successfully\');'+
						'\n';

					List<AppSettings__c> appSettingsList = [SELECT Name,
															       Version__c,
															       AppVersion__c,
															       IsDefault__c
															FROM AppSettings__c 
															WHERE mobileDevice__c =: mobDevice.Id];															 
					for(AppSettings__c appSetting : appSettingsList)
					{

						arguments = new String[] {	appSetting.Name ,
												    appSetting.Version__c,
												    String.valueOf(appSetting.AppVersion__c),
												    String.valueOf(appSetting.IsDefault__c)
												};
						formattedString = String.format(appSettingsTemplateString, arguments);

						outputs += formattedString+'\n';

						outputs += 'insert appSettingsList;'+
						'\n'+
						'System.debug(\'App Settings is inserted successfully\');'+
						'\n';
						
						List<PageConfigType__c> pageConfigTypeList= [SELECT Name,
																		    IsDefault__c
																	 FROM PageConfigType__c];																	   
						outputs +='List<PageConfigType__c> pageConfigTypeList = new List<PageConfigType__c>();'+'\n';
						
						for(PageConfigType__c pgConfigType : pageConfigTypeList)
						{
							arguments = new String[] {pgConfigType.Name,
													  String.valueOf(pgConfigType.IsDefault__c)
													};
							formattedString = String.format(pageConfigTypeTemplateString, arguments);

							outputs += formattedString+'\n';
							
						}			
						outputs += 'insert pageConfigTypeList;'+
						'\n'+
						'System.debug(\'Page Config Type List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> pageConfigTypeMap = new Map<String,Id>();'+
						'\n'+
						'for(PageConfigType__c pageConfigTypeObj:pageConfigTypeList){'+
						'\n'+
						'pageConfigTypeMap.put(pageConfigTypeObj.Name,pageConfigTypeObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';
						List<pageconfig__c> pageConfigList =[SELECT  Name, 
																	 BackGround_Color__c, 
																	 PageConfigTypeId__r.Name,
																	 Height__c,
																	 Width__c,
																	 XCoordinate__c,
																	 YCoordinate__c,
																	 IsDefault__c
                                          					  FROM pageconfig__c 
                                                              WHERE appsetting__c =:appSetting.ID 
                                                              ORDER by id asc];                                                                 

						outputs +='List<PageConfig__c> pageConfigList = new List<PageConfig__c>();'+'\n';
						List<string> pageConfigIDsList = new List<string>();
						for(pageconfig__c pgConfig : pageConfigList)
						{
							arguments = new String[] {	pgConfig.Name,
														pgConfig.BackGround_Color__c,
														pgConfig.PageConfigTypeId__r.Name,
														String.valueOf(pgConfig.Height__c),
														String.valueOf(pgConfig.Width__c),
														String.valueOf(pgConfig.XCoordinate__c),
														String.valueOf(pgConfig.YCoordinate__c),
														String.valueOf(pgConfig.IsDefault__c)
													};
							formattedString = String.format(pageConfigTemplateString, arguments);

							outputs += formattedString+'\n';
							pageConfigIDsList.add(pgConfig.ID);
						}	
						outputs += 'insert pageConfigList;'+
						'\n'+
						'System.debug(\'Page Config List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> pageConfigMap = new Map<String,Id>();'+
						'\n'+
						'for(PageConfig__c pageConfigObj:pageConfigList){'+
						'\n'+
						'pageConfigMap.put(pageConfigObj.Name,pageConfigObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';

						List<UIControlType__c> uiControlTypeList= [SELECT Name,
																		  IsDefault__c
																   FROM UIControlType__c];																	
						outputs +='List<UIControlType__c> uiControlTypeList = new List<UIControlType__c>();'+'\n';
						for(UIControlType__c uiControlType : uiControlTypeList)
						{
							arguments = new String[] {uiControlType.Name,
													  String.valueOf(uiControlType.IsDefault__c)
													 };
							formattedString = String.format(uiControlTypeTemplateString, arguments);

							outputs += formattedString+'\n';
						}			
						outputs += 'insert uiControlTypeList;'+
						'\n'+
						'System.debug(\'UI Control Type List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> uiControlTypeMap = new Map<String,Id>();'+
						'\n'+
						'for(UIControlType__c uiControlTypeObj:uiControlTypeList){'+
						'\n'+
						'uiControlTypeMap.put(uiControlTypeObj.Name,uiControlTypeObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';

						List<UIControlGroup__c> uiControlGroupList= [SELECT Name,
					                                                        IsDefault__c 
																	 FROM UIControlGroup__c];																	  
						outputs +='List<UIControlGroup__c> uiControlGroupList = new List<UIControlGroup__c>();'+'\n';
						for(UIControlGroup__c uiControlGroup : uiControlGroupList)
						{
							arguments = new String[] {uiControlGroup.Name,
							                          String.valueOf(uiControlGroup.IsDefault__c)
							                         };
							formattedString = String.format(uiControlGroupTemplateString, arguments);

							outputs += formattedString+'\n';
						}			
						outputs += 'insert uiControlGroupList;'+
						'\n'+
						'System.debug(\'UI Control Group List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> uiControlGroupMap = new Map<String,Id>();'+
						'\n'+
						'for(UIControlGroup__c uiControlGroupObj:uiControlGroupList){'+
						'\n'+
						'uiControlGroupMap.put(uiControlGroupObj.Name,uiControlGroupObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';

						List<UIControl__c> uiControlList= [SELECT Name,
																  PageConfigName__r.Name,
																  UIControlTypeId__r.Name,
																  UIControlGroupId__r.Name,
																  Height__c,
																  Width__c,
																  XCoordinate__c,
																  YCoordinate__c,
																  Type__c,
																  Value__c,
																  Order__c,
																  IsDefault__c
														   FROM UIControl__c 
														   WHERE PageConfigName__c IN : pageConfigIDsList 
														   ORDER by PageConfigName__c asc];															
						outputs +='List<UIControl__c> uiControlList = new List<UIControl__c>();'+'\n';
						List<string> uiControlIds = new List<string>();
						for(UIControl__c uiControl : uiControlList)
						{
							arguments = new String[] {uiControl.Name,
												      uiControl.PageConfigName__r.Name,
												      uiControl.UIControlTypeId__r.Name,
													  uiControl.UIControlGroupId__r.Name,
													  String.valueOf(uiControl.Height__c),
													  String.valueOf(uiControl.Width__c),
													  String.valueOf(uiControl.XCoordinate__c),
													  String.valueOf(uiControl.YCoordinate__c),
													  uiControl.Type__c,uiControl.Value__c,
													  String.valueOf(uiControl.Order__c),
													  String.valueOf(uiControl.IsDefault__c)
													};
							formattedString = String.format(uiControlTemplateString, arguments);

							outputs += formattedString+'\n';	
							uiControlIds.add(uiControl.Id);						
						}
						outputs += 'insert uiControlList;'+
						'\n'+
						'System.debug(\'UI Control List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> uiControlMap = new Map<String,Id>();'+
						'\n'+
						'for(UIControl__c uiControlObj:uiControlList){'+
						'\n'+
						'uiControlMap.put(uiControlObj.Name,uiControlObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';

						List<UIControlAttributeType__c> uiControlAttributeTypeList= [SELECT Name,
						                                                                    IsDefault__c
																                     FROM UIControlAttributeType__c];																	                  
						outputs +='List<UIControlAttributeType__c> uiControlAttributeTypeList = new List<UIControlAttributeType__c>();'+'\n';
						for(UIControlAttributeType__c uiControlAttributeType : uiControlAttributeTypeList)
						{
							arguments = new String[] {uiControlAttributeType.Name,
							                          String.valueOf(uiControlAttributeType.IsDefault__c)
							                         };
							formattedString = String.format(uiControlAttributeTypeTemplateString, arguments);

							outputs += formattedString+'\n';
						}			
						outputs += 'insert uiControlAttributeTypeList;'+
						'\n'+
						'System.debug(\'UI Control Attribute Type List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> uiControlAttributeTypeMap = new Map<String,Id>();'+
						'\n'+
						'for(UIControlAttributeType__c uiControlAttributeTypeObj:uiControlAttributeTypeList){'+
						'\n'+
						'uiControlAttributeTypeMap.put(uiControlAttributeTypeObj.Name,uiControlAttributeTypeObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';

						List<UIControlAttributeGroup__c> uiControlAttributeGroupList= [SELECT Name,
						                                                                      IsDefault__c
																	                   FROM UIControlAttributeGroup__c];																		                
						outputs +='List<UIControlAttributeGroup__c> uiControlAttributeGroupList = new List<UIControlAttributeGroup__c>();'+'\n';
						for(UIControlAttributeGroup__c uiControlAttributeGroup : uiControlAttributeGroupList)
						{
							arguments = new String[] {uiControlAttributeGroup.Name,
							                          String.valueOf(uiControlAttributeGroup.IsDefault__c)
							                         };
							formattedString = String.format(uiControlAttributeGroupTemplateString, arguments);

							outputs += formattedString+'\n';
						}			
						outputs += 'insert uiControlAttributeGroupList;'+
						'\n'+
						'System.debug(\'UI Control Attribute Group List is inserted successfully\');'+
						'\n'+
						'Map<String,Id> uiControlAttributeGroupMap = new Map<String,Id>();'+
						'\n'+
						'for(UIControlAttributeGroup__c uiControlAttributeGroupObj:uiControlAttributeGroupList){'+
						'\n'+
						'uiControlAttributeGroupMap.put(uiControlAttributeGroupObj.Name,uiControlAttributeGroupObj.Id);'+
						'\n'+
						'}'+
						'\n'+'\n';


						List<UIControlAttribute__c> uiControlAttributeList= [SELECT Name,
																					UIControlId__r.Name,
																			        UIControlAttributeTypeId__r.Name ,
																					UIControlAttributeGroupId__r.Name,
																					DataObjectType__c,
																					Value__c,
																					Order__c,
																					IsDefault__c
                                                           					 FROM UIControlAttribute__c 
                                                           					 WHERE UiControlId__c IN: uiControlIds];                                                               					
						outputs +='List<UIControlAttribute__c> uiControlAttributeList = new List<UIControlAttribute__c>();'+'\n';						
						for(UIControlAttribute__c uiCtrlAttribute : uiControlAttributeList)
						{
							arguments = new String[] {uiCtrlAttribute.Name,
											          uiCtrlAttribute.UIControlId__r.Name,
													  uiCtrlAttribute.UIControlAttributeTypeId__r.Name,
													  uiCtrlAttribute.UIControlAttributeGroupId__r.Name,
													  uiCtrlAttribute.DataObjectType__c,
													  uiCtrlAttribute.Value__c,
													  String.valueOf(uiCtrlAttribute.Order__c),
													  String.valueOf(uiCtrlAttribute.IsDefault__c)
													};
							formattedString = String.format(uiControlAttributeTemplateString, arguments);

							outputs += formattedString+'\n';	
												
						}
						outputs += 'insert uiControlAttributeList;'+
						'\n'+
						'System.debug(\'UI Control Attribute List is inserted successfully\');'+
						'\n';				


						List<StringCatalogItem__c> stringCatalogItemList= [SELECT 	EnumCode__c,
																					Language__c,
																					Type__c,
																					Text__c,
																					IsDefault__c
                                                        				   FROM StringCatalogItem__c ];
                                                        
						outputs +='List<StringCatalogItem__c> stringCatalogItemsList = new List<StringCatalogItem__c>();'+'\n';
						for(StringCatalogItem__c stringCatalogItem : stringCatalogItemList)
						{
							arguments = new String[] {stringCatalogItem.EnumCode__c,
													  stringCatalogItem.Language__c,
													  stringCatalogItem.Type__c,
													  stringCatalogItem.Text__c,
							                          String.valueOf(stringCatalogItem.IsDefault__c)
							                         };
							formattedString = String.format(stringCatalogItemTemplateString, arguments);

							outputs += formattedString+'\n';
						}			
						outputs += 'insert stringCatalogItemsList;'+
						'\n'+
						'System.debug(\'String Catalog Item List is inserted successfully\');'+
						'\n';	
					}
				}
				//outputs +='}'+'\n'+'\n'+
				//		   'public void businessParameters() {'+'\n'+
				//			'}'+'\n'+'\n'+
				//			'public void populateDefaultValues() {'+'\n'+
				//			'PopulateDefaultValues defaultvalues = new PopulateDefaultValues();'+'\n'+
				//			'}'+'\n'+
				//			'}';
				RestContext.response.responseBody = Blob.valueOf(outputs);
				//RestContext.response.addHeader('size', String.valueOf(listAccountWrapper.Size()));
			} else {
				RestContext.response.addHeader('size', '0');
			}
			RestContext.response.statusCode = 200;
		} else {
			RestContext.response.addHeader('errorMessage' , myRequest.errorMessage);
			RestContext.response.statusCode = myRequest.statusCode;
		}
		RestContext.response.addHeader('Content-Type', 'application/json');
	}


	public static void dumpFields(String relatedField, Map<String, Object> queriedFieldValues)
    {
        for(String queriedFieldName : queriedFieldValues.keySet())
        {
            // Skip this information, its not a field
            if(queriedFieldName.equals('attributes'))
                break;
            // Check if the queried value represents a related field reference?
            Object queriedFieldValue = queriedFieldValues.get(queriedFieldName);
            if(queriedFieldValue instanceof Map<String,Object>)
                dumpFields(queriedFieldName + '.', (Map<String, Object>) queriedFieldValue);
            else
            {
                System.debug(relatedField + queriedFieldName + ' = ' + queriedFieldValue);
                output = output + '\n' + relatedField + queriedFieldName + ' = ' + queriedFieldValue;
            }
        }       
    }

	public static void demo()
    {
        List<pageconfig__c> pageconfigs = [SELECT Id , Name, appsetting__c, image__c, BackGround_Color__c, CreatedById 
                                           FROM pageconfig__c 
                                           WHERE appsetting__c = 'a0124000002M3NBAA0'];

        for(pageconfig__c config : pageconfigs){
	        Map<String, Object> queriedFieldValues = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(config));
	        dumpFields('', queriedFieldValues);
    	}
    }
	


	
}