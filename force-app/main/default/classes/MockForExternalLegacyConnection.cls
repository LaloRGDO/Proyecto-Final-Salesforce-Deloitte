@isTest
global class MockForExternalLegacyConnection implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request){
        HTTPResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"statusCode":200,"body":{"Inventory":[{"name":"CL1010_Inv","ProductID":"CL1010","Quan":7336,"BlockedQuan":43},{"name":"MC1020_Inv","ProductID":"MC1020","Quan":8505,"BlockedQuan":43},{"name":"DLL1030_Inv","ProductID":"DLL1030","Quan":6579,"BlockedQuan":27}]}}');
        response.setStatusCode(200);
        
        /*response.setBody('{"body":{'
                         + '"Inventory":['
                         + '{"name":"CL1010_Inv","ProductID":"CL1010","Quan":6710,"BlockedQuan":75},'
                         + '{"name":"MC1020_Inv","ProductID":"CL1010","Quan":5481,"BlockedQuan":59},'
                         + '{"name":"DLL1030_Inv","ProductID":"CL1010","Quan":3111,"BlockedQuan":91},'
                         + ']}}');*/
        
        return response;
    }
}