/**
 * Created by alena on 26.02.2020.
 */

({
    doInit : function (component) {

        var action = component.get("c.fillSelect");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.baseCurrencies', response.getReturnValue());
            }
        })
        $A.enqueueAction(action);

    },

    selectChange : function (component) {

        var baseCurrency = component.find('select').get('v.value');

        var action = component.getEvent("passCurrency");
        action.setParams({
            "baseCurrency": baseCurrency
        });

        action.fire();

    }
});