/**
 * Created by alena on 14.02.2020.
 */

({
    clickInputCity : function (component, event, helper) {

        var action = component.getEvent("loadingWeather");
        var city = component.get("v.city");
        action.setParams({
            "city": city
        });
        action.fire();
    }
});