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
        List<Inventario_Custom__c> inventarioLista = [SELECT Id, Name, Product_Code__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c LIMIT 200];
        for(Inventario_Custom__c inv : inventarioLista){
            System.debug(inv.Name);
        }
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
        List<Product2> productosLista = [SELECT Id, Name, ProductCode FROM Product2];
        boolean productoEncontrado = false;
        if(productosLista.size() == 0){
            System.debug('No hay productos cargados');
            return productoEncontrado;//retorna falso si no hay ningún producto
        }else{
            for(Product2 product : productosLista){
                if(product.ProductCode == productCode){
                    productoEncontrado = true;//Si encuentra un producto con el mismo productCode que el parámetro productoEncontrado se cambia a true
                    System.debug('Producto Encontrado: ' + product.Name + ' Código: ' + product.ProductCode);
                    Break;//Sale del bucle una vez encontrado
                }
            }
        }
        System.debug(productoEncontrado);
        //retorna falso o verdadero según el valor de la variable productoEncontrado
        return productoEncontrado;
    }

    public static double searchProductByCode(String productCode){
        //Buscar el inventario mediante el parámetro pasado y declarar variable cantidadDisponible (double)
        List<Inventario_Custom__c> productoInventario = [SELECT Id, Name, Product_Code__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c WHERE Product_Code__c = :productCode];
        double cantidadDisponible = 0;
        
        //Caso se encuentre el inventario
        if(productoInventario.size() >= 1){
            //Caso se encuentre el inventario pero cantidad disponible y cantidad apartada estén vacíos (null) retorna 0
            if(productoInventario[0].Cantidad_dis__c == null || productoInventario[0].Cantidad_apart__c == null){
                System.debug('Cantidades disponibles del producto '+productoInventario[0].Name+' no especificadas, cantidad disponible previa: ' + cantidadDisponible);
                return cantidadDisponible;
            }else{
                //Caso se encuentre el inventario y los campos no estén vacíos
                cantidadDisponible = productoInventario[0].Cantidad_dis__c;
                System.debug('La cantidad disponible del producto ' + productoInventario[0].Name + ' es: ' + cantidadDisponible);
                return cantidadDisponible;
            }
        }else{
            //Caso no se encuentre el inventario con el parámetro, retorna 0
            System.debug('Producto no encontrado, retorna cantidad disponible: '+cantidadDisponible);
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
                        if(qli.Quantity > (inv.Cantidad_dis__c)){
                            qli.addError('El campo Cantidad no debe de ser mayor a la cantidad disponible en inventario : '+ inv.Cantidad_dis__c +' unidades disponibles');
                        }
                    }
                }                
            }
        } 
    }  
}