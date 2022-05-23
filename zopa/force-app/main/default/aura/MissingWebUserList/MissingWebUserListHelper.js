({
	fetchUsers : function(cmp, event) {
        //call apex class method
		var action = cmp.get("c.getUsers");
        action.setCallback(this, function(response) 
        {            
            var state = response.getState();//store state of response
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null || data.length > 0)
                {                    
                    cmp.set('v.data', data);//set response value in wrapperList attribute on component.
                }
                else
                {
                    //whenever there is no records, A toast displays a message below the header at the top of a view
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
              // toast displays a message below the header at the top of a view
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error fetching records.",
                    "type": "error"
                });
                toastEvent.fire();   
            }
        });
        $A.enqueueAction(action);
	},
    importData: function(cmp, event) {
        //call apex class method
   		var action = cmp.get("c.saveUsers");
        action.setCallback(this, function(response) {
             //store state of response
            var data = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") 
            {
               cmp.set('v.data', data);//set response value in wrapperList attribute on component.
                //A toast displays a message below the header at the top of a view
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
                //A toast displays a message below the header at the top of a view
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error saving records.",
                    "type": "error"
                });
                toastEvent.fire();                  
            }
        });
        $A.enqueueAction(action);
    }
})