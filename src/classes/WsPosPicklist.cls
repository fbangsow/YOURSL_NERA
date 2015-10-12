/*
@Company:Your SL
@Author:veera
@Creation date:
@Reference:
*/


@RestResource(urlMapping = '/PosPicklist/*')


global class WsPosPicklist implements WsPos {
	public static WsPosResponse doReply(WsPosRequest request) {
		return new WsPosResponse();
	}
	@HttpGet
	global static void wsGet() {

		WsPosRequest myRequest = new WsPosRequest(RestContext.request);
		//List<MainWrapper> listDataset = getProdcutAvailabiltyDevice();
		RestContext.response.responseBody = Blob.valueOf(JSON.serialize(getProdcutAvailabiltyDevice()));
		RestContext.response.addHeader('Content-Type', 'application/json');
	}
	public static MainWrapper getProdcutAvailabiltyDevice() {
		MainWrapper main = new MainWrapper();
		main.productAvailable = productGet();
		main.DeviceType = DeviceGet();


		return main;

	}

	public static List < productAvailability > productGet() {
		List < productAvailability > productAvailabilitywraper = new List < productAvailability > ();
		List < ConsumerProductStockStatus__c > lstConsumerProductStockStatus = [SELECT Id, Name, Potential__c FROM ConsumerProductStockStatus__c];
		for (ConsumerProductStockStatus__c lstproducts : lstConsumerProductStockStatus) {

			productAvailability obj = new productAvailability();
			obj.name = lstproducts.Name;
			obj.productavilabityId = lstproducts.Id;
			obj.potential = lstproducts.Potential__c;
			productAvailabilitywraper.add(obj);
		}
		return productAvailabilitywraper;
	}

	public static List < Device > DeviceGet() {
		List < Device > devicewrapper = new List < Device > ();
		List < POIDevice__c > lstPoiDevice = [SELECT Id, Name, POIDeviceType__r.Name FROM POIDevice__c];
		system.debug('...............Poidevices......' + lstPoiDevice);
		for (POIDevice__c lstdev : lstPoiDevice) {


			Device objdev = new Device();
			objdev.name = lstdev.Name;
			objdev.deviceId = lstdev.Id;
			objdev.devicetypeid = lstdev.POIDeviceType__r.Name;
			devicewrapper.add(objdev);

		}
		return devicewrapper;



	}

	public class MainWrapper {
		public List < productAvailability > productAvailable {
			get;
			set;
		}
		public List < Device > deviceType{
			get;
			set;
		}
	}

	public class productAvailability{
		public String name;
		public Id productavilabityId;
		public Boolean potential;
	}
	public class Device{
		public String name;
		public Id deviceId;
		public String devicetypeid;
	}
}