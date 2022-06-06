public class QuotationHelper implements QuotationSync {
    
    public void initialConfig(){
        Account acct1 = new Account(Name = 'Compumundo');
        Account acct2 = new Account(Name = 'Compuworld');
        
        List<Account> accountList = new List<Account>();
        accountList.add(acct1);
        accountList.add(acct2);
        
        insert accountList;
    }
    
    public List<Inventario_Custom__c> productsInInventory(){
        List<Inventario_Custom__c> inventarioLista = [SELECT Id, Name, ProductCode__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c LIMIT 200];
        for(Inventario_Custom__c inv : inventarioLista){
            System.debug(inv.Name);
        }
        return inventarioLista;
    }

    public boolean confirmProductExistByCode(String productCode){
        List<Product_Custom__c> productosLista = [SELECT Id, Name, ProductCode__c FROM Product_Custom__c];
        boolean productoEncontrado = false;
        if(productosLista.size() == 0){
            System.debug('No hay productos cargados');
            return productoEncontrado;
        }else{
            for(Product_Custom__c product : productosLista){
                if(product.ProductCode__c == productCode){
                    productoEncontrado = true;
                    System.debug('Producto Encontrado: ' + product.Name + ' Código: ' + product.ProductCode__c);
                    Break;
                }
            }
        }
        System.debug(productoEncontrado);
        return productoEncontrado;
    }

    public double searchProductByCode(String productCode){
    
        List<Inventario_Custom__c> productoInventario = [SELECT Id, Name, ProductCode__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c WHERE ProductCode__c = :productCode];
        double cantidadDisponible = 0;
        
        if(productoInventario.size() >= 0){
            cantidadDisponible = productoInventario[0].Cantidad_dis__c -  productoInventario[0].Cantidad_apart__c;
            System.debug('La cantidad disponible del producto ' + productoInventario[0].Name + ' es: ' + cantidadDisponible);
            return cantidadDisponible;
        }else{
            System.debug('Producto no encontrado o cantidad disponible: ' + cantidadDisponible);
            return cantidadDisponible;
        }

    }

}