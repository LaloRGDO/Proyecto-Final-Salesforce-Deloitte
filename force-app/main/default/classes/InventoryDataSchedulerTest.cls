@isTest
public class InventoryDataSchedulerTest {
    
    @isTest
    public static void TestExternalLegacyConnection(){
        Test.setMock(HttpCalloutMock.class, new MockForExternalLegacyConnection());
        
        List<Product2> prodMockList = new List<Product2>{
            new Product2(Name = 'CL1010_Inv',
                         ExternalID = 'CL1010',
                         ProductCode = 'CL1010',
                         PCExternalId__c = 'CL1010'),
            new Product2(Name = 'MC1020_Inv',
                         ExternalID = 'MC1020',
                         ProductCode = 'MC1020',
                         PCExternalId__c = 'MC1020'),
            new Product2(Name = 'DLL1030_Inv',
                         ExternalID = 'DLL1030',
                         ProductCode = 'DLL1030',
                         PCExternalId__c = 'DLL1030')
        };
            
        insert prodMockList;
         
        Test.startTest();
        InventoryDataScheduler.ExternalLegacyConnection();
        Test.stopTest();
        
        
         List<Inventario_Custom__c> invMockList = new List<Inventario_Custom__c>{
            new Inventario_Custom__c(Name = 'CL1010_Inv',
                         Product__c = prodMockList[0].Id,
                         Cantidad_dis__c = 6710,
                         Cantidad_apart__c = 75,
                         InvExtId__c='Inventario 1'),
            new Inventario_Custom__c(Name = 'MC1020_Inv',
                         Product__c = prodMockList[1].Id,
                         Cantidad_dis__c = 5481,
                         Cantidad_apart__c = 59,
                         InvExtId__c='Inventario 2'),
            new Inventario_Custom__c(Name = 'DLL1030_Inv',
                         Product__c = prodMockList[2].Id,
                         Cantidad_dis__c = 3111,
                         Cantidad_apart__c = 91,
                         InvExtId__c='Inventario 3')
         };
             
         List<Inventario_Custom__c> invList = [SELECT Name, Id FROM Inventario_Custom__c
                                              WHERE Name = 'CL1010_Inv' OR Name = 'MC1020_Inv' OR Name = 'DLL1030_Inv'];
        System.assertEquals(invMockList.size(), invList.size());
    }
    
    @isTest public static void testExecute(){
        Test.setMock(HttpCalloutMock.class, new MockForExternalLegacyConnection());
        SchedulableContext ctx = null;
        InventoryDataScheduler ids = new InventoryDataScheduler();
        ids.execute(ctx);
    }
    
}