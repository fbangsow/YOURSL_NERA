/*
@Company:Your SL
@Author:unkown
@Creation date:
@Reference: 
*/
@RestResource(urlMapping = '/Events/*')
global class WsEvents implements UcbWs {

    public static String debugVar {get; set;}
    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }
    @HttpGet
    global static void wsGet() {
        //create Request
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        // do businesslogic
        if (myRequest.resquestedByUser != null) {
            Map<Id, Event> mapEvents = WsEvents.getEvents(myRequest.resquestedByUser.Id);
            if (!mapEvents.isEmpty()) {
                List<Event> events = mapEvents.values();
                List<myEvent> myEvents = new List<myEvent>();
                for (Event e : events) {
                    System.Debug('--------------------------------------'+e ); 
                    myEvent m = new myEvent(e);
                      m.Id=e.Id;
                System.Debug('--------------------------------------'+m );
                    myEvents.add(m);
                }
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(myEvents));
                System.Debug('--------------------------------------'+RestContext.response.responseBody );
            } else {
                RestContext.response.addHeader('size', '0');
            }
        } else {
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;


        }
        //return repsonse
    }
    /// <summary>
    /// Service Method to Insert Events
    /// </summary>
    @HttpPost
    global static void wsPost() {
        System.debug('@@@In Post Events Json From Request Param is' + RestContext.request.params.get('events'));
        string createEventsJsonRequest = RestContext.request.params.get('events');
        List<Event> listInsertedEvents = WsEvents.insertEvents(createEventsJsonRequest);
        System.debug ('------------------------'+listInsertedEvents);
        if (listInsertedEvents.size() > 0) {
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listInsertedEvents));
        } else {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Error');
        }
    }
    @HttpDelete
    global static void wsDelete() {
        System.debug('@@@In Delete : Events Json From Request Param is' + RestContext.request.params.get('eventIds'));
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        List<Event> deletedEvents = new List<Event>();
        if (myRequest.resquestedByUser != null) {
            deletedEvents = WsEvents.deleteEvents(RestContext.request.params.get('eventIds'));
        }
        if (deletedEvents.size() > 0) {
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf('Success');
        } else {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Error');
        }
    }
    @HttpPut
    global static void wsPut() {
        UcbWsRequest myRequest = new UcbWsRequest(RestContext.request);
        if (myRequest.resquestedByUser != null) {
            System.debug('@@@In Put : Events Json From Request Param is' + RestContext.request.params.get('events'));
            List<Event> listUpdatedEvents = WsEvents.updateEvents(RestContext.request.params.get('events'));
            if (listUpdatedEvents.size() > 0) {
                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf('Success');
               // RestContext.response.responseBody = Id.valueOf('Id');


            } else {
                RestContext.response.statusCode = 400;
                RestContext.response.responseBody = Blob.valueOf('Error');
            }
        } else {
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('errorMessage', myRequest.errorMessage);
            RestContext.response.statusCode = myRequest.statusCode;
        }
    }
    
    public static Map<id, Event> getEvents(Id owner) {

        string queryString = 'SELECT AccountId, ActivityDate, ActivityDateTime,Status__c, isTimeNeeded__c, CreatedById, CreatedDate, Description, EndDateTime, GroupEventType, Id, IsAllDayEvent, IsDeleted, LastModifiedById,LastModifiedDate, Location, OwnerId, StartDateTime, Subject, WhatId, WhoId FROM Event WHERE OwnerId = :owner';
        
        if (RestContext.request.params.get('eventDate') != null) {
            queryString = queryString + 'and ActivityDate = :forDate';
        }

        return new Map<Id, Event>((List<Event>)Database.query(queryString));
    }

    public static List<Event> updateEvents(String events) {
        List<Event> listUpdateEvents = new List<Event>();
        if (!String.isEmpty(events)) {
            List<myEvent> lLstObjMyEvents = deserializeMyEventRequest(events);
            for (myEvent item : lLstObjMyEvents) {
                //debugVar = debugVar + '   ' + item.OwnerId;
                Event itrEvent = new Event(
                    OwnerId = item.OwnerId,
                    WhatId = item.WhatId,
                    ActivityDate = date.valueOf(item.ActivityDate),
                    ActivityDateTime = Datetime.valueOf(item.ActivityDateTime),
                    Description = item.Description,
                    StartDateTime = Datetime.valueOf(item.StartDateTime),
                    EndDateTime = Datetime.valueOf(item.EndDateTime),
                    Id = item.Id,
                    WhoId = item.WhoId,
                    Subject = item.Subject,
                    Status__c= item.status,
                    isTimeNeeded__c = item.isTimeNeeded
                );
                listUpdateEvents.add(itrEvent);
            }
            update listUpdateEvents;
        }
        return listUpdateEvents;
    }
    public static List<Event> insertEvents(String events) {
        System.debug('@@In Insert Events - Events to be inserted is' + events);
        List<Event> listInsertEvents = new List<Event>();
        if (!String.isEmpty(events)) {
            List<myEvent> lLstObjMyEvents = deserializeMyEventRequest(events);
            System.debug('@@@List Size of Events to be inserted is' + lLstObjMyEvents.size());
            for (myEvent item : lLstObjMyEvents) {
                System.debug('@@@WhoId is' + item.WhoId);
                Event itrEvent = new Event(
                    OwnerId = item.OwnerId,
                    WhatId = item.WhatId,
                    ActivityDate = date.valueOf(item.ActivityDate),
                    ActivityDateTime = Datetime.valueOf(item.ActivityDateTime),
                    Description = item.Description,
                    StartDateTime = Datetime.valueOf(item.StartDateTime),
                    EndDateTime = Datetime.valueOf(item.EndDateTime),
                    Id = item.Id,
                    Subject = item.Subject,
                    Status__c = item.status,
                    isTimeNeeded__c = item.isTimeNeeded

                );
                listInsertEvents.add(itrEvent);
            }
            insert listInsertEvents;
            System.debug('----------------------'+listInsertEvents);
        }
        return listInsertEvents;
    }
    public static List<Event> deleteEvents(String eventIds) {
        List<Event> listDeletedEvents = null;
        if (!String.isEmpty(eventIds)) {
            List<ID> lLstEventIDs = (List<ID>) JSON.deserialize(eventIds, List<ID>.class);
            listDeletedEvents = [SELECT Id FROM Event WHERE Id in :lLstEventIDs];
            System.debug('@@@List Size of Events to be Deleted is' + listDeletedEvents.size());
            delete listDeletedEvents;
        }
        return listDeletedEvents;
    }

    public static List<myEvent> deserializeMyEventRequest(String request) {
        List<myEvent> lObjmyEvent = null;
        if (!String.isEmpty(request)) {
            lObjmyEvent = (List<myEvent>) JSON.deserialize(request, List<myEvent>.class);
        }
        return lObjmyEvent;
    }

    public class myEvents {
        public List<Event> listEvents {get; set;}
        public myEvents(String eventsJson) {
        }
    }
    public class myEvent {
        public String AccountId {get; set;}
        public String ActivityDate {get; set;}
        public String ActivityDateTime {get; set;}
        public String Description {get; set;}
        public String StartDateTime  {get; set;}
        public String EndDateTime {get; set;}
        public Id OwnerId {get; set;}
        public Id WhoId  {get; set;}
        public Id WhatId  {get; set;}
        public Id Id  {get; set;}
        public String Subject {get; set;}
        public String status {get; set;}
        public Boolean isTimeNeeded {get; set;}

        public myEvent (Event e) {
            AccountId = e.WhatId;
            WhatId = e.WhatId;
            WhoId = e.WhoId;
            Id = e.Id;
            OwnerId = e.OwnerId;
            ActivityDate = String.valueOf(e.ActivityDate);
            ActivityDateTime = String.valueOf(e.ActivityDateTime);
            EndDateTime = String.valueOf(e.EndDateTime);
            StartDateTime = String.valueOf( e.StartDateTime);
            Description = e.Description;
            Subject = e.Subject;
            status = e.Status__c;
            isTimeNeeded = e.isTimeNeeded__c;
        }
    }
}