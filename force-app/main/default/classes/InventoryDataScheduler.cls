global with sharing class InventoryDataScheduler implements Schedulable{
    
    global void execute(SchedulableContext ctx){
        ExternalLegacyConnection();
    }
    
    
    @future(callout=true)
    public static void ExternalLegacyConnection(){
        
        String url = 'https://64bjp0q5wg.execute-api.us-east-2.amazonaws.com/Implement/';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        String response = '';
        
        try{
            Http http = new Http();
            HttpResponse httpResponse = http.send(request);
            
            if(httpResponse.getStatusCode()==200){
                response = JSON.serializePretty(JSON.deserializeUntyped(httpResponse.getBody()));
            }else{
                System.debug(' httpResponse ' + httpResponse.getBody());
                throw new CalloutException(httpResponse.getBody());
            }
        }catch(System.Exception e){
            System.debug('ERROR: ' + e);
            throw e;
        }
        
        System.debug('** response ** : ' + response);
        
        //Parser
        
        if(response != ''){
            JSONParser parser = JSON.createParser(response);
            Double cantReservada = 0;
            Double cantidadDisp = 0;
            String name = '';
            String productId = '';
            Integer iteracion = 0;
            Product2 producto = new Product2();
            Inventario_Custom__c inventario = new Inventario_Custom__c();
            List<Product2> productos = new List<Product2>();
            List<Inventario_Custom__c> inventarios = new List<Inventario_Custom__c>();
            
            while(parser.nextToken() != null){
                System.debug('TIPO '+parser.getCurrentToken());
                System.debug('VALOR '+parser.getText());
                
                if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText() == 'BlockedQuan')){
                    parser.nextToken();
                    cantReservada = parser.getDoubleValue();
                    inventario.Cantidad_apart__c = cantReservada;
                }
                
                if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText() == 'Quan')){
                    parser.nextToken();
                    cantidadDisp = parser.getDoubleValue();
                    inventario.Cantidad_dis__c = cantidadDisp;
                }

                /*if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText() == 'BlockedQuan')){
                    parser.nextToken();
                    cantReservada += parser.getDoubleValue();
                    cantReservadaInt += parser.getDoubleValue();
                }*/
            }
            //System.debug('Total Apartado: '+cantReservada);
        }
    }  
}




/*String url = 'https://64bjp0q5wg.execute-api.us-east-2.amazonaws.com/Implement/';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        //If Request is Successful, parse the JSON response.
        JSONParser parser = JSON.createParser(response.getBody());
        Map<String, Object> resultados = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug(resultados.get('statusCode'));
        System.debug(resultados.get('body'));
        if(resultados.get('body') instanceOf Map<String, Object>){
            system.debug('Mapa');
        }else if(resultados.get('body') instanceOf List<Object>){
            System.debug('Lista de objetos');
        }*/