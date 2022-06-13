global with sharing class InventoryDataScheduler implements Schedulable{

    global void execute(SchedulableContext ctx){
        ExternalLegacyConnection();
    }


    @future(callout=true)
    public static void ExternalLegacyConnection(){
        System.debug('Funciona mi método ELC con Schedule');
    }
    
}