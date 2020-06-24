/**
 * Created by alena on 24.03.2020.
 */
({
    doInit : function (component, event, helper) {

        var today = new Date();
        var year = today.getFullYear();
        var month = today.getMonth();
        var contactId = component.get("v.contactId");
        component.set('v.columns', [
            {label: 'DESCRIPTION', fieldName: 'Description__c', fixedWidth: 500, type: 'Text', editable: 'true'},
            {label: 'AMOUNT', fieldName: 'Amount__c', type: 'currency', fixedWidth: 100, typeAttributes: { currencyCode: 'USD'}, editable: 'true'},
            {label: 'ACTION', type: 'button', fixedWidth: 100, typeAttributes: { label: 'Delete', name: 'delete', variant: 'base'}}
        ]);

        var childCmp = component.find("compMonth");
        childCmp.sampleMethod(year);
        
        helper.sortByDate(component, month, year, contactId);
    },

    handleYearMonth : function (component, event, helper) {

        var year = event.getParam("year");
        var month = event.getParam("month");
        var contactId = component.get("v.contactId");

        component.set("v.month", month);
        component.set("v.year", year);
        helper.sortByDate(component, month, year, contactId);
    },

    itemsChange : function (component, event, helper) {

        var action = component.getEvent("passyearmonthToHome");
        var month = component.get("v.month");
        var year = component.get("v.year");
        var contactId = component.get("v.contactId");

        action.setParams({"year": year, "month": month });
        action.fire();
        helper.sortByDate(component, month, year, contactId);
    },

    yearChange : function (component, event) {

        var year = event.getParam("year");
        component.set("v.year", year);
        var action = component.getEvent("passyearFromExp");
        action.setParams({"year": year});
        action.fire();
    },

    renderComponent : function (component) {
        var action = component.getEvent("rerenderBalance");
        action.fire();
    },

    deleteSelected : function (component, event, helper) {

        var expenseCard = event.getParam('row');
        var action = component.get("c.deleteExpenseCard");
        action.setParams({
            expenseCard: expenseCard
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var action1 = component.getEvent("rerenderBalance");
        			action1.fire();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Expense Card was deleted!",
                    type: "success"
                });
                toastEvent.fire();
            }
            helper.sortByDate(component, component.get("v.month"), component.get("v.year"), component.get("v.contactId"));
        	helper.rerenderComponents(component);
        });
        $A.enqueueAction(action);
    },

    onSave : function (component, event, helper) {

        var updatedRecords = event.getParam('draftValues');
        if(component.get("v.render") === true)
            component.set("v.render", false);
        else
            component.set("v.render", true);

        var action = component.get("c.updateExpenseCards");

        action.setParams({
            expenseCards: updatedRecords
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()) {
                    var action1 = component.getEvent("rerenderBalance");
        			action1.fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message: "Expense Cards was updated!",
                        type: "success"
                        });
                    toastEvent.fire();
                }
                
                helper.sortByDate(component, component.get("v.month"), component.get("v.year"), component.get("v.contactId"));
                helper.rerenderComponents(component);
                
            }
        });
        
        $A.enqueueAction(action);
       
      
    },

    passToMonth : function (component) {
        var childCmp = component.find("compMonth");
        childCmp.sampleMethod();
    }
})