/**
 * Created by alena on 13.02.2020.
 */

({
    doInit: function (component, event, helper) {

        var action = component.get("c.makeGetResponse");

        action.setParams({
            city: component.get("v.city")
            });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.weather", result[0]);
                component.set("v.weatherList", result);
            }
        });
        $A.enqueueAction(action);
        },

    parseToCelsius : function (component, event, helper) {

        var action = component.get("c.fahrenheitToCelsius");
        action.setParams({
            weatherList: component.get("v.weatherList")
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === 'SUCCESS') {

                var result = response.getReturnValue();
                component.set("v.weatherList", result);
            }
        });
        $A.enqueueAction(action);
        },

    parseToFahrenheit : function(component, event, helper) {

        var action = component.get("c.celsiusToFahrenheit");
        action.setParams({
            weatherList: component.get("v.weatherList")
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === 'SUCCESS') {

                var result = response.getReturnValue();
                component.set("v.weatherList", result);
            }
        });
        $A.enqueueAction(action);
        },

    handleChangeWeather : function (component, event, helper) {

        var city = event.getParam("city");
        helper.changeForm(component, city);
    },

    showTemperature : function (component, event, helper) {

        document.getElementById("temperatureInfo").style.display = "block";
        document.getElementById("otherInfo").style.display = "none";
    },

    showOther : function (component, event, helper) {

        document.getElementById("temperatureInfo").style.display = "none";
        document.getElementById("otherInfo").style.display = "block";
    },

})