public class InventarioViewController {
    
    private final sObject parent;
    public String codigo {get;set;}
    public List<Inventario_Custom__c> listInv{get;set;}
    
    public InventarioViewController(ApexPages.StandardController controller){
        parent = controller.getRecord();
    }
    
    public void buscar(){
        String query = 'SELECT id, Product_Code__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c WHERE Product_Code__c = :codigo';
        listInv = Database.query(query);
    }
    
    public void limpiar(){
        listInv.clear();
    }

}