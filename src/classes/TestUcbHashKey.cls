/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :25/07/2015
@Reference      :
*/
@IsTest
private class TestUcbHashKey {

    //This test method checks if hashkey has been created or not after inserting the BusinessProcess
    private static testmethod void businessLogicForInsert() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<BusinessProcess__c> listBusinessprocess = new List<BusinessProcess__c> ();

        String key =  UcbObjectHelper.getObjectType(listBusinessprocess);
        
        system.debug('key-------------1-------------'+key);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                                                             FROM HashKey__c
                                                             WHERE key__c = :key]);
        insert new BusinessProcess__c(Name = 'Account custom search');
        //UcbHashKey.indentifyTokenType(Key);
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                                                             FROM HashKey__c
                                                             WHERE key__c = :key]);
        system.debug('--------'+lst2HashKey);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }

    //This test method checks if hashkey has been updated or not after inserting the BusinessProcess
    private static testmethod void businessLogicForUpdate() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<BusinessProcess__c> listBusinessprocess = new List<BusinessProcess__c> ();
        String key =  UcbObjectHelper.getObjectType(listBusinessprocess);

        //UcbHashKey.indentifyTokenType(key);
        insert new BusinessProcess__c(Name = 'Account custom search');
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                                                             FROM HashKey__c
                                                             WHERE key__c = :key]);
        insert new BusinessProcess__c(Name = 'Account custom search2');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }

    //This test method checks if hashkey has been created or not after inserting the BusinessProcessParameter
    private static testmethod void businessParameterLogicForInsert() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<BusinessProcessParameter__c> listBusinessprocessParameter = new List<BusinessProcessParameter__c> ();
        String key =  UcbObjectHelper.getObjectType(listBusinessprocessParameter);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new BusinessProcessParameter__c(Name = 'filter');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }

    //This test method checks if hashkey has been updated or not after inserting the BusinessProcessParameter
    private static testmethod void businessParameterLogicForUpdate() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<BusinessProcessParameter__c> listBusinessprocessParameter = new List<BusinessProcessParameter__c> ();
        String key =  UcbObjectHelper.getObjectType(listBusinessprocessParameter);
        insert new BusinessProcessParameter__c(Name = 'filter');
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new BusinessProcessParameter__c(Name = 'filter2');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }

    //This test method checks if hashkey has been created or not after inserting the Organization
    private static testmethod void OrganizationInsert() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<Organization__c> listOrganization = new List<Organization__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganization);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new Organization__c(Name = 'Moldtek');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }

    //This test method checks if hashkey has been updated or not after inserting the Organization
    private static testmethod void OrganizatioUpdate() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<Organization__c> listOrganization = new List<Organization__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganization);
        insert new Organization__c(Name = 'Moldtek');
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new Organization__c(Name = 'Moldtek2');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }

    
    //This test method checks if hashkey has been inserted or not after inserting the OrganizationAccountMember
    private static testmethod void OrganizationAccountMemberInsert() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        Account acc  = new Account();
        acc.Name = 'testAccount';
        Insert acc;

        Organization__c org = new Organization__c();
            org.Name = 'testorg';
        Insert org;

        List<OrganizationAccountMember__c> listOrganizationAccountMember = new List<OrganizationAccountMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganizationAccountMember);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationAccountMember__c(Organization__c = org.Id,Account__c = acc.Id);
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }

    //This test method checks if hashkey has been updated or not after inserting the OrganizationAccountMember
    private static testmethod void OrganizationAccountMemberUpdate() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        Account acc  = new Account();
        acc.Name = 'testAccount';
        Insert acc;

        Organization__c org = new Organization__c();
            org.Name = 'testorg';
        Insert org;
        List<OrganizationAccountMember__c> listOrganizationAccountMember = new List<OrganizationAccountMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganizationAccountMember);
        insert new OrganizationAccountMember__c(Organization__c = org.Id,Account__c = acc.Id);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationAccountMember__c(Organization__c = org.Id,Account__c = acc.Id);
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }
    //This test method checks if hashkey has been inserted or not after inserting the Account
    private static testmethod void accountInsert() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<Account>  listAccount = new List<Account> ();
        String key =  UcbObjectHelper.getObjectType(listAccount);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new Account(Name = 'Genepoint');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }
    //This test method checks if hashkey has been updated or not after inserting the Account
    private static testmethod void accountUpdate() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        List<Account> listAccount = new List<Account> ();
        String key =  UcbObjectHelper.getObjectType(listAccount);
        insert new Account(Name = 'Genepoint');
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new Account(Name = 'Genepoint2');
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }

    //This test method checks if hashkey has been inserted or not after inserting the Event
    private static testmethod void eventInsert() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'jyothi', Email = 'jyothi.m@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'jyothi.m@neradeveloprrrent.org');
        insert u;
        
        Account acc = new Account(name = 'test');
        insert acc;

        VisitFrequencyPlanning__c visit = new VisitFrequencyPlanning__c(Name = 'test',TimePeriodEnd__c = system.today()+1,TimePeriodStart__c=system.today(),Account__c = acc.id);
        insert visit;
        
        List<Event>  listEvent = new List<Event> ();
        String key =  UcbObjectHelper.getObjectType(listEvent);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new Event(Subject='event for testing hashkey',EndDateTime=system.today()+1,StartDateTime=system.today());
        
        
        
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }
    //This test method checks if hashkey has been updated or not after inserting the Event
    private static testmethod void eventtUpdate() {
        Test.startTest();
        CleanupTestData.createNeraTriggerCustomSetting();
	    
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'jyothi', Email = 'jyothi.m@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'jyothi.m@neradeveloprrrent.org');
        insert u;
        
        Account acc = new Account(name = 'test');
        insert acc;

        VisitFrequencyPlanning__c visit = new VisitFrequencyPlanning__c(Name = 'test',TimePeriodEnd__c = system.today()+1,TimePeriodStart__c=system.today(),Account__c = acc.id);
        insert visit;
        
        List<Event> listEvent = new List<Event> ();
        String key =  UcbObjectHelper.getObjectType(listEvent);
        insert new Event(Subject='event for testing hashkey',EndDateTime=system.today()+1,StartDateTime=system.today());
        
        
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        
        insert new Event(Subject='event for testing hashkey2',EndDateTime=system.today()+1,StartDateTime=system.today());
        
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }
}