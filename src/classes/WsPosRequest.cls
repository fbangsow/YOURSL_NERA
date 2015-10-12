public without sharing class WsPosRequest {

    public User resquestedByUser {get; set;}
    public Integer statusCode {get; set;}
    public String errorMessage {get; set;}

    public Set<String> myIds {get; set;}
    public WsPosRequest(RestRequest request) {

        errorMessage = '';
        if (request.params.get('userId') != null) {
            Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, Name,ProfileId
                    FROM User
                    WHERE Id = : request.params.get('userId')]);
            if (!mapUsers.isEmpty()) {
                this.resquestedByUSer = mapUsers.values()[0];
                statusCode = 200;
            } else {
                statusCode = 400;
                errorMessage = 'requested user could not be found';
            }
        } else {
            statusCode = 400;
            errorMessage = 'no requested userId';
        }
    }

    public WsPosRequest (RestRequest request, String accountPayload) {

        errorMessage = '';
        if (request.params.get('userId') != null) {
            Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id
                    FROM User
                    WHERE Id = : request.params.get('userId')]);
            if (!mapUsers.isEmpty()) {
                this.resquestedByUSer = mapUsers.values()[0];
                statusCode = 200;
            } else {
                statusCode = 400;
                errorMessage = 'requested user could not be found';
            }
        } else {
            statusCode = 400;
            errorMessage = 'no requested userId';
        }

        //TODO cast from payload string into set of Id
        if(String.isNotBlank(request.params.get('accountIds'))){
            String accountIds = request.params.get('accountIds');
            List<String> accIds =accountIds.split(',');
            
            this.myIds = new Set<String>(accIds);
        }
    }

    public WsPosRequest (RestRequest request, Sobject myObject) {

    }


}