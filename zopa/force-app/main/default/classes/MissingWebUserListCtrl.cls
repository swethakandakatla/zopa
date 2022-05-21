/**
 * Created by jesus.cantero on 13/05/2021.
 */

public class MissingWebUserListCtrl {
    @AuraEnabled
    public static List<WebUserWrapperAuraEnabled> getUsers()
    {
        List<WebUserWrapper> listWebUsers = getUsersAPICallOut();
        if(listWebUsers != null)
        {
            
            return populateAuraEnabledUserInstance(listWebUsers);
        }
            
        
        return null;
    }
    @AuraEnabled
    public static List<WebUserWrapperAuraEnabled> saveUsers()
    {
        List<WebUserWrapper> listOfUsers = getUsersAPICallOut();
        if(listOfUsers != null)
        {
            List<WebUserWrapperAuraEnabled> listWebUsersAuraEnabled = populateAuraEnabledUserInstance(listOfUsers);
            List<Web_User__c> listWebUser = new List<Web_User__c>();
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
                listWebUser.add(webUser);
            }
            Database.SaveResult[] saveResultList = Database.insert(listWebUser, false);
            integer i = 0;
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
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
   
    
    private static List<WebUserWrapper> getUsersAPICallOut()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/users');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
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
            WebUserWrapperAuraEnabled webUserAuraEnabled = new WebUserWrapperAuraEnabled();
            webUserAuraEnabled.id = webUser.Id;
            webUserAuraEnabled.name = webUser.name;
            webUserAuraEnabled.userName = webUser.userName;
            webUserAuraEnabled.email = webUser.email;
            if (webUser.company != null)
            {
                webUserAuraEnabled.company = webUser.company.name;        
            }
            listWebUsersAuraEnabled.add(webUserAuraEnabled);
        } 
        return listWebUsersAuraEnabled;
    }
    /*@AuraEnabled
    public static void */
    
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