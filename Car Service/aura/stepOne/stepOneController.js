({
    clickCreate : function(component, event, helper) {
        var validWorkType = component.find('workType').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validWorkType){
            var newWorkType = component.get("v.newWorkType");
            helper.saveWorkType(component, newWorkType);
    	}
    }
})