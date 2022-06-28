public with sharing class ControllerCotizacion {
    private final sObject parent;
    public List<QuoteLineItem> quoteLI {get;set;}

    public ControllerCotizacion(ApexPages.StandardController controller){
        parent=controller.getRecord();
    }
    
    public void qlis(){
        Id Quote = ApexPages.currentPage().getParameters().get('id');
        quoteLI = [SELECT Id, Product2Id, QuoteId, UnitPrice, TotalPrice, Subtotal, Quantity, Product2.Name FROM QuoteLineItem where QuoteId = :Quote];
    }


}