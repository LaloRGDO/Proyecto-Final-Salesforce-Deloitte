global with sharing class InventoryDataScheduler implements Schedulable{
    
    global void execute(SchedulableContext ctx){
        ExternalLegacyConnection();
    }
    
    
    @future(callout=true)
    public static void ExternalLegacyConnection(){
        String url = 'https://64bjp0q5wg.execute-api.us-east-2.amazonaws.com/Implement/';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>)((Map<String, Object>) JSON.deserializeUntyped(response.getBody())).get('body');
            System.debug(results);
            List<Object> inventory = (List<Object>) results.get('Inventory');
            System.debug(inventory);
            List<Inventario_Custom__c>listaInventario = new List<Inventario_Custom__c>();
            List<Product2> listaProductos = new List<Product2>();
            Integer n = 0;
            
            for(Object inv: inventory){
                Map<String, Object> campos = (Map<String, Object>)inv;
                
                listaProductos.add(new Product2(Name = (String)campos.get('name'),
                                               ExternalID = (String)campos.get('ProductID'),
                                               ProductCode = (String)campos.get('ProductID'),
                                               PCExternalId__c = (String)campos.get('ProductID')));
            }
            upsert listaProductos PCExternalId__c;
            for(Object inv: inventory){
                Map<String, Object> campos = (Map<String, Object>)inv;
                
                listaInventario.add(new Inventario_Custom__c(Name = (String)campos.get('name'),
                                                                Product__c = listaProductos[n].Id,
                                                                Cantidad_dis__c = (Integer)campos.get('Quan'),
                                                                Cantidad_apart__c = (Integer)campos.get('BlockedQuan'),
                                                            	InvExtId__c='Inventario '+ n));
                n+=1;
                
            }
            upsert listaInventario InvExtId__c;
        }
    }  
}