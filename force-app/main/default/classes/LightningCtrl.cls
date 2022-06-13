public with sharing class LightningCtrl {
    @AuraEnabled
    public static List<Contact> getContacts(){
        return [Select Name, Phone, Email FROM Contact LIMIT 5];
    }
}