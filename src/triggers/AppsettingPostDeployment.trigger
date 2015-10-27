trigger AppsettingPostDeployment on Attachment (After insert) {
    String AttachmentId;
    SObjectType objectName;
    String objId;
    for (Attachment att : trigger.New) {
        AttachmentId = att.ID;
        objectName = att.ParentId.getSobjectType();
        objId = att.ParentId;
    }
    SObjectType fieldType = Schema.getGlobalDescribe().get(String.valueOf(objectName));
    Map<String,Schema.SObjectField> objFields = fieldType.getDescribe().fields.getMap();
    if(objFields.containsKey('AttachmentId__c')){
        String q = 'SELECT Id,AttachmentId__c FROM ' + objectName + ' where id=\'' + objId + '\'';
        Sobject results = Database.query(q);
        SObject onjectName = objectName.newSObject();
        onjectName.put('Id', results.Id);
        onjectName.put('AttachmentId__c', AttachmentId);
        update onjectName;
    }  
}
