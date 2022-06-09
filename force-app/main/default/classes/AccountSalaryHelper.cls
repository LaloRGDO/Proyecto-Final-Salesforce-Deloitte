/*
-Desarrollado por Eduardo Reséndez Guajardo
-Clase Helper para trigger AccountSalaryTrigger
-Fecha: 8 Junio 2022
-Versión: 1.0
*/
public with sharing class AccountSalaryHelper {

    public static void updateAccount(List<Account_Salary__c> newAccountSalaries, Map<Id, Account_Salary__c> oldMap){
        Set<Id> accountIds = new Set<Id>();
        for (Account_Salary__c newAccountSalary : newAccountSalaries){
            if (oldMap!=null){
                Account_Salary__c oldAccountSalary = oldMap.get(newAccountSalary.Id);
                if (oldAccountSalary.Salary__c != newAccountSalary.Salary__c){
                    accountIds.add(newAccountSalary.Account__c);
                }
            } else {
                accountIds.add(newAccountSalary.Account__c);
            }
        }
         
        if (!accountIds.isEmpty()){
            List<AggregateResult> aggResults = [Select Account__c accId, sum(Salary__c) sumSalary, max(Salary__c) maxSalary from Account_Salary__c where Account__c IN :accountIds Group By Account__c];
             
            List<Account> accountsToUpdate = new List<Account>();
            for (AggregateResult aggResult : aggResults){
                Id accountId = (Id)aggResult.get('accId');
                if (accountId!=null){
                    Account updateAccount = new Account();
                    updateAccount.Id =accountId;
                    updateAccount.Total_Salary__c=(Decimal)aggResult.get('sumSalary');
                    updateAccount.Max_Salary__c = (Decimal)aggResult.get('maxSalary');
                    accountsToUpdate.add(updateAccount);
                }
            }
             
            if (!accountsToUpdate.isEmpty()){
                SavePoint sp = Database.setSavePoint();
                try{
                    update accountsToUpdate;
                } catch(DMLException ex){
                    Database.rollback(sp);
                }
            }
        }
    }
}