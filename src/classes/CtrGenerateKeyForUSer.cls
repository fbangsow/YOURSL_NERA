/*
@Company: YOUR SL  
@Author: K. Verheyden
@Creation date: 14.04.2015  
@Ref: xxxxxxx
*/ 
public with sharing class CtrGenerateKeyForUSer {
    
    public HistoryUserKeyGenerated__c userKey { get;set;}
    public String selectedAppSettingId {get; set;}
    public List<SelectOption> appSettingvalues {get;set;}

    public CtrGenerateKeyForUSer() {
        
        this.userKey = new HistoryUserKeyGenerated__c();
        
        appSettingvalues = new list<SelectOption>();
        for(AppSettings__c currentAppSetting : [SELECT id, Name, AppVersion__c, Hash_Key__c, mobileDevice__c 
                                                FROM AppSettings__c
                                                LIMIT 50000])
        {
            appSettingvalues.add(new SelectOption(currentAppSetting.Id, currentAppSetting.Name));
        }
        
    }

    public void generateKeyForUser(){

        UcbCrypto cryptor = new UcbCrypto();
        key__c key = key__c.getInstance('neradevelopment'); 
        jsonInfo jsondata = new jsonInfo();
        jsonData.clientId = key.ClientId__c;
        jsonData.secretkey = key.CustomerSecret__c;
        jsonData.appVersion = selectedAppSettingId;
        List<User> userData = [Select id from User where username =: key.UserName__c];
        if(!userData.isempty())
        {
            jsonData.userId = userData[0].id;
        }
        String  jsonResponse = JSON.serialize(jsonData);
        System.debug('jsonResponse ==>'+jsonResponse );
        UcbCrypto.Payload encryptedDate = cryptor.Encrypt(jsonResponse );
        System.debug('Payload data-->'+EncodingUtil.base64Encode(encryptedDate.data ));
        
        //UcbCrypto.Payload encryptedDate = cryptor.Encrypt('userid00000000,comsumerkey,cosnumercode ,token  ,systemuser,systempassword,appversion');
        
        this.userKey.publicKey__c = String.valueof(encryptedDate.cryptoKey);



        String encodedBlob = EncodingUtil.base64Encode(encryptedDate.data);

        this.userKey.deploymentData__c = encodedBlob;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,encodedBlob);
        ApexPages.addMessage(myMsg);
    }

    public void sendUserKey(){

    }
    
    
    public class jsonInfo
    {
        public String clientId;
        public String secretKey;
        //public String userName;
        public String userId;
        public String appVersion;
        
        jsonInfo parse(String json)
        {
            return (jsonInfo) System.JSON.deserialize(json, jsonInfo.class);
        }
    
    }
    
}