/**
 * Created by alena on 26.02.2020.
 */

({
    handleDisplay : function (component, event) {

        var dateFrom = event.getParam("dateFrom");
        var dateTo = event.getParam("dateTo");

        var action = component.get("c.getExchangeRatesPeriod");

        action.setParams({
            dateFrom: dateFrom,
            dateTo: dateTo
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var action1 = component.get("c.showPeriod");
                action1.setParams({
                    dateFrom: dateFrom,
                    dateTo: dateTo
                });
                action1.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set('v.gridData', response.getReturnValue());
                    }
                })
                $A.enqueueAction(action1);
            }
        })
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