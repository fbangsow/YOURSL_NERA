/*
 @Company: YOUR SL  
 @Author: Your name   
 @Creation date: dd/mm/yyyy   
 @Ref: xxxxxxx
*/
Public with sharing class MobileAppSettingsController {


 Public List<PageConfig__c> PageConfiglist{Set; Get;}
 Public List<UIControl__c> Uicontrollerslist{Set; Get;}
 Public List<AppSettings__c> AppSettingslist{Set; Get;}
 Public List<UIControl__c> Uicontrollerslist1 { get; set; }
 Public List<SelectOption> listpage {Get;Set;}
 Public String PageConfigselect{Get;Set;}
 Public String Selectedappsettings{Set; Get;}
 Public String Selecteduicontrollers{Get;Set;}
 

        Public Map <String,AppSettings__c> mapstrapps = new Map <String,AppSettings__c>();
        Public Map <String,PageConfig__c> mapstrpage = new Map <String,PageConfig__c>();
    
        Public MobileAppSettingsController()
        {
        AppSettingslist = New List<AppSettings__c>();

            For(AppSettings__c app:[Select id,name,(select id,name from PageConfigs__r) From AppSettings__c])
            {
            AppSettingslist.add(app);
            mapstrapps.Put(app.ID,app);
            }
 
        }
        Public void Pageuicon() {

        PageConfiglist = new List<PageConfig__c>();
           if(PageConfigselect!='none')
            {
                for(PageConfig__c pagcon:[select id,name,(select name,Height__c,Width__c,XCoordinate__c,YCoordinate__c from UIControls__r) from PageConfig__c where id=:PageConfigselect])
                {
                PageConfiglist.add(pagcon);
                mapstrpage.put(pagcon.id,pagcon);            
                }
            
        Uicontrollerslist = new list<UIControl__c>();
        Uicontrollerslist = mapstrpage.Get(PageConfigselect).UIControls__r;
        
         }

        }
    
        Public List<SelectOption> getPageConfig() { 
            
        return listpage;
        } 
        
        
        Public void getappsettings() {     
        PageConfiglist = new List<PageConfig__c>();               
        PageConfiglist = mapstrapps.Get(selectedappsettings).PageConfigs__r;

            listpage = new List<SelectOption>();

            listpage.add(new SelectOption('None','None'));              
            for(PageConfig__c pa: PageConfiglist){   

            listpage.add(new SelectOption(pa.id,pa.name));                              
            } 
        }
        
        Public void getuicontrollers() {

        Uicontrollerslist1 = new List<UIControl__c>();   

            for(UIControl__c uicon:[select id,name,Height__c,Width__c,XCoordinate__c,YCoordinate__c from UIControl__c where id=:selecteduicontrollers])
            {
            Uicontrollerslist1.add(uicon);           
            }           
        }
         
            
             
         
        Public PageReference Cancelit() {
        return null;
        }


        Public PageReference saveit() {
        
        return null;
        }




}