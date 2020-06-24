/**
 * Created by alena on 25.02.2020.
 */

({
    doInit : function (component) {

        var action = component.get("c.getValueForField");

        action.setParams({
            exchangeRate : component.get('v.object'),
            field : component.get('v.field'),
            baseCurrency: component.get('v.baseCurrency')
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.fieldVal', response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
    }
});