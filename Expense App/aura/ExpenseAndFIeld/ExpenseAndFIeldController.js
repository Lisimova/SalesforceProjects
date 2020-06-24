/**
 * Created by alena on 26.03.2020.
 */
({
    doInit : function (component, event, helper) {

        var expenseList = component.get("v.expenseList");
        var action = component.get("c.getTotalAmount");
        action.setParams({
            expenseCards: expenseList,
            contactId : component.get("v.contactId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.value", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }
})