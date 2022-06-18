public with sharing class LWCQuoteController {

    @AuraEnabled(cacheable=true)
    public static List<Product2> buscarProducto(String codigoProducto) {
        System.debug(codigoProducto);
        List<Product2> listaProducto = [SELECT Id, Name, ProductCode, Cantidad_disponible__c, (SELECT id, Cantidad_dis__c, Cantidad_apart__c FROM Inventarios_Custom__r), (SELECT id, UnitPrice FROM PricebookEntries) FROM Product2 WHERE ProductCode = :codigoProducto];
        return listaProducto;
    }


}