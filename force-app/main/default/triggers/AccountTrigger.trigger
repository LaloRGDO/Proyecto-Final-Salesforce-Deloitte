/*
-Desarrollado por Eduardo Reséndez Guajardo
-Este trigger se ejecuta cuando una cuenta ...
-Fecha: 7 Junio 2022
-Versión: 1.0
*/

trigger AccountTrigger on Account (before insert, before update, after update) {
    if(Trigger.isBefore && Trigger.isInsert){
        System.debug('I am in AccountTrigger before insert context');
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            for(Account acc : Trigger.new){
                System.debug('New Name'+ acc.Name);
                System.debug('Old Name'+Trigger.oldMap.get(acc.Id).Name);
            }
        }
    }
}