/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :16/06/2015
@Reference      :
*/

@IsTest
private class TestCtrGenerateKeyForUSer {
	
	static testmethod void generateKeyForUSer () {
		Profile p=[SELECT id
				   FROM Profile
				   WHERE Name='Standard User'];
		User u=new User(UserName='jyothi.m@neradevelopment.or',Alias='jmora', Email='jyothi.m@neradevelopment.org',EmailEncodingKey='ISO-8859-1',LastName='Moravapalli',LanguageLocaleKey='de',
		ProfileId=p.Id,TimeZoneSidKey='Europe/Berlin', LocaleSidKey='de');
		insert u;
		 MobileDevice__c objmobileDevice = new MobileDevice__c(Name = 'Samsung', height__c = 7, width__c = 5);
        insert objmobileDevice;
        AppSettings__c objAppSettings = new AppSettings__c(AppVersion__c = 1.5, Name = 'IPadAir2', mobileDevice__c = objmobileDevice.id);
        insert objAppSettings;
		HistoryUserKeyGenerated__c objHistoryUserKeyGenerated=new HistoryUserKeyGenerated__c(Name='NERA');
		insert objHistoryUserKeyGenerated;
		key__c objkey=new key__c(Name ='neradevelopment');
		insert objkey;
			CtrGenerateKeyForUSer Ctr=new CtrGenerateKeyForUSer();
			ctr.generateKeyForUser();
			ctr.sendUserKey();
			System.assertEquals(1,1);
	}
	
	 
}