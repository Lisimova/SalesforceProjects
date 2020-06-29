public with sharing class stepOneController {

	@AuraEnabled
	public static WorkType createWorkType(WorkType newWorkType) {
		
        insert newWorkType;
        
        return newWorkType;
	}
}