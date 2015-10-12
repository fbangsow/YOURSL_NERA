/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :07/08/2015
@Reference      :
*/
public with sharing class UcbHashKey {

    public static void upsertHashKeyValue(List<Sobject> myObject) {

        updateHashKeyAndValue(myObject, generateHashValue());
    }

    public static String generateHashValue() {

        return  String.valueOf(DateTime.now().getTime());

    }

    public static void updateHashKeyAndValue(List<Sobject> myObject, String hashValue) {

        String key =  UcbObjectHelper.getObjectType(myObject);
        System.debug('object type---------------' + key);
        HashKey__c myHashKey;
        List<HashKey__c > listMyHashKey = [SELECT id, Key__c, Value__c, TokenType__c
                                           FROM HashKey__c
                                           WHERE Key__c = :key LIMIT 1];
        if (!listMyHashKey.isEmpty()) {
            myHashKey = listMyHashKey[0];
            myHashKey.Value__c = hashValue;
            myHashKey.TokenType__c = indentifyTokenType(key);
        } else {
            myHashKey = new HashKey__c(Key__c = key, Value__c = hashValue, TokenType__c = indentifyTokenType(key));
        }
        upsert myHashKey;
    }
    private static String indentifyTokenType(String ObjectName) {

        Map<String, String> mapLogic = new Map<String, String>();
        mapLogic.put('Account', 'DataType');
        mapLogic.put('Event', 'DataType');
        mapLogic.put('Order', 'DataType');
        mapLogic.put('Contact', 'DataType');
        mapLogic.put('Businessprocess__c', 'AppType');
        mapLogic.put('BusinessProcessParameter__c', 'AppType');
        mapLogic.put('OrganizationAccountMember__c', 'AppType');
        
        mapLogic.put('Organization__c', 'AppType');
        mapLogic.put('Product2', 'AppType');
        mapLogic.put('ProductGroup__c', 'AppType');
        mapLogic.put('Pricebook2', 'AppType');
        mapLogic.put('Promotion__c', 'AppType');
        mapLogic.put('AccountPromotionMember__c', 'AppType');
        mapLogic.put('AccountPriceBookMember__c', 'AppType');
        mapLogic.put('OrganizationPromotionMember__c', 'AppType');

        return mapLogic.get(ObjectName);

    }
}