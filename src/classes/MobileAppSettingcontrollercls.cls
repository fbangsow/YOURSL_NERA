public with sharing class MobileAppSettingcontrollercls {

public List<PageConfig__c>pageconfig  {get;set;}

public AppSettings__c app{get;set;}

public string appid{get;set;}

public string AppSettingDatatext{get;set;}

public List<PageConfig__c>PageconfigList{get;set;}
// public List<PageConfig__c> listp {get;set;}

    public MobileAppSettingcontrollercls(ApexPages.StandardSetController controller) {

    }
    
    public void PageConfigdetails()
    {
    }
    
    public void NewAppsettingMethod()
    {
    }
    
    
    public pagereference SaveNewAppSetting()
    {
    
     insert app;
    pagereference ref=new pagereference('/apex/MobileAppConfiguration');
    ref.setredirect(true);
   return ref;
   
    }
    
    public pagereference saveUIController()
    {
    return null;
    }
     
    Public pagereference Cancelrec()
    {
    return null;
    }
    
    Public void GetAppsettingvalue()
    {
    
    }
    
     
  
  
   
    
}