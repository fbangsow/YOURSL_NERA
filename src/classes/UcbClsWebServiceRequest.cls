public with sharing class UcbClsWebServiceRequest {
	
	public String webserviceCommand {Get;Set;}
	public String username {Get;Set;}
	public String password {Get;Set;}
	public String method {Get;Set;}
	public String body {Get;Set;}
	public String endpoint {Get;Set;}
	public String signature {Get;Set;}

	public UcbClsWebServiceRequest(String webserviceCommand, String username, String password, String method, String body, String endpoint) {
		this.webserviceCommand = webserviceCommand;
		this.username = username;
		this.password = password;
		this.method = method;
		this.body = body;
		this.endpoint = endpoint;
	}
	public UcbClsWebServiceRequest(){

	}

	public UcbClsWebServiceRequest(String webserviceCommand, String method, String endpoint, String signature){
		this.webserviceCommand = webserviceCommand;
		this.endpoint = endpoint;
		this.method = method;
		this.signature = signature;
	}
}