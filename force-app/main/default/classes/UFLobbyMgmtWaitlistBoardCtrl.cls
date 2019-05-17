public class UFLobbyMgmtWaitlistBoardCtrl {
    public ApexPages.StandardSetController setCon { get; set; }
    public Account lobby { get; set; }
    public String lobbyId { get; set; }
	public Integer fontSize { get; set; }
	public String display { get; set; }
	public String numOfRecsString { get; set; }

    public Integer numberOfRecs { get; set; }
    public Integer pageNumber { get; set; }
    public Integer totalRecs { get; set; }
    public Integer recordsInSet { get; set; }
    
    public UFLobbyMgmtWaitlistBoardCtrl() { 
        if(apexpages.currentpage().getparameters().get('lobbyId') != '' && apexpages.currentpage().getparameters().get('lobbyId') != null) {
            lobbyId = apexpages.currentpage().getparameters().get('lobbyId');
        } else {
            lobbyId = 'SFA';
        }
	   
        if(apexpages.currentpage().getparameters().get('font') != '' && apexpages.currentpage().getparameters().get('font') != null) {
            fontSize = Integer.valueOf(apexpages.currentpage().getparameters().get('font'));
        } else {
            fontSize = 20;
        }
	   
        if(apexpages.currentpage().getparameters().get('display') != '' && apexpages.currentpage().getparameters().get('display') != null) {
            display = apexpages.currentpage().getparameters().get('display');
        } else {
            display = 'landscape';
        }
	   
        if(apexpages.currentpage().getparameters().get('numberOfRecs') != '' && apexpages.currentpage().getparameters().get('numberOfRecs') != null) {
            numOfRecsString = apexpages.currentpage().getparameters().get('numberOfRecs');
        } else {
            numOfRecsString = '34';
        }
         
        numberOfRecs = Integer.valueOf(numOfRecsString);
        refreshCaseList();
    }
    
    public void refreshCaseList() {        
        system.debug('In refreshCaseList...');
        
        // Get variables for the query
        DATETIME dToday = date.today();        
        
        // Get lobby queue based on parameter
        ID QueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = :lobbyId LIMIT 1].Id;
        
        // Query Case
        // Can we have a setting to determine whether it is SFA or a Lobby Mgmt lobby?
        //   or just check if name is SFA? else query is a Lobby Mgmt query.
        String query = 'SELECT CreatedDate, Check_in_Time__c, Contact.FirstName, Contact.LastName, SuppliedName FROM Case WHERE Owner.Id = \'' + QueueId +
            '\' AND Being_Edited__c = false AND Status = \'New\' AND Origin = \'SFA Lobby\' AND CreatedDate >= TODAY ORDER BY CreatedDate';
		System.debug(query);
        
        // Set properties of set controller
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        
        if(numberOfRecs != null) {
        	setCon.setPageSize(numberOfRecs);
        } else {
            setCon.setPageSize(20);
        }
        
        // Get total records from query & pagenumber for rendering records in appropriate table and page
        totalRecs = setCon.getResultSize();
        pageNumber = setCon.getPageNumber();
    }
    
    public List<Case> getCases() {
        return (List<Case>) setCon.getRecords();
	}
    
    public PageReference refreshList() {
        if(setCon.getHasNext()) {
            setCon.next();
        	pageNumber = setCon.getPageNumber();
            recordsInSet = numberOfRecs * setCon.getPageNumber();
        } else {
        	refreshCaseList();
        }
        return null;
    }

}