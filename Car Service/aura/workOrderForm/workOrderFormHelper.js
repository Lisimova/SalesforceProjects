({
	saveWorkOrder : function(component, newWorkOrder) {

		var action  = component.get("c.createWorkOrder");
		action.setParams({
		    "newWorkOrder": newWorkOrder
		});
		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                 var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:lineItem",
                        componentAttributes: {
                            selectedLookUpWorkOrder : response.getReturnValue()
                        }
                    });
                    evt.fire();
            }
        });
        $A.enqueueAction(action);
	}
})