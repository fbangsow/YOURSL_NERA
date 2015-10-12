/*
@Company:Your SL
@Author:veera
@Creation date:28/7/2015
Reference: Ticket no 
*/

@RestResource(urlMapping = '/PosProductGroupMember/*')


global class WsPosProductGroupMember implements WsPos
{
public static WsPosResponse  doReply(WsPosRequest request) {
        return new WsPosResponse ();
    }

    @HttpGet
  global static void wsGet() {
    WsPosRequest myRequest = new WsPosRequest(RestContext.request);
    List<PosProductGroupMember> listDataset = getPosProductGroupMember();
    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listDataset));
     RestContext.response.addHeader('size', String.valueOf(listDataset.Size()));
    RestContext.response.addHeader('Content-Type', 'application/json');
    }

  public static List<PosProductGroupMember> getPosProductGroupMember() {

  	List<PosProductGroupMember__c> PosProductGroupMemberList = [SELECT Id, Name, Product__c,ProductGroup__c FROM PosProductGroupMember__c];

  	List<PosProductGroupMember> wrapperGroupmember = new List<PosProductGroupMember>();

  	for(PosProductGroupMember__c member : PosProductGroupMemberList)
  	{

  		 PosProductGroupMember productGroup = new PosProductGroupMember(member);

        wrapperGroupmember.add(productGroup);
  	}

  return wrapperGroupmember;


  }

  public class PosProductGroupMember{

   public String name {get; set;}
   public String productId {get; set;}
   public String productGroupId {get; set;}

   public posProductGroupMember(PosProductGroupMember__c member)
   {
   	this.name = member.Name;
   	this.productId = member.Product__c;
   	this.productGroupid = member.ProductGroup__c;

   }

  }
}