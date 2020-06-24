/**
 * Created by Lenovo on 30.03.2020.
 */

({
    createExpense : function(component, newExpense) {
        var action = component.get("c.saveExpense");
        action.setParams({
            newExpense: component.get("v.newExpense")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            component.set("v.contactId", state);
            if (state === "SUCCESS") {
                component.set("v.contactId", newExpense);
            }
        });
        $A.enqueueAction(action);
    },

    handleBalance : function(component) {

        var action = component.get("c.getBalance");
        action.setParams({
            contactId: component.get("v.contactId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.balance", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
});