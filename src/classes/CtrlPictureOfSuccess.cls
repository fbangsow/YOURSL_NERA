public with sharing class CtrlPictureOfSuccess {

    public String selectAppseting { get; set; }

    public List<PageConfig__c> listofPictureOfSuccess { get; set; }

    public List<Selectoption> appsettingList { get; set; }
   


    public void GetPosrec() {
    
   listofPictureOfSuccess  = [select id,Name from PageConfig__c where AppSetting__c=:selectAppseting];
   
  system.debug('........linenumber15......' +ListofPictureOfSuccess);
 
 
      
    }

 public CtrlPictureOfSuccess()
 {
 
 appsettingList =new List<selectoption>();

List<AppSettings__c> listAppsetting = [SELECT id,Name From  AppSettings__c  Limit 10];

 for(AppSettings__c appSettring : listAppsetting)
 {

appsettingList.add(new Selectoption(appSettring.id,appSettring.Name));


 }

 }
 
 
 
  
}