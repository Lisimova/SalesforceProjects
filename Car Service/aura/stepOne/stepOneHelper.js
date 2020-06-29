({
	saveWorkType : function(component, newWorkType) {

		var action  = component.get("c.createWorkType");
		action.setParams({
		    "newWorkType": newWorkType
		});
		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                 var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:stepTwo",
                        componentAttributes: {
                            selectedLookUpWorkType : response.getReturnValue()
                        }
                    });
                    evt.fire();
            }
        });
        $A.enqueueAction(action);
	}
})