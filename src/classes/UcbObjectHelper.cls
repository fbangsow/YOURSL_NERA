public with sharing class UcbObjectHelper {
    //public UcbObjectHelper() {
        
    //}

    public static String getObjectType(List<Sobject> myObject){

        return String.valueOf(myObject.getSobjectType());
    }
}