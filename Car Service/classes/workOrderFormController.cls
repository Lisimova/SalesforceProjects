public with sharing class workOrderFormController {
	@AuraEnabled
    public static WorkOrder createWorkOrder (WorkOrder newWorkOrder) {
        
        insert newWorkOrder;
       	WorkOrder wo = [Select Id, WorkOrderNumber From WorkOrder Where Id = :newWorkOrder.Id Limit 1];
        return wo;
    }
}