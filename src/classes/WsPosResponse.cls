public virtual class WsPosResponse {

    public Boolean isSuccessfull {get;Set;}
    public String errorMessage {get;Set;}
    public String returnedValue {get;Set;}
    public HttpResponse originalMessage {Get;Set;}
    public Integer statusCode {Get;Set;}

    public WsPosResponse (Boolean isSuccessfull, String errorMessage, String returnedValue, HttpResponse orginalResponse) {
        this.isSuccessfull = isSuccessfull;
        this.errorMessage = errorMessage;
        this.returnedValue = returnedValue;
        this.originalMessage = orginalResponse;
    }

    public WsPosResponse (){
        
    }
}