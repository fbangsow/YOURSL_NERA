/*
@Company        :Your SL
@Author         :Jyothi M
@Creation date  :10/07/2015
@Reference      :
*/
@IsTest
public class TestPostDeployment {
    
    //we test here the post deployment
    static testMethod void deployment() {
    
        //TODO implement mock test
        TestDataUtility.createNeraTriggerCustomSetting();
        Test.startTest();
        PostDeployment testObj = new PostDeployment();
        Test.stopTest();

        
    }
}