@IsTest
public class MissingWebUserListCtrlTest {
	@istest
    static void testmethodsuccess()
    {
        Test.setMock(HttpCalloutMock.class, new MissingWebUserAPIMock());
        List<MissingWebUserListCtrl.WebUserWrapperAuraEnabled> listUsers = MissingWebUserListCtrl.getUsers();
        system.assert(listUsers.size()  > 0, 'Success');
        MissingWebUserListCtrl.saveUsers();
        system.assert([select id from Web_User__c].size()  > 0, 'Success');
    }
    @istest
    static void testmethodfail()
    {
        Test.setMock(HttpCalloutMock.class, new MissingWebUserAPIMock());
        MissingWebUserListCtrl.saveUsers();
        
        Test.startTest();
        List<MissingWebUserListCtrl.WebUserWrapperAuraEnabled> listUsers = MissingWebUserListCtrl.saveUsers();
        system.assert(listUsers[0].createstatus.contains('Failed'), 'Success');
        Test.stopTest();
        
    }
}