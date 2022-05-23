/**
 * Created by jesus.cantero on 13/05/2021.
 */

({
    init: function (cmp, event, helper) 
    {
        //create columns in the table 
        var colm= [
            {label: 'Id', fieldName: 'id', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'UserName', fieldName: 'userName', type: 'text'},
            {label: 'Email', fieldName: 'email', type: 'email'},
            {label: 'Company Name', fieldName: 'company', type: 'text'},
            {label: 'Creation Status', fieldName: 'createstatus', type: 'text'}
        ];
        
        cmp.set('v.columns',colm); //pushing columns to the component
        helper.fetchUsers(cmp, event); //calling fetchUsers function
    },
    importData: function (cmp, event, helper) {
        helper.importData(cmp, event); // calling importData function
    },
});