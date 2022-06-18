public class QuotationHelper implements QuotationSync {
    
    public void initialConfig(){
        Account acct1 = new Account(Name = 'Compumundo', Website='www.compumundo.com');
        Account acct2 = new Account(Name = 'Compuworld', Website='www.compuworl.com');
        
        List<Account> accountList = new List<Account>();
        accountList.add(acct1);
        accountList.add(acct2);
        
        insert accountList;
    }
    
    public List<Inventario_Custom__c> productsInInventory(){
        List<Inventario_Custom__c> inventarioLista = [SELECT Id, Name, Product_Code__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c LIMIT 200];
        return inventarioLista;
    }

    @InvocableMethod(label='StockAlert')
    public static void StockEmptyAlert(){

        List<Inventario_Custom__c> invList = new List<Inventario_Custom__c>();
        QuotationHelper qh = new QuotationHelper();

        invList = qh.productsInInventory();

        List<FeedItem> feed = new List<FeedItem>();

        for(Inventario_Custom__c inv : invList){
            if(inv.Cantidad_dis__c==0){
                FeedItem post = new FeedItem();
                post.ParentId = UserInfo.getUserId();
                post.Body = 'Producto ' + inv.Name + ' sin Inventario';
                feed.add(post);
            }
        }
        insert feed;
    }

    public static boolean confirmProductExistByCode(String productCode){
        List<Product2> productosLista = [SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode = :productCode];
        boolean productoEncontrado = false;
        if(productosLista.size()>0){
            productoEncontrado = true;
            return productoEncontrado;
        }else{
            return productoEncontrado;
        }
    }

    public static double searchProductByCode(String productCode){
        //Buscar el inventario mediante el parámetro pasado y declarar variable cantidadDisponible (double)
        List<Inventario_Custom__c> productoInventario = [SELECT Id, Name, Product_Code__c, Cantidad_dis__c, Cantidad_apart__c
                                                         FROM Inventario_Custom__c WHERE Product_Code__c = :productCode];
        double cantidadDisponible = 0;
        
        //Caso se encuentre el inventario
        if(productoInventario.size() > 0){
            //Caso se encuentre el inventario y los campos no estén vacíos
            cantidadDisponible = productoInventario[0].Cantidad_dis__c;
            System.debug('Hay '+cantidadDisponible+' Piezas disponibles');
            return cantidadDisponible;
        }else{
            //Caso no se encuentre el inventario con el parámetro, retorna 0
            System.debug('Producto no encontrado');
            return cantidadDisponible;
        }
    }

    public static void ActualizarCantidadApartadaHelper(List<QuoteLineItem> qliList, Integer num){
        if(num==1){
            //Traer registros de inventario y variable de lista para guardar registros a actualizar
            List<Inventario_Custom__c> invList = [SELECT Product__c, Cantidad_apart__c, Cantidad_dis__c FROM Inventario_Custom__c];
            List<Inventario_Custom__c> invActList = new List <Inventario_Custom__c>();
            //loop para lista de qli
            for(QuoteLineItem qli : qliList){
                //Verificar si el producto existe en Inventario
                boolean productoEncontrado = confirmProductExistByCode(qli.Product_Code__c);
                if(productoEncontrado){
                    //loop para lista de inventarios en caso de que el producto si exista
                    for(Inventario_Custom__c inv : invList){
                        //verificar que el producto de qli sea el mismo que el de inventario
                        if(qli.Product2Id == inv.Product__c){
                            inv.Cantidad_apart__c += qli.Quantity;
                            inv.Cantidad_dis__c -= qli.Quantity;
                            invActList.add(inv);
                        }
                    }
                }
            }
            if(invActList.size()>0){
                update invActList;
            }
        }else if(num==2){
            //Traer lista de inventario donde el producto
            List<Inventario_Custom__c> invList = [SELECT Product__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c];
            //Loop para iterar por los qli
            for(QuoteLineItem qli:qliList){
                //Loop para iterar por cada registro de inventario
                for(Inventario_Custom__c inv:invList){
                    //Comparar si el producto es el mismo
                    if(qli.Product2Id == inv.Product__c){
                        //verificar que cantidad sea mayor a la cantidad disponible en inventario para lanzar error
                        if(qli.Quantity > inv.Cantidad_dis__c){
                            qli.addError('El campo Cantidad no debe de ser mayor a la cantidad disponible en inventario : '+ inv.Cantidad_dis__c +' unidades disponibles');
                        }
                    }
                }                
            }
        } 
    }  
}