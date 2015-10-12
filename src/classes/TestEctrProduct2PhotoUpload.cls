/*
@Company            :Your SL
@Author             :Jyothi M
@Creation date      :12/06/2015
@Reference          :
*/
@IsTest
private class TestEctrProduct2PhotoUpload {

    //This method for covering the code inside if
    static testmethod void Product2PhotoUpload() {
        CleanupTestData.createNeraTriggerCustomSetting();
        product2 objproduct2 = new product2(Name = 'Danone water');
        insert objproduct2;
        Attachment attach = new Attachment(Name = 'icon_login.svg', ParentId = objproduct2.Id, Body = blob.valueOf('Test attachment body'));
        insert attach;

        objproduct2.Image__C = attach.Id;
        update objproduct2;

        PageReference p = Page.MobileDevices;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id', objproduct2.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct2);
        EctrProduct2PhotoUpload objEctrProduct2PhotoUpload = new EctrProduct2PhotoUpload(sc);
        objEctrProduct2PhotoUpload.uploadImage = attach.body;
        objEctrProduct2PhotoUpload.attachfilename = attach.Name;
        objEctrProduct2PhotoUpload.toggle();
        objEctrProduct2PhotoUpload.saveFile();
        system.assertEquals(attach.Id, objproduct2.Image__C);

    }
    //This method for covering catch
    static testmethod void Product2PhotoUploadCatch() {
        CleanupTestData.createNeraTriggerCustomSetting();
        product2 objproduct2 = new product2(Name = 'Danone water');
        insert objproduct2;
        Attachment attach = new Attachment(Name = 'icon_login.svg', ParentId = objproduct2.Id, Body = blob.valueOf('Test attachment body'));
        insert attach;

        //objproduct2.Image__C = attach.Id;
        update objproduct2;

        PageReference p = Page.MobileDevices;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id', objproduct2.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct2);
        EctrProduct2PhotoUpload objEctrProduct2PhotoUpload = new EctrProduct2PhotoUpload(sc);
        objEctrProduct2PhotoUpload.uploadImage = attach.body;
        objEctrProduct2PhotoUpload.saveFile();
        system.assertNotEquals(attach.Id, objproduct2.Image__C);
    }
}