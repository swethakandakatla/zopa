({
	fetchUsers : function(cmp, event) {
		var action = cmp.get("c.getUsers");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null || data.length > 0)
                {
                    cmp.set('v.data', data);
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "No record found.",
                        "type": "warning"
                    });
                    toastEvent.fire(); 
                }
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error fetching records.",
                    "type": "error"
                });
                toastEvent.fire();   
                //show error messge
            }
        });
        $A.enqueueAction(action);
	},
    importData: function(cmp, event) {
   		var action = cmp.get("c.saveUsers");
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.data', data);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Import process done.",
                    "type": "success"
                });
                toastEvent.fire(); 
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error saving records.",
                    "type": "error"
                });
                toastEvent.fire();   
                //show error messge
            }
        });
        $A.enqueueAction(action);
    }
})