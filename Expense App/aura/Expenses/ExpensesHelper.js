/**
 * Created by alena on 26.03.2020.
 */
({
    sortByDate : function(component, month, year, contactId) {

        var action = component.get("c.sortExpenseCardsByDates");
        var today = new Date();
        if(month == null)
            month = today.getMonth();
        action.setParams({
            month: month,
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
                component.set("v.expenseCards", arrayMapKeys);
            }
        });
        $A.enqueueAction(action);
    },
    
    rerenderComponents : function(component) {
        
        var childCmp = component.find("compMonth");
        childCmp.sampleMethod();    
    }
})