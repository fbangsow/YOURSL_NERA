public class UIcontrollercls {
	public Integer height {get; set;}
	public Integer width {get; set;}
	public Integer xCoordinate {get; set;}
	public Integer yCoordinate {get; set;}


	Public UIcontrollercls () {
		List <UIControl__c>   ui = [SELECT id, Name, Height__c, Width__c, XCoordinate__c, YCoordinate__c
		                            FROM UIControl__c
		                            LIMIT 50000];


		string str = JSON.serialize(ui);
		system.debug('.....line15......' + str);
	}
	UIcontrollercls  uiCla = new UIcontrollercls  ();
	string str1 = JSON.serialize(uiCla);

	UIcontrollercls  gCalendarDeserialized = (UIcontrollercls) JSON.deserialize(str1, UIcontrollercls .class);
}