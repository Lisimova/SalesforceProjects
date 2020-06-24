/**
 * Created by alena on 24.02.2020.
 */

({
    doInit : function (component, event, helper) {
        var action = component.get("c.getExchangeRates");
		
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.gridData', response.getReturnValue());
                component.set('v.loaded', true);
            }
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.fillSelect");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var baseCurrencies = response.getReturnValue();
                var columns = [];
                columns.push({label: 'Date', fieldName: 'Date__c', type: 'date'});
                for (var i = 0; i < baseCurrencies.length; i++)
                    columns.push({label: baseCurrencies[i], fieldName: baseCurrencies[i] + '__c', type: 'currency', typeAttributes: { currencyDisplayAs:"symbol", currencyCode: component.get("v.baseCurrency")}});
      			component.set('v.columns', columns);
            }
        })
        $A.enqueueAction(action);
    }
});