/*
@Company:Your SL
@Author:Pavan
@Creation date:28/7/2015
Reference:
*/
@RestResource(urlMapping = '/Orders/*')

global class WsOrders implements UcbWs {
    
    public static List<Contact> emailAndfax;
    public static UcbWsResponse doReply(UcbWsRequest request) {
        return new UcbWsResponse();
    }

    @HttpPost
    global static void wsPost() {

        RestRequest req = RestContext.request;
        String createEventsJsonRequest = EncodingUtil.urlDecode(RestContext.request.params.get('Order'), 'UTF-8');
        System.debug('test params.........' + RestContext.request.params);
        //Deserailze data
        OrderInformation orderInfo = (OrderInformation)JSON.deserialize(createEventsJsonRequest, OrderInformation.class);
        system.debug('orderInfo.......' + orderInfo);
        emailAndfax = new List<Contact>();
        system.debug('emailAndfax.......'+emailAndfax);
        for(Contact myContact : [SELECT Id,Name,Email,Fax
                                 FROM Contact
                                 WHERE AccountId = :orderInfo.AccountId]) {
            system.debug('myContact...'+myContact);
            if (myContact.Email != null || myContact.Fax != null) {
                emailAndfax.add(myContact);
            }
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        insertOrder( orderInfo);
    }

    public static void insertOrder(OrderInformation orderData) {

        Order order = new Order();
        order.AccountId = Id.valueOf(orderData.accountId);
        order.Status = String.valueof(orderData.status);

        List<String> dateVal = orderData.orderStartDate.split('T');
        List<String> dd = dateVal[0].split('-');
        String finaldate = dd[0] + '-' + dd[1] + '-' + dd[2];

        order.EffectiveDate = Date.valueof(finaldate);
        insert order;

        Attachment attach = new Attachment();
        attach.Body = orderData.signatureContent;
        attach.Name = orderData.signatureName;
        attach.ParentId = order.Id;
        insert attach;

        order.AttachmentId__c = attach.Id;
        update order;

        List<SelectedProduct__c> listSelectorder = new List<SelectedProduct__c>();
        List<DiscardedProduct__c> listDiscardOrder = new List<DiscardedProduct__c>();

        for(OrderedItems myOrder : orderData.orderedItems) {

            if(myOrder.IsOrdered == true) {
                SelectedProduct__c product = new SelectedProduct__c();
                product.Name = myOrder.name;
                product.Order__c = order.Id;
                product.ProductCode__c = myOrder.productCode;
                product.Price__c = Decimal.valueOf(myOrder.unitPrice);
                product.UseStandardPrice__c = Boolean.valueOf(myOrder.useStandardPrice);
                product.UnitPrice__c = Decimal.valueOf(myOrder.unitPrice);
                product.OrderType__c = myOrder.orderType;
                product.ThirdPartyOrderStatus__c = myOrder.thirdPartyOrderStatus;
                product.ThirdPartyOrderComment__c = myOrder.thirdPartyOrderComment;
                product.ProductId__c = myOrder.product2Id;
                product.PriceBookEntryId__c = myOrder.priceBookEntryId;
                product.Quantity__c = Integer.valueof(myOrder.quantity);
                listSelectorder.add(product);
            } else If(myOrder.IsOrdered == false) {
                DiscardedProduct__c product = new DiscardedProduct__c();
                product.Name = myOrder.name;
                product.Order__c = order.Id;
                product.ProductCode__c = myOrder.productCode;
                product.UseStandardPrice__c = Boolean.valueOf(myOrder.useStandardPrice);
                product.UnitPrice__c = Decimal.valueOf(myOrder.unitPrice);
                product.OrderType__c = myOrder.orderType;
                product.ProductId__c = myOrder.product2Id;
                product.Intension__c = myOrder.purchaseIntension;
                product.PriceBookEntryId__c = myOrder.priceBookEntryId;
                product.Quantity__c = Integer.valueof(myOrder.quantity);
                listDiscardOrder.add(product);
            }
        }
        if(!listSelectorder.isEmpty())
            insert listSelectorder;

        if(!listDiscardOrder.isEmpty())
            insert listDiscardOrder;
        savePdf(order.Id);

    }
    public static PageReference  savePdf(String orderId) {

        Order order = [SELECT Id, Name, Account.Owner.Email, OrderNumber, EffectiveDate,
                              AccountId, Account.BillingStreet,Account.Name,
                              Account.BillingCity, Account.BillingCountry
                       FROM Order
                       WHERE Id = :orderId];

        String accountOwnerEmail = order.Account.Owner.Email;
        List<String> email = new List<String>();
        email.add(accountOwnerEmail);

        for(Contact con : [SELECT Name, Email, Fax
                           FROM Contact
                           WHERE AccountId = :order.AccountId AND IsSelected__c = true]) {
            email.add(con.Email);
        }
        Blob body;
        List<SelectedProduct__c> listSelectproduct = new List<SelectedProduct__c>();
        for(SelectedProduct__c myproduct : [SELECT Name, Quantity__c, Price__c 
                                            FROM SelectedProduct__c]) {
            listSelectproduct.add(myproduct);
        }
        string data;
        data='<table style="margin-top:20px" border="1"><thead><tr><td>Name</td><td>Quantity</td><td>Price</td></tr></thead><tbody>';
        Decimal countofprice=0;
        Decimal price=0;
        for(SelectedProduct__c myproduct: [SELECT Name,Quantity__c,Price__c,ProductId__c 
                                           FROM SelectedProduct__c 
                                           WHERE Order__c=:orderId]){            
           price=myproduct.Price__c*myproduct.Quantity__c;
           data=data+'<tr><td>'+myproduct.Name+'</td><td>'+myproduct.Quantity__c+'</td><td>'+price+'</td></tr>';
           countofprice=countofprice+price;
        }
        data=data+'</tbody><tr><td ></td><td>Total</td><td>'+countofprice+'</td></tr></table>';
        String htmldata = '<apex:page >';
        htmldata += '<apex:form >';
        htmldata += '<html>';
        htmldata += '<head>';
        htmldata += '<body>';
        //htmldata += '<div align="center"><apex:image id="theImage" value="https://c.eu5.content.force.com/servlet/servlet.ImageServer?id=015240000004PrQ&oid=00D24000000cr82 width="200" height="200"/></div>';
       // htmldata +='<img src="{!$Resource.Cococola}" alt="Cococola" />';
        //htmldata += '<img src="https://c.eu5.content.force.com/servlet/servlet.ImageServer?id=015240000004PrQ&oid=00D24000000cr82&lastMod=1440756802000 alt="Cococola" height="64" width="64"/>';
        htmldata += '<br><br><div style="width:980px;margin:0px auto;float:left;"><p style="text-align: center;">Order Invoice<p><br><br><table><tr><td>Address:</td><td>' + order.Account.BillingStreet + '</td><td>Name</td><td> '+order.Account.Name+'</td></tr><tr><td></td><td>'+order.Account.BillingCity+'</td><td>OrderDate:</td><td> '+order.EffectiveDate+'</td></tr><tr><td></td><td>'+order.Account.BillingCountry+'</td><td>OrderNumber:</td><td>'+order.OrderNumber+'</td></tr></table><div><br><br>'+data;
        htmldata += '</body>';
        htmldata += '</head>';
        htmldata += '</html>';
        htmldata += '</apex:form>';
        htmldata += '</apex:page>';
        try {
            body = Blob.toPDF(htmldata);
        } catch (Exception e) {
            body = Blob.valueOf('Some Text');
        }

        Attachment attach = new Attachment();
        attach.Body = body;
        attach.Name = order.Account.Name;
        attach.IsPrivate = false;
        attach.ParentId = order.Id;
        insert attach;

        String message;

        try {
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            system.debug('attachment...........' + attachment);
            attachment.setContentType('application/pdf');
            attachment.setFileName('attachment.pdf');
            attachment.setInline(false);
            attachment.Body = attach.Body;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(email);
            mail.setSubject('Order Confirmation');
            mail.setHtmlBody('Here is the email you requested! Check the attachment!');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            //message = 'Mail Sent Success';
            OrderMessage orderMessage = new OrderMessage();
            orderMessage.orderId = order.Id;
            orderMessage.message = (emailAndfax.size()>0)?'send email successfully':'no email or fax not found in contact And email sent successfully';
            orderMessage.statuscode = 200;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(orderMessage));
        } catch (Exception e) {
            OrderMessage orderMessage = new OrderMessage();
            orderMessage.orderId = order.Id;
            orderMessage.message = e.getMessage();
            orderMessage.statuscode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(orderMessage));
            //message = e.getMessage();
        }

        return null;
    }
    public class OrderWrapper {
        public String id {get; set;}
    }

    public class OrderInformation {
        public String accountId;
        public Boolean isSync;
        public String signatureName;
        public String lastSyncedDateTime;
        public String status;
        public Blob signatureContent;
        public String orderStartDate;
        public List<OrderedItems> orderedItems;
        public String orderedItemsBlob;
        public Id id;
        public Integer crmType;
        public String lastModifiedDateTime;
        public String createdDateTime;
        public Boolean isDeleted;
        public Blob profilePicFile;
        public String attachfilename;
    }

    public class OrderedItems {
        public String name;
        public String productCode;
        public Double price;
        public String purchaseIntension;
        public String orderType;
        public String useStandardPrice;
        public String unitPrice;
        public String product2Id;
        public String priceBookEntryId;
        public Boolean isOrdered;
        public Boolean thirdPartyOrderStatus;
        public String thirdPartyOrderComment;
        public List<PotentialTypes> potentialTypes;
        public String potentialTypesBlob;
        public String quantity;
    }

    public class PotentialTypes {
        public String typeName;
        public Integer typeQuantity;
    }
    public class OrderMessage{
        public String orderId;
        public String message;
        public Integer statuscode;

    }

}