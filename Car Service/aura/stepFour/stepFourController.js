({
    clickCreate : function (component,event,helper) {
         var newProductItem = component.get("v.newProductItem");
         //set the default accountId is null 
         newProductItem.Product2Id = null ; 
         newProductItem.LocationId = null ;
         var isValid = true;
        if(component.get("v.selectedLookUpProduct").Id != undefined)
           newProductItem.Product2Id = component.get("v.selectedLookUpProduct").Id;
        else {
            isValid = false;
            var message = component.find("errorProduct");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        if(component.get("v.selectedLookUpLocation").Id != undefined)
        	newProductItem.LocationId = component.get("v.selectedLookUpLocation").Id;
        else {
            isValid = false;
            var message = component.find("errorLocation");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        
       //call apex class method
      if(isValid) {
      	var action = component.get('c.saveProductItem');
        	action.setParams({
            	'newProductItem': newProductItem
        	})
      	action.setCallback(this, function(response) {
        	//store state of response
        	var state = response.getState();
        	if (state === "SUCCESS") {
          	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            	title: "Success!",
                message: "Your Product Item was created!",
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