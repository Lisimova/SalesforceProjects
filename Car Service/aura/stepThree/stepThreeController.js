({
	clickCreate : function (component,event,helper) {
         var newProductRequired = component.get("v.newProductRequired");
           //set the default accountId is null 
         newProductRequired.ParentRecordId = null ; 
         newProductRequired.SkillId = null ;
         var isValid = true;
        if(component.get("v.selectedLookUpWorkType").Id != undefined)
        	newProductRequired.ParentRecordId = component.get("v.selectedLookUpWorkType").Id;
        else {
            isValid = false;
            var message = component.find("errorWorkType");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        
        if(component.get("v.selectedLookUpProduct").Id != undefined)
        	newProductRequired.Product2Id = component.get("v.selectedLookUpProduct").Id;
        else {
            isValid = false;
            var message = component.find("errorProduct");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        
       //call apex class method
      if(isValid) {
      	var action = component.get('c.saveProductRequired');
        action.setParams({
            'newProductRequired': newProductRequired
        })
      	action.setCallback(this, function(response) {
        	//store state of response
        	var state = response.getState();
        	if (state === "SUCCESS") {
         		var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:stepFour",
                        componentAttributes: {
                            selectedLookUpProduct: response.getReturnValue()
                        }
                    });
                    evt.fire();
        		}
      		});
      	$A.enqueueAction(action);
      }
    }
})