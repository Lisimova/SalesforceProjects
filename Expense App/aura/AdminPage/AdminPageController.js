/**
 * Created by Lenovo on 13.04.2020.
 */

({
    doInit : function (component, event, helper) {

        var today = new Date();
        var year = today.getFullYear();

        helper.fillBalance(component, event, year);
        helper.fillAverage(component, event, year);
        helper.fillAllData(component, event, year);
        helper.fillSumOffices(component, event, year);
        helper.fillTotal(component, event, year);
        helper.fillTotalSum(component, event, year);

        var action = component.get("c.getRegionalExpenses");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var options = [];
                for (var i = 0; i < result.length; i++){
                    var option = {
                        "label": result[i],
                        "value": year - i
                    };
                    options.push(option);
                }
                component.set("v.options", options);
            }
        });

        $A.enqueueAction(action);

        var action = component.get("c.getAllOffices");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.offices", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        var action = component.get("c.getMonths")
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.months", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        component.find("combobox").set("v.value", year);

    },

    handleClick : function (component, event, helper) {

        var office = event.getSource().get("v.value");
        helper.toOffice(component, office);
    },

    handleChange : function (component, event, helper) {

        var year = event.getParam("value");

        component.find("combobox").set("v.value", year/1);
        helper.fillBalance(component, event, year);
        helper.fillAverage(component, event, year);
        helper.fillAllData(component, event, year);
        helper.fillSumOffices(component, event, year);
        helper.fillTotal(component, event, year);
        helper.fillTotalSum(component, event, year);
    }
});