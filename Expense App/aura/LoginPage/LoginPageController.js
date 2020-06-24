/**
 * Created by alena on 13.03.2020.
 */
({
    getContact : function(component) {

        var username = component.get('v.username');
        
        var action = component.get("c.getContactId");
        action.setParams({
            username: username,
            password: component.get('v.password')
        });

        action.setCallback(this, function (response) {

             var state = response.getState();
             if (state === "SUCCESS") {
                 if (response.getReturnValue() == null)
                    document.getElementById("error").style.display = 'block';
                 else
                    component.set("v.contactId", response.getReturnValue());
             }
        });
        $A.enqueueAction(action);
    },

    handleValueChange : function(component, event) {

        var action = component.get("c.checkAdmin");

        action.setParams({
            contactId: component.get("v.contactId")
        });

        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() == false){

                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:ExpensesOfficePage",
                        componentAttributes: {
                            contactId : event.getParam("value")
                        }
                    });
                    evt.fire();
                }

                else {
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:AdminPage",
                        componentAttributes: {

                        }
                    });
                    evt.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})