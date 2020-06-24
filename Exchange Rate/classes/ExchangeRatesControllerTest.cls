/**
 * Created by alena on 04.03.2020.
 */

@isTest
private class ExchangeRatesControllerTest {

    @testSetup
    static void setup() {
        List <Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();
        List<String> fields = ExchangeRatesController.fillSelect();
        Date datfrom = Date.newInstance(2019, 11,10);
        Date datto = Date.newInstance(2019, 11,15);
        for (Date d = datfrom; d <= datto; d = d.addDays(1)) {
            Exchange_Rate__c newExchangeRate = new Exchange_Rate__c(BaseCurrency__c = 'CAD', Date__c = d);
            for (String field : fields)
                newExchangeRate.put(field + '__c', 1);
            exchangeRates.add(newExchangeRate);
        }

        insert exchangeRates;

    }

    @IsTest
    static void testGetCallout () {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExchangeHttpMock());
        ExchangeRatesController.makeResponse(Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day()));
        Test.stopTest();
        System.assertEquals(1, [select count() from Exchange_Rate__c where Date__c = :Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day())]);
    }
    
    @isTest
    static void getRecordsTest(){

        List<Exchange_Rate__c> result = ExchangeRatesController.getExchangeRates();
        List<Exchange_Rate__c> expected = [SELECT Id From Exchange_Rate__c];
        System.assertEquals(expected.size(), result.size());
    }

    @isTest
    static void getPeriodTest(){
        Date datfrom = Date.newInstance(2019, 10,10);
        Date datto = Date.newInstance(2019, 10,15);
        List<Date> dates = new List<Date>();
        for (Date d = datfrom; d <= datto; d = d.addDays(1))
            dates.add(d);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExchangeHttpMock());
        ExchangeRatesController.getExchangeRatesPeriod(datfrom, datto);
        Test.stopTest();

        System.assertEquals(6, [select count() from Exchange_Rate__c where Date__c in :dates]);

    }

    @isTest
    static void getPeriodTest2(){
        Date datfrom1 = Date.newInstance(2019, 4,10);
        Date datto1 = Date.newInstance(2019, 10,15);
        List<Date> dates = new List<Date>();
        for (Date d = datfrom1; d <= datto1; d = d.addDays(1))
            dates.add(d);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExchangeHttpMock());
        ExchangeRatesController.getExchangeRatesPeriod(datfrom1, datto1);
        Test.stopTest();

        System.assertEquals(100, [select count() from Exchange_Rate__c where Date__c in :dates]);
    }

    @isTest
    static void getValueTest() {
        String base = 'EUR';
        String field = 'CAD';
        Exchange_Rate__c oneRate = [SELECT EUR__c, CAD__c From Exchange_Rate__c LIMIT 1];
        Double result = ExchangeRatesController.getValueForField(oneRate, field, base);
        System.assertEquals(1, result);
    }

    @isTest
    static void showTest() {
        Date datfrom = Date.newInstance(2019, 11,10);
        Date datto = Date.newInstance(2019, 11,15);

        List<Exchange_Rate__c> result = ExchangeRatesController.showPeriod(datfrom, datto);
        System.assertEquals(6, result.size());

    }

    @isTest
    static void updateTest() {
        String base = 'EUR';
        ExchangeRatesController.updateDataByBaseCurrency(base);
    }
}