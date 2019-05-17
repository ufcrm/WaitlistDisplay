@isTest
public class UFLobbyMgmtWaitlistBoardCtrlTest {
    
    public static testMethod void testGetCases() {
        PageReference pageRef = Page.UFLobbyMgmtWaitlistBoardPage;
		pageRef.getParameters().put('lobbyId','SFA');
		pageRef.getParameters().put('fontSize','20');
		pageRef.getParameters().put('display','landscape');
		pageRef.getParameters().put('numOfRecsString','34');
        Test.setCurrentPage(pageRef);
    
    	UFLobbyMgmtWaitlistBoardCtrl ctrl = new UFLobbyMgmtWaitlistBoardCtrl();
        ctrl.getCases();
        
    }
    
    public static testMethod void testrefreshList() {
    	UFLobbyMgmtWaitlistBoardCtrl ctrl = new UFLobbyMgmtWaitlistBoardCtrl();
        ctrl.refreshCaseList();
    	PageReference pageRef = ctrl.refreshList();        
    }
}