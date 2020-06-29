@isTest
private class customLookUpControllerTest {
    
    @isTest
    private static void fetchLookUpValuesTest() {
        System.assertEquals(0, customLookUpController.fetchLookUpValues('Wh', 'Product2').size());
        System.assertEquals(0, customLookUpController.fetchLookUpValues('0', 'WorkOrder').size());
        System.assertEquals(1, customLookUpController.fetchLookUpValues('ch', 'Skill').size());
    }
}