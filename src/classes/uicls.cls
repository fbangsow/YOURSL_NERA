public with sharing class uicls {

public list <UIControl__c> lstu{get;set;}

public uicls()
{


lstu=[select id,name from UIControl__c];

}
}