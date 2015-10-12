public with sharing class CtrOrgRecordCount {
    public Integer totalCount{get;set;}  
    public Map<String,Integer> recordCount{
        get{
            Map<String,Integer> mapReccordCount = new Map<String,Integer>();
            mapReccordCount.put('MobileDevice',[SELECT Count() FROM MobileDevice__c LIMIT 50000]);
            mapReccordCount.put('AppSettings',[SELECT Count() FROM AppSettings__c LIMIT 50000]);
            mapReccordCount.put('PageConfig',[SELECT Count() FROM PageConfig__c LIMIT 50000]);
            mapReccordCount.put('UIControl',[SELECT Count() FROM UIControl__c LIMIT 50000]);
            mapReccordCount.put('UIControlGroup',[SELECT Count() FROM UIControlGroup__c LIMIT 50000]);
            mapReccordCount.put('UIControlType',[SELECT Count() FROM UIControlType__c LIMIT 50000]);
            mapReccordCount.put('UIControlAttribute',[SELECT Count() FROM UIControlAttribute__c LIMIT 50000]);
            mapReccordCount.put('UIControlAttributeGroup',[SELECT Count() FROM UIControlAttributeGroup__c LIMIT 50000]);
            mapReccordCount.put('UIControlAttributeType',[SELECT Count() FROM UIControlAttributeType__c LIMIT 50000]);
            mapReccordCount.put('PageConfigType',[SELECT Count() FROM PageConfigType__c LIMIT 50000]);
            mapReccordCount.put('Businessprocess',[SELECT Count() FROM Businessprocess__c LIMIT 50000]);
            mapReccordCount.put('BusinessProcessParameter',[SELECT Count() FROM BusinessProcessParameter__c LIMIT 50000]);
            totalCount =0;
            for(Integer i :  mapReccordCount.values()){
                totalCount = totalCount+i;
            }                       
            return mapReccordCount;
        }set;
    }
}