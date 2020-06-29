public class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        String sQuery = '';
        if(ObjectName == 'Skill') 
            sQuery =  'select id, DeveloperName from ' + ObjectName + ' where DeveloperName LIKE: searchKey order by createdDate DESC limit 5';
        else If(ObjectName == 'WorkOrder')
            sQuery =  'select id, WorkOrderNumber from ' + ObjectName + ' where WorkOrderNumber LIKE: searchKey order by createdDate DESC limit 5';
        else  
        	sQuery =  'select id, Name from ' + ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        
        List < sObject > lstOfRecords = Database.query(sQuery);
       
        return lstOfRecords;
    }
}