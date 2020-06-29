public class stepFourController {
    @AuraEnabled
	public static Id saveProductItem (ProductItem newProductItem) {		
        insert newProductItem;
        
        return newProductItem.Id;
	}
}