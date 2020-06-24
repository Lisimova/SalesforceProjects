/**
 * Created by alena on 13.03.2020.
 */

public with sharing class LoginPageController {

    @AuraEnabled
    public static Id getContactId (String username, String password) {

        if(username != null || password != null ) {
            List<Contact> contacts = [Select Id, Admin__c FROM Contact Where Email = :username AND Password__c = :password];
            if (contacts.size() > 0)
                return contacts[0].Id;
        }
        return null;
    }

    @AuraEnabled
    public static Boolean checkAdmin(Id contactId){

        List<Contact> contacts = [Select Id, Admin__c FROM Contact Where Id = :contactId];

        return contacts[0].Admin__c;
    }
}