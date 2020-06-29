public with sharing class lineItemController {
    
    @AuraEnabled
    public static Id saveNewWorkOrderLineItem (WorkOrderLineItem newWorkOrderLineItem) {
        
        insert newWorkOrderLineItem;
        
        return newWorkOrderLineItem.Id;
    }
}