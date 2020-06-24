/**
 * Created by alena on 04.03.2020.
 */
@isTest
public with sharing class BatchClassTest {

    @testSetup
    static void setup() {
        List <Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();
        List<String> fields = ExchangeRatesController.fillSelect();
        for (Integer i = 0; i < 10; i++) {
            Exchange_Rate__c newExchangeRate = new Exchange_Rate__c(BaseCurrency__c = 'CAD');
            for (String field : fields)
                newExchangeRate.put(field + '__c', 1);
            exchangeRates.add(newExchangeRate);
        }
        insert exchangeRates;
    }

    static testMethod void test(){
        Test.startTest();
        BatchClass bc = new BatchClass('GBP');
        Id bcId = Database.executeBatch(bc);
        TEst.stopTest();

        System.assertEquals(10, [select count() from Exchange_Rate__c where BaseCurrency__c = 'GBP']);
    }
}