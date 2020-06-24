/**
 * Created by alena on 16.03.2020.
 */
({
    doInit : function(component, event, helper) {

        var today = new Date();
        var year = today.getFullYear();
        var date = year + '-' + (today.getMonth()+1) + '-' + today.getDate();
        component.set("v.year", year);
        component.set("v.today", date);

        var action = component.get("c.getOffice");
        action.setParams({
            contactId: component.get("v.contactId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.office", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        helper.handleBalance(component);

    },

    openPopup : function (component) {

        component.set("v.isModalOpen", true);
    },

    closeModel: function(component) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);
    },

    saveExpense : function(component, event, helper) {

        var isValid = true;
        if(component.get("v.newExpense").Date__c != undefined) {
            isValid = false;
            var message = component.find("errorDate");
            $A.util.addClass(message, 'slds-show');
         	$A.util.removeClass(message, 'slds-hide');
        }
        
        if(isValid == true) {

        var action = component.get("c.saveNewExpense");
        action.setParams({
            newExpense: component.get("v.newExpense"),
            contactId: component.get("v.contactId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                component.set("v.isModalOpen", false);
                helper.handleBalance(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Expense Cards was saved!",
                    type: "success"
                });
                toastEvent.fire();
                var childCmp = component.find("expenses");
                childCmp.sampleMethod();
            }
        });
        $A.enqueueAction(action);
    }
    },

    handleYearMonth : function (component, event) {

        var year = event.getParam("year");
        var month = event.getParam("month");

        component.set("v.year", year);
        component.set("v.month", month);
    },

    openIncome : function (component) {
        component.set("v.isIncome", true);
    },

    closeIncome : function(component) {
        // Set isModalOpen attribute to false
        component.set("v.isIncome", false);
    },

    topUpBalance : function(component, event, helper) {

        var action = component.get("c.topBalance");
        action.setParams({
            month: component.get("v.month"),
            year: component.get("v.year"),
            contactId: component.get("v.contactId"),
            amount: component.get("v.amount")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isIncome", false);
                helper.handleBalance(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Balance was replenished!",
                    type: "success"
                });
                toastEvent.fire();
                var childCmp = component.find("expenses");
                childCmp.passToMonth();
            }
        });
        $A.enqueueAction(action);

    },

    handleYear : function(component, event, helper) {

        var year = event.getParam("year");
        component.set("v.year", year);

        helper.handleBalance(component);
    },

    changeBalance : function(component, event, helper) {
        component.set("v.check", true);
        helper.handleBalance(component);
    }
})