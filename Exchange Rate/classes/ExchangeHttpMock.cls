/**
 * Created by alena on 04.03.2020.
 */
@isTest
public with sharing class ExchangeHttpMock implements HttpCalloutMock{

    public HttpResponse respond(HttpRequest request){

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"base": "GBP","date": "2018-04-08","rates": {"CAD": 1.565,"GBP": 0.87295,"EUR": 1.092,"USD": 1.2234}}');
        response.setStatusCode(200);
        return response;
    }
}