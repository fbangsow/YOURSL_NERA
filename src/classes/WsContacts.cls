/*
@Company:Your SL
@Author:unkown
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/Contacts/*')
global class WsContacts implements UcbWs {

	public static string debugVar {get; set;}

	public static UcbWsResponse doReply(UcbWsRequest request) {
		return new UcbWsResponse();
	}

	/**
	 * Service method to retrieve Contact details from SF Contact standard object
	 * @return
	 */
	//@HttpGet
	global static void wsGet() {
		//create Request
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		// do businesslogic
		if(myRequest.resquestedByUser != null) {
			Map<Id, Contact> mapContacts = WsContacts.getContacts(myRequest.resquestedByUser.Id);
			if(!mapContacts.isEmpty()) {
				List<Contact> contacts = mapContacts.values();
				List<myContact> myContacts = new List<myContact>();
				for (Contact c : Contacts) {
					myContact m = new myContact(c);
					myContacts.add(m);
				}
				RestContext.response.responseBody = Blob.valueOf(JSON.serialize(mapContacts));
			} else {
				RestContext.response.addHeader('size', '0');
			}
		}
		//return response
		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
		RestContext.response.statusCode = myRequest.statusCode;
	}


	/// <summary>
	/// Service Method to Insert Events
	/// </summary>
	@HttpPost
	global static void wsPost() {

		//System.debug('@@@Contacts Json is' + RestContext.request.requestBody.toString());
		String createContactsJsonRequest = RestContext.request.requestBody.toString();
		List<Contact> listInsertedContacts = WsContacts.insertContacts(createContactsJsonRequest);

		//UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		//if (myRequest.resquestedByUser != null) {
		//}
	}


	@HttpPatch
	global static void wsPatch() {
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
		if(myRequest.resquestedByUser != null) {
			List<Contact> listUpdatedContacts = WsContacts.updateContacts(RestContext.request.params.get('contacts'));
		}
	}

	/// <summary>
	/// Service Method to delete User Events
	/// </summary>
	@HttpDelete
	global static void wsDelete() {
		
		UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);

		List<Event> deletedEvents = new List<Event>();

		if(myRequest.resquestedByUser != null) {
			deletedEvents =	WsEvents.deleteEvents(RestContext.request.params.get('eventIds'));
		}

		if(deletedEvents.size()>0){
			RestContext.response.statusCode = 200;
			RestContext.response.responseBody = Blob.valueOf('Success');
		}else {
			RestContext.response.statusCode = 400;
			RestContext.response.responseBody = Blob.valueOf('Error');
		}

	}

	public static Map<Id, Contact> getContacts(Id owner) {
		return new Map<Id, Contact>([SELECT Id, AccountId, Name, LastName, OwnerId FROM Contact where OwnerId = :owner]);
	}

	/**
	    * METHOD JUST CREATED FOR TESTING. TO BE DELETED
	    * @return
	    */
	@HttpGet
	global static string dummyDelete() {

		/*List<myContact> lstcnts = new List<myContact>();

		for (Integer i = 0; i < 2; i++) {
		    myContact obj = new myContact(null);
		    obj.AccountId = '23234324';
		    obj.OwnerId = '00524000000gYFRAA2';
		    obj.Id = '00U24000001lpPzEAI';
		    obj.Name = 'TestName123';
		    obj.LastName = 'Lastname1234';

		    lstcnts.add(obj);

		}

		return JSON.serialize(lstcnts);*/

		/*List<ID> abd = new List<ID>();

		abd.add('00324000005lmpaAAA');
		abd.add('00324000005lmpbAAA');

		return  JSON.serialize(abd);
*/

		//String jsonstr = '[{"OwnerId":"00524000000gYFRAA2","Name":"TestName123 updated","LastName":"Lastname1234 updated","Id":"00324000005lmpaAAA","AccountId":"00124000006hAdDAAU"},{"OwnerId":"00524000000gYFRAA2","Name":"TestName123 updated","LastName":"Lastname1234 updated","Id":"00324000005lmpbAAA","AccountId":"00124000006hAdDAAU"}]';
		String jsonstr = '["00324000005lmpaAAA","00324000005lmpbAAA"]';

		List<Contact> objitems = deleteContacts(jsonstr);

		for(Contact i : objitems) {
			debugVar = debugVar + '     ' + i.Id;
		}



		return debugVar;

	}


	public static List<Contact> updateContacts(String Contacts) {

		List<Contact> listUpdateContacts = new List<Contact>();

		if(!String.isEmpty(Contacts)) {

			List<myContact> lLstObjMyContacts = deserializeMyContactRequest(Contacts);

			if(lLstObjMyContacts != null) {
				for(myContact item : lLstObjMyContacts) {

					//debugVar = debugVar + '   ' + item.OwnerId;

					Contact itrContact = new Contact(
					    LastName = item.LastName,
					    AccountId = item.AccountId,
					    //Name=item.Name,
					    OwnerId = item.OwnerId,
					    Id = item.Id
					);
					listUpdateContacts.add(itrContact);
				}
			}
			update listUpdateContacts;
		}

		return listUpdateContacts;
	}



	/**
	 * Wrapper Method for inserting new contacts
	 * @param contacts
	 * @return
	 */
	public static List<Contact> insertContacts(String contacts) {
		System.debug('@@In Insert Contacts - Contacts to be inserted is' + Contacts);
		List<Contact> listInsertContacts = new List<Contact>();

		if(!String.isEmpty(Contacts)) {

			List<myContact> lLstObjMyContacts = deserializeMyContactRequest(Contacts);
			System.debug('@@@List Size of Contacts to be inserted is' + lLstObjMyContacts.size());
			for(myContact item : lLstObjMyContacts) {

				//debugVar = debugVar + '   ' + item.OwnerId;
				//System.debug('@@@WhoId is' + item.WhoId);

				Contact itrContact = new Contact(
				    LastName = item.LastName,
				    AccountId = item.AccountId,
				    //Name=item.Name,
				    OwnerId = item.OwnerId
				);

				listInsertContacts.add(itrContact);
			}

			insert listInsertContacts;
		}

		return listInsertContacts;

	}

/**
 * [deleteContacts description]
 * @param
 * @return
 */
	public static List<Contact> deleteContacts(String contactIds) {

		List<Contact> listDeletedContact = null;

		if(!String.isEmpty(contactIds)) {

			//st<myContact> LstContactIDs = deserializeMyContactRequest(contactIds);
			List<Id> lLstContactIDs = (List<Id>) JSON.deserialize(contactIds, List<Id>.class);

			listDeletedContact = [SELECT Id 
								  FROM Contact 
								  WHERE Id in :lLstContactIDs];
			//debugVar=debugVar +	'	' + listDeletedEvents.size();
			//System.debug('@@@List Size of Events to be Deleted is' + listDeletedContact.size());

			delete listDeletedContact;
		
		}

		return listDeletedContact;
	}

	/**[deserializeMyContactRequest description]
	 *
	 * @param
	 * @return
	 */
	public static List<myContact> deserializeMyContactRequest(String request) {
		List<mycontact> lObjmyContact = null;
		if(!String.isEmpty(request)) {
			lObjmyContact = (List<mycontact>) JSON.deserialize(request, List<myContact>.class);
		}
		return lObjmyContact;
	}

	
	/**
	 *
	 * This is class for maintaining Contact Salesforce Standard object
	 *
	 */
	public class myContact {

		public String accountId {get; set;}
		public String lastName {get; set;}
		public String name {get; set;}
		public Id id  {get; set;}
		public Id ownerId  {get; set;}

		// costructor to adapt contact to mycontact
		public myContact(Contact c) {
			if (c != null) {
				AccountId = c.AccountId;
				LastName = c.Name;
				Name = c.Name;
				Id = c.Id;
				OwnerId = c.OwnerId;
			}
		}
	}
}