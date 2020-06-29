({
    clickCreate : function (component,event,helper) {
         var newSkillRequirement = component.get("v.newSkillRequirement");
         var isValid = true;
           //set the default accountId is null 
           newSkillRequirement.RelatedRecordId = null ; 
           newSkillRequirement.SkillId = null ;
        if(component.get("v.selectedLookUpWorkType").Id != undefined)
           newSkillRequirement.RelatedRecordId = component.get("v.selectedLookUpWorkType").Id;
        else {
            isValid = false;
            var message = component.find("errorWorkType");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        
        if(component.get("v.selectedLookUpSkill").Id != undefined){
        	newSkillRequirement.SkillId = component.get("v.selectedLookUpSkill").Id;
        }
        else {
            isValid = false;
            var message = component.find("errorSkill");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        
        if(isValid) {
      		var action = component.get('c.saveSkillRequirement');
        	action.setParams({
            	'newSkillRequirement': newSkillRequirement
        	})
      		action.setCallback(this, function(response) {
        		//store state of response
        		var state = response.getState();
        		if (state === "SUCCESS") {
         			var evt = $A.get("e.force:navigateToComponent");
         			evt.setParams({
         				componentDef : "c:stepThree",
            			componentAttributes: {
            				selectedLookUpWorkType : component.get("v.selectedLookUpWorkType")
            			}
         			});
         			evt.fire();
        		}
      		});
      		$A.enqueueAction(action);
        }
    }
})