({
	clickCreate : function(component, event, helper) {
        
        var validWorkOrder = component.find('workOrder').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validWorkOrder){
            var newWorkOrder = component.get("v.newWorkOrder");
            newWorkOrder.WorkTypeId = null;
            if(component.get("v.selectedLookUpWorkType").Id != undefined)
           		newWorkOrder.WorkTypeId = component.get("v.selectedLookUpWorkType").Id;
            helper.saveWorkOrder(component, newWorkOrder);
    	}
    }
})