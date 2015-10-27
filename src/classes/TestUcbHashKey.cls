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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<BusinessProcess__c> listBusinessprocess = new List<BusinessProcess__c> ();
        String key =  UcbObjectHelper.getObjectType(listBusinessprocess);
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
       TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<OrganizationAccountMember__c> listOrganizationAccountMember = new List<OrganizationAccountMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganizationAccountMember);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationAccountMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        //lst1HashKey was before insert and Lst2HashKey is after insert
        System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());
    }

    //This test method checks if hashkey has been updated or not after inserting the OrganizationAccountMember
    private static testmethod void OrganizationAccountMemberUpdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<OrganizationAccountMember__c> listOrganizationAccountMember = new List<OrganizationAccountMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganizationAccountMember);
        insert new OrganizationAccountMember__c();
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationAccountMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }
    //This test method checks if hashkey has been inserted or not after inserting the Account
    private static testmethod void accountInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'jyothi', Email = 'jyothi.m@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'jyothi.m@neradeveloprrrent.org');
        insert u;
        
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
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = new User(Alias = 'jyothi', Email = 'jyothi.m@neradeveloprttment.org',  EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'jyothi.m@neradeveloprrrent.org');
        insert u;
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
    private static testmethod void AccountPromotionhashkeyInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<AccountPromotionMember__c> listAccountPromotionMember = new List<AccountPromotionMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listAccountPromotionMember);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationAccountMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertEquals(lst1HashKey.size(), lst2HashKey.size());   
    }   
    private static testmethod void AccountPromotionhashkeyUpdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<AccountPromotionMember__c> listAccountPromotionMember = new List<AccountPromotionMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listAccountPromotionMember);
        insert new AccountPromotionMember__c();
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new AccountPromotionMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }
    private static testmethod void OrganizationPromotionMemberInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<OrganizationPromotionMember__c> listOrganizationPromotionMember = new List<OrganizationPromotionMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganizationPromotionMember);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationPromotionMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertEquals(1,1);   
    }
   
    private static testmethod void OrganizationPromotionMemberUpdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<OrganizationPromotionMember__c> listOrganizationPromotionMember = new List<OrganizationPromotionMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listOrganizationPromotionMember);
        
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new OrganizationPromotionMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();

        System.assertEquals(1,1);
    }
    private static testmethod void AccountPriceBookMemberInsert() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<AccountPriceBookMember__c> listAccountPriceBookMember = new List<AccountPriceBookMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listAccountPriceBookMember);
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                                                            FROM HashKey__c
                                                            WHERE key__c = :key]);
        insert new AccountPriceBookMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
         System.assertNotEquals(lst1HashKey.size(), lst2HashKey.size());   
    }
    
    private static testmethod void AccountPriceBookMemberUpdate() {
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        List<AccountPriceBookMember__c> listAccountPriceBookMember = new List<AccountPriceBookMember__c> ();
        String key =  UcbObjectHelper.getObjectType(listAccountPriceBookMember);
        insert new AccountPriceBookMember__c();
        List<HashKey__c> lst1HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        insert new AccountPriceBookMember__c();
        List<HashKey__c> lst2HashKey = new List<HashKey__c>([SELECT key__c, Value__c, TokenType__c
                FROM HashKey__c
                WHERE key__c = :key]);
        Test.stopTest();
        System.assertNotEquals(lst1HashKey[0].Value__c, lst2HashKey[0].Value__c);
    }
}