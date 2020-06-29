public class stepThreeController {

    @AuraEnabled
	public static ProductRequired saveProductRequired (ProductRequired newProductRequired) {
		
        insert newProductRequired;
        
        return newProductRequired;
	}
}