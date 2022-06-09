/*
-Desarrollado por Eduardo Reséndez Guajardo
-Este trigger se ejecuta cuando una cuenta se inserta o actualiza
-Fecha: 7 Junio 2022
-Versión: 1.0
*/

trigger myAccTriggerUpdate on Account (before insert, before update) {

    for(Account acc : Trigger.New){
        if(acc.Website == null || acc.Website == ''){
            acc.adderror('La cuenta '+acc.AccountNumber+' no tiene sitio Web. Favor de capturarlo');
        }
    }

}