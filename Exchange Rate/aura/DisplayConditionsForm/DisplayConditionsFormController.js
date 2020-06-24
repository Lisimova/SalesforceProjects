/**
 * Created by alena on 24.02.2020.
 */

({
    doInit: function (component) {

        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
    },

    changeDateFrom : function (component) {

        component.set('v.disabled', false);
        //var dateFrom = component.get('v.dateFrom');
    },

    clickDisplay : function (component) {

        var action = component.getEvent("displayData");
        action.setParams({
            "dateFrom": component.get('v.dateFrom'),
            "dateTo": component.get('v.dateTo'),
        });

        action.fire();
    }
});