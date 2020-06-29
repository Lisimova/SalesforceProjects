@IsTest
private class CarServiceTest {

    @isTest
    static void testApp() {
        WorkType testWorkType = new WorkType(Name = 'test', EstimatedDuration = 2, DurationType = 'hours');
        stepOneController.createWorkType(testWorkType);
        
        Skill skill = [Select Id From Skill Limit 1];
        SkillRequirement testSkillRequirement = new SkillRequirement(RelatedRecordId = testWorkType.Id, SkillId = skill.Id);
        stepTwoController.saveSkillRequirement(testSkillRequirement);
        
        Product2 product = new Product2(Name = 'test');
        insert product;
        ProductRequired testProductRequired = new ProductRequired(ParentRecordId = testWorkType.Id, Product2Id = product.Id);
        stepThreeController.saveProductRequired(testProductRequired);
        
        ProductItem testProductItem = new ProductItem(QuantityOnHand = 40, Product2Id = product.Id, LocationId = '1312x000000L72PAAS');
        stepFourController.saveProductItem(testProductItem);
    }
}