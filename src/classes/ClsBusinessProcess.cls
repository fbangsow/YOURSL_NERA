/*
@Company        :Your SL
@Author         :Jyothi
@Creation date  :30/06/2015
@Reference      :
*/
public with sharing class ClsBusinessProcess {
	public ClsBusinessProcess() {

	}

	public static Map<String, Map<String, BusinessProcessParameter__c>> getBusinessParameters() {

		Map<String, Map<String, BusinessProcessParameter__c>> myBusinessProcesses = new Map<String, Map<String, BusinessProcessParameter__c>>();
		Map<Id, BusinessProcess__c> myBp = new Map<Id, BusinessProcess__c>([SELECT Id, Name FROM BusinessProcess__c limit 100]);
		Map<Id, BusinessProcessParameter__c> myBpp = new Map<Id, BusinessProcessParameter__c>([SELECT Id, Name, Values__c, BusinessprocessId__c
																						        FROM BusinessProcessParameter__c
																						        WHERE BusinessprocessId__c = : myBp.keySet()]);
		for (BusinessProcess__c bp : myBp.values()) {
			Map<String, BusinessProcessParameter__c> mapBpp = new Map<String, BusinessProcessParameter__c>();
			for (BusinessProcessParameter__c bpp : myBpp.values()) {
				if (bpp.BusinessprocessId__c == bp.Id) {
					mapBpp.put(bpp.Name , bpp);
					myBpp.remove(bpp.Id);
				}
			}
			if (!mapBpp.isEmpty()) {
				myBusinessProcesses.put(bp.Name, mapBpp);
			}
		}
		return myBusinessProcesses;
	}
}