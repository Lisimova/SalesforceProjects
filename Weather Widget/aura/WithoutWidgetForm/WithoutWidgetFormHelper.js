/**
 * Created by alena on 14.02.2020.
 */

({
    changeForm : function(component, city) {
        var action = component.get("c.makeGetResponse");

        action.setParams({
            city: city.Name
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    component.set("v.weather", result[0]);
                    component.set("v.weatherList", result);
                }
                else {
                    document.getElementById("allForm").style.display = "none";
                    document.getElementById("error").style.display = "block";
                }
            }
        });
        $A.enqueueAction(action);
    }
});