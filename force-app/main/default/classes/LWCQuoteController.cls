public with sharing class LWCQuoteController {

    @AuraEnabled(cacheable=true)
    public static List<Product2> buscarProducto(String codigoProducto) {
        System.debug(codigoProducto);
        List<Product2> listaProducto = [SELECT Id, Name, ProductCode, Cantidad_disponible__c, (SELECT id, Cantidad_dis__c, Cantidad_apart__c FROM Inventarios_Custom__r), (SELECT id, UnitPrice FROM PricebookEntries) FROM Product2 WHERE ProductCode = :codigoProducto];
        if(codigoProducto != '' && listaProducto.size()>0){
            return listaProducto;
        }else{
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static QuoteLineItem crearQli(String productId, Integer cantidadApart, Integer unitPrice, String pbeId, String QuoteId){
        //Id QuoteId = ApexPages.currentPage().getParameters().get('id');
        
        QuoteLineItem qli = new QuoteLineItem(Product2Id = productId,
                                                Quantity = cantidadApart,
                                                QuoteId = QuoteId,
                                                UnitPrice = unitPrice,
                                                PriceBookEntryId = pbeId
                                                );
        System.debug(qli);
        insert qli;
        return qli;
    }
        
}