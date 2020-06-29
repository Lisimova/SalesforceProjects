@isTest
public class ContinueCarServiceTest {

    @isTest
    private static void allAppTest() {
        
        WorkOrder newWorkOrder = new WorkOrder();
        workOrderFormController.createWorkOrder(newWorkOrder);
        
        WorkOrderLineItem newWorkOrderLineItem = new WorkOrderLineItem(WorkOrderId = newWorkOrder.Id);
        lineItemController.saveNewWorkOrderLineItem(newWorkOrderLineItem);
        
    }
}