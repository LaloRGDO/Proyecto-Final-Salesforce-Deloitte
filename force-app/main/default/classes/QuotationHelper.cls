public class QuotationHelper {
    
    public void initialConfig(){
        Account acct1 = new Account(Name = 'Compumundo');
        Account acct2 = new Account(Name = 'Compuworld');
        
        List<Account> accountList = new List<Account>();
        accountList.add(acct1);
        accountList.add(acct2);
        
        insert accountList;
    }
    
    public List<Inventario_Custom__c> productsInInventory(){
        List<Inventario_Custom__c> inventarioLista = [SELECT Id, Name FROM Inventario_Custom__c LIMIT 100];
        for(Inventario_Custom__c inv : inventarioLista){
            System.debug(inv.Name);
        }
        return inventarioLista;
    }

}