/**
 * Created by jesus.cantero on 13/05/2021.
 */

public class MissingWebUserListCtrl {
    @AuraEnabled
    public static List<WebUserWrapperAuraEnabled> getUsers()//method for the lightning component
    {
        
        List<WebUserWrapper> listWebUsers = getUsersAPICallOut();
        if(listWebUsers != null)
        {
            return populateAuraEnabledUserInstance(listWebUsers);
        }
            
        //return null value if no users exist
        return null;
    }
    @AuraEnabled
    public static List<WebUserWrapperAuraEnabled> saveUsers()// method for the Lightning component
    {
        List<WebUserWrapper> listOfUsers = getUsersAPICallOut();
        if(listOfUsers != null) 
        {
            List<WebUserWrapperAuraEnabled> listWebUsersAuraEnabled = populateAuraEnabledUserInstance(listOfUsers);
            List<Web_User__c> listWebUser = new List<Web_User__c>();
            // Iterate through each returned listofUsers
            for(WebUserWrapper user  : listOfUsers)
            {
                Web_User__c webUser = new Web_User__c();
                webUser.Email__c = user.email;
                webUser.Username__c = user.userName;
                webUser.Web_Site_Id__c = user.Id;
                webUser.name = user.name;
                if(user.company != null)
                {
                    webUser.Company__c = user.company.name;   
                }
                //adding each user to the list
                listWebUser.add(webUser);
            }
            //SaveResult object is generated when a new or existing Salesforce record is saved
            Database.SaveResult[] saveResultList = Database.insert(listWebUser, false);
            integer i = 0;
            // Iterate through each returned result
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
                    // on record creation, createstatus field is updated
                    listWebUsersAuraEnabled[i].createstatus = 'User created successfully';
                }
                else {
                    listWebUsersAuraEnabled[i].createstatus = 'Failed: ';  
                    for(Database.Error err : sr.getErrors()) {    
                    	listWebUsersAuraEnabled[i].createstatus += err.getMessage();
                    }
                    
                }
                i = i + 1;
            }       
            return listWebUsersAuraEnabled;
        }
		return null;        
    }
   
    //APICallout to get the users from the endpoint 
    private static List<WebUserWrapper> getUsersAPICallOut()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/users');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            //Deserializes the specified JSON string into an Apex object of the specified type.
            List<WebUserWrapper> listWebUsers = (List<WebUserWrapper>) JSON.deserialize(response.getBody(),List<WebUserWrapper>.class);
            return listWebUsers;
        }
        return null;
    }
    
    private static List<WebUserWrapperAuraEnabled> populateAuraEnabledUserInstance(List<WebUserWrapper> listWebUsers)
    {
        
        List<WebUserWrapperAuraEnabled> listWebUsersAuraEnabled = new List<WebUserWrapperAuraEnabled>();
        for(WebUserWrapper webUser : listWebUsers)
        {
            // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
            WebUserWrapperAuraEnabled webUserAuraEnabled = new WebUserWrapperAuraEnabled();
            webUserAuraEnabled.id = webUser.Id;
            webUserAuraEnabled.name = webUser.name;
            webUserAuraEnabled.userName = webUser.userName;
            webUserAuraEnabled.email = webUser.email;
            if (webUser.company != null)
            {
                webUserAuraEnabled.company = webUser.company.name;        
            }
            //adding each wrapper class objects to the list
            listWebUsersAuraEnabled.add(webUserAuraEnabled);
        } 
        return listWebUsersAuraEnabled;
    }
    
    
    // wrapper or Inner class with @AuraEnabled properties
    public class WebUserWrapperAuraEnabled
    {
        @AuraEnabled
        public string id;	//1
        @AuraEnabled
        public String name;	//Leanne Graham
        @AuraEnabled
		public String userName;	//Bret
        @AuraEnabled
        public String email;	//Bret
        @AuraEnabled
        public String company;	//Bret
        @AuraEnabled
        public String createstatus = 'Pending';	//Bret
    }

}