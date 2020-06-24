/**
 * Created by alena on 17.03.2020.
 */
({
    getAllDatas : function(component, year, contactId) {

        var action = component.get("c.getAllData");
        action.setParams({
            year: year,
            contactId: contactId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                var arrayMapKeys = [];
                for(var key in result){
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                component.set("v.dataTable", arrayMapKeys);
            }
        });
        $A.enqueueAction(action);

        var action = component.get("c.getTotalAmount");
        action.setParams({
            year: year,
            contactId: contactId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.totalAmount", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        var action = component.get("c.getTotalIncome");
        action.setParams({
            year: year,
            contactId: contactId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.totalIncome", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})