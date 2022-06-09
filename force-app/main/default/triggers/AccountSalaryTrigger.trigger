/*
-Desarrollado por Eduardo Reséndez Guajardo
-Este trigger se ejecuta cuando una cuenta se inserta, actualiza, borra o se recuperan registros
-Fecha: 8 Junio 2022
-Versión: 1.0
*/

trigger AccountSalaryTrigger on Account_Salary__c (after insert, after update, after delete, after undelete) {
    if (Trigger.isUpdate){
        AccountSalaryHelper.updateAccount(Trigger.new, Trigger.oldMap);
    } else if (Trigger.isDelete){
       AccountSalaryHelper.updateAccount(Trigger.old, null);
    } else {
       AccountSalaryHelper.updateAccount(Trigger.new, null);
    }
}