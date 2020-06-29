({
	clickCreate : function (component, event, helper) {
         var newWorkOrderLineItem = component.get("v.newWorkOrderLineItem");
         //set the default accountId is null 
         newWorkOrderLineItem.WorkOrderId = null ; 
         newWorkOrderLineItem.WorkTypeId = null ;
         var isValid = true;
        if(component.get("v.selectedLookUpWorkOrder").Id != undefined)
           newWorkOrderLineItem.WorkOrderId = component.get("v.selectedLookUpWorkOrder").Id;
        else {
            isValid = false;
            var message = component.find("errorWorkOrder");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        if(component.get("v.selectedLookUpWorkType").Id != undefined)
        	newWorkOrderLineItem.WorkTypeId = component.get("v.selectedLookUpWorkType").Id;
        
       //call apex class method
      if(isValid) {
      	var action = component.get('c.saveNewWorkOrderLineItem');
        	action.setParams({
            	'newWorkOrderLineItem': newWorkOrderLineItem
        	})
      	action.setCallback(this, function(response) {
        	//store state of response
        	var state = response.getState();
        	if (state === "SUCCESS") {
          		var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Your Work Order Line Item was saved!",
                    type: "success"
                });
                toastEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
    			navEvt.setParams({
      				"recordId": response.getReturnValue(),
      				"slideDevName": "related"
    			});
    			navEvt.fire();
        	}
      	});
      $A.enqueueAction(action);
      }
    }
})