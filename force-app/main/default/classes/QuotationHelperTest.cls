@isTest
public class QuotationHelperTest {
    
    @isTest
    public static void TestInitialConfig(){
        QuotationHelper cuenta = new QuotationHelper();
        cuenta.initialConfig();
    }
    
    @isTest
    public static void TestProductsInInventory(){
        List<Inventario_Custom__c> inventario = [SELECT Id, Name, Product_Code__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario_Custom__c LIMIT 200];
        Test.startTest();
        QuotationHelper inv = new QuotationHelper();
        List<Inventario_Custom__c> inventarioPrueba = inv.productsInInventory();
        Test.stopTest();
        System.assertEquals(inventario, inventarioPrueba);
    }
    
    @isTest
    public static void TestStockEmptyAlert(){
        Inventario_Custom__c inventario1 = new Inventario_Custom__c(Name='InventarioTest1', Cantidad_dis__c=0, Cantidad_apart__c = 0, Product__c='01t5c00000DS6XGAA1');
        Inventario_Custom__c inventario2 = new Inventario_Custom__c(Name='InventarioTest2', Cantidad_dis__c=1, Cantidad_apart__c = 0, Product__c='01t5c00000DS6WzAAL');
        List<Inventario_Custom__c> inventario = new List<Inventario_Custom__c>();
        inventario.add(inventario1);
        inventario.add(inventario2);
        insert inventario;
        
        Test.startTest();
        QuotationHelper.StockEmptyAlert();
        Test.stopTest();
    }
    
    @isTest
    public static void TestconfirmProductExistByCode(){
        Product2 nuevoProducto = new Product2(Name = 'TestProduct', ProductCode = 'TESTPRODUCT');
        insert nuevoProducto;
        
        Test.startTest();
        boolean verdadero = QuotationHelper.confirmProductExistByCode('TESTPRODUCT');
        boolean falso = QuotationHelper.confirmProductExistByCode('opjwoef');
        Test.stopTest();
        
        System.assertEquals(true, verdadero);
        System.assertEquals(false, falso);
    }
    
    @isTest
    public static void TestSearchProductByCode(){
        Product2 producto = new Product2(Name = 'TestProduct', ProductCode = 'TESTPRODUCT2');
        insert producto;
        Inventario_Custom__c inv = new Inventario_Custom__c(Name = 'TestInv1', Cantidad_dis__c=10, Cantidad_apart__c = 0, Product__c=producto.Id);
        insert inv;
        
        Test.startTest();
        double cantidad1 = QuotationHelper.searchProductByCode('TESTPRODUCT2');
        double cantidad2 = QuotationHelper.searchProductByCode('90');
        Test.stopTest();
        
        System.assertEquals(10, cantidad1);
        System.assertEquals(0, cantidad2);
    }
    
    @isTest
    public static void TestActualizarCantidadApartadaHelper(){
        
        Pricebook2 standardPB = new Pricebook2(Name = 'pbTest');
        insert standardPB;
        
        /*Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];*/
        
        Opportunity op = new Opportunity(Name='OportunidadTest', CloseDate=date.newinstance(2022, 2, 17) , StageName='Qualification', Pricebook2Id=standardPB.Id);
        insert op;
        
        Quote qt = new Quote(Name='TESTQuote', OpportunityId=op.Id, Pricebook2Id = Test.getStandardPricebookId());
        insert qt;
        
        List<Product2> productos = new List<Product2>();
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        List<Inventario_Custom__c> inventarios = new List<Inventario_Custom__c>();
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        
        for(integer i=1; i<=3; i++){
            Product2 producto = new Product2(Name='TestProduct'+i, ProductCode='TESTPRODUCT'+i,	IsActive=true);
            productos.add(producto);
        }
        
        insert productos;
        
        for(integer i=0; i<productos.size();i++){
            PricebookEntry pbe = new PricebookEntry(Product2Id = productos[i].Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 300, IsActive = true);
            pbes.add(pbe);
            
            Inventario_Custom__c inv = new Inventario_Custom__c(Name = 'TestInv'+i, Cantidad_dis__c=10, Cantidad_apart__c = 0, Product__c=productos[i].Id);
            inventarios.add(inv);
        }
        
        insert pbes;
        insert inventarios;
        
        for(integer i=0; i<productos.size();i++){
            QuoteLineItem qli = new QuoteLineItem(QuoteId=qt.Id, Quantity=10, Product2Id=productos[i].Id, PricebookEntryId = pbes[i].Id, UnitPrice=300);
            qlis.add(qli);
        }
        
        insert qlis;
        
        Test.startTest();
        QuotationHelper.ActualizarCantidadApartadaHelper(qlis, 1);
        QuotationHelper.ActualizarCantidadApartadaHelper(qlis, 2);
        Test.stopTest();
    }
    
    
}