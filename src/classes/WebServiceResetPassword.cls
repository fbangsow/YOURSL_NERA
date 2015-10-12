/*------------------------
@Project : NERA
@Company: MOLD TEK 
@Author: Phani Joshi
@Creation date: 20.04.2015  
@Ref: xxxxxxx
-------------------------*/
//TODO refactor
@RestResource(urlMapping='/ResetPassword/*')
global class WebServiceResetPassword{ 

    @HttpDelete
    global static string ForgotPassword(){

    String userName ;
    	  if(RestContext.request.params.get('UserName')!=null){
                userName =  RestContext.request.params.get('UserName');                
            }

    String responseString ;

    
    try{   	
       User usr = [select Id from User where username=:userName];
   		 System.resetPassword(usr.Id, true);
   		 responseString = 'Success : Successfully changed the password';
   	   }

   catch(Exception exceptionData){

   		responseString ='Error : Could not change the password' +exceptionData.getMessage()+ ', Please report issue to System Administrator';
   	   }
      
    return responseString;
 } 

   @HttpPost
   global static string ResetPassword(){

       String userName ;
       String password ;
    

       if(RestContext.request.params.get('UserName')!=null){
                userName =  RestContext.request.params.get('UserName');                
               
            }

            if(RestContext.request.params.get('NewPassword')!=null){
                password = RestContext.request.params.get('NewPassword');     
            }          
          

    String responseString ;

    
    try{    
        User usr = [select Id from User where username=:userName];
   			System.setPassword(usr.Id, password); 			
   			responseString = 'Success : Successfully changed the password';
       }
   catch(Exception exceptionData){

   	   responseString ='Error : Could not change the password' +exceptionData.getMessage()+ ', Please report issue to System Administrator';
  
   }
   
    return responseString;
  }

}