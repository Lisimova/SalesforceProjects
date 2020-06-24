/**
 * Created by alena on 17.03.2020.
 */
({
    doInit : function (component) {

        var today = new Date();
        var year = today.getFullYear();
        //component.set("v.year", year);
        var action = component.get("c.getYears");
        action.setParams({
            year: year
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var years = [];
                for (var i = 0; i < 4; i++){
                    var year = {
                        "label": result[i],
                        "value": result[i]
                    };
                    years.push(year);
                }
                component.set("v.years", years);
                component.set("v.year", years[3].value);
            }
        });
        $A.enqueueAction(action);
    },

    selectYear : function (component, event) {

        var action = component.getEvent("passyear");
        var year = event.getSource().get("v.value");
        action.setParams({"year": year});
        action.fire();
    }
})