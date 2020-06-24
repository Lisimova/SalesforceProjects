/**
 * Created by alena on 17.03.2020.
 */
({
    doInit : function (component, event, helper) {

        var today = new Date();
        var year = component.get("v.year");
        if(year ==  null)
            year = today.getFullYear();
        var month = today.toLocaleString('En-en', { month: 'long' });
        component.set("v.month", month);
        component.set("v.year", year);
        var contactId = component.get("v.contactId");
        helper.getAllDatas(component, year, contactId);
    },

    handleYear : function (component, event, helper) {

        var year = event.getParam("year");
        var contactId = component.get("v.contactId");
        component.set('v.year', year);
        var action = component.getEvent("passyearFromMonth");
        action.setParams({"year": year});
        action.fire();
        helper.getAllDatas(component, year, contactId);
    },

    handleMonth : function (component, event) {

         var action = component.getEvent("passyearmonth");
         var month = event.target.dataset.menuItemId;
         var year = component.get("v.year");
         action.setParams({"year": year, "month": month });
         action.fire();
    },

    handleRender : function (component, event, helper) {

        var year = component.get("v.year");
        var render = event.getParam("render");
        var contactId = component.get("v.contactId");
        component.set("v.render", render);

        helper.getAllDatas(component, year, contactId);

    }
})