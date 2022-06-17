public with sharing class CotizadorController {
    
    private final sObject parent;
    public String codigoProducto {get;set;}
    public List<Product2> invList {get;set;}
    public double cantidad {get;set;}
    //public ID QuoteId {get;set;}
    
    public CotizadorController(ApexPages.StandardController controller){
        parent=controller.getRecord();
    }
        
    public void buscar(){
        if(QuotationHelper.confirmProductExistByCode(codigoProducto)){
            invList = [SELECT Id, Name, ProductCode, Cantidad_disponible__c, (SELECT id, Cantidad_dis__c, Cantidad_apart__c FROM Inventarios_Custom__r), (SELECT id, UnitPrice FROM PricebookEntries) FROM Product2 WHERE ProductCode = :codigoProducto];
            /*for(Product2 p:invList){
                p.Cantidad_disponible__c = null;
            }*/
            this.cantidad = null;
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Producto no encontrado, verifique que el Código del Producto sea el correcto'));
        }        
        //double cantidadDisponible = QuotationHelper.searchProductByCode(codigoProducto);
    }
      
    public void atras(){
        invList.clear();
        codigoProducto='';
    }
    
    public void guardar(){
        try{
            PriceBookEntry pbe = [SELECT id, Name, ProductCode, UnitPrice, Product2Id FROM PriceBookEntry WHERE ProductCode = :codigoProducto LIMIT 1];
            Id QuoteId = ApexPages.currentPage().getParameters().get('id');
            QuoteLineItem nuevoQli = new QuoteLineItem(Product2Id = pbe.Product2Id,
                                                       Quantity = cantidad,
                                                       QuoteId = QuoteId,
                                                       UnitPrice = pbe.UnitPrice,
                                                       PriceBookEntryId = pbe.Id); 
            insert nuevoQli;
            
        }catch(DmlException ex){
            ex.getMessage();
        }
    }

}