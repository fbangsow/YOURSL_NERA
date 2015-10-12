@RestResource(urlMapping='/ScreenPermissions/*') 
 global with sharing class WebServiceScreenPermissions{

    @HttpGet
    global static String getScreenPermissions(){

	    String jsonResponse;
        try
        {
            String userId;
            
            if(RestContext.request.params.get('userId')!=null){
                userId =  RestContext.request.params.get('userId');
                System.debug('@@@ User Id=='+ RestContext.request.params.get('userId'));
            }

            //TODO: retrieve permissions for this user/role
            jsonResponse = '{\"LoginScreen\":\"Write\",	\"SplashScreen\":\"Write\",	\"VisitPlanningScreen\":\"Read\"}';

    	}catch(Exception ex){
            System.debug('Exception-->'+ex);
        }
        
        System.debug('final jsonResponse-->'+jsonResponse);
        // send final response
        return jsonResponse;            
    }

}