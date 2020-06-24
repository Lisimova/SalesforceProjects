/**
 * Created by Lenovo on 14.04.2020.
 */

({
    toOffice : function(component, office) {

        var action = component.get("c.goToOffice");
        action.setParams({
            office: office
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:ExpensesOfficePage",
                    componentAttributes: {
                        contactId : response.getReturnValue()
                    }
                });
                evt.fire();
            }
        });
        $A.enqueueAction(action);
    },

    fillBalance : function(component, event, year) {

        var action = component.get("c.getBalance");
        action.setParams({
            year: year
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.balances", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fillAverage : function (component, event, year) {

        var action = component.get("c.getAverage");
        action.setParams({
            year: year
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.average", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

   fillAllData : function (component, event, year) {

        var action = component.get("c.getAllData");
        action.setParams({
            year: year
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fillSumOffices : function (component, event, year) {
        var action = component.get("c.getSumOffices");
        action.setParams({
            year: year
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.sumData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fillTotal : function (component, event, year) {

        var action = component.get("c.getTotal");
        action.setParams({
            year: year
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.totalSum", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fillTotalSum : function (component, event, year) {

        var action = component.get("c.getTotalSum");
        action.setParams({
            year: year
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.totalData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
});