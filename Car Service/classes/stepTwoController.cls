public with sharing class stepTwoController {
	@AuraEnabled
	public static void saveSkillRequirement (SkillRequirement newSkillRequirement) {
		
        insert newSkillRequirement;
	}
}