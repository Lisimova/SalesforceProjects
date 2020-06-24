/**
 * Created by alena on 03.03.2020.
 */

public with sharing class BatchClass implements  Database.Batchable<sObject>, Database.Stateful{

    String baseCurrency;

    public BatchClass(String baseCur) {
        baseCurrency = baseCur;
    }

    public Iterable<SObject> start(Database.BatchableContext bc) {
        return ExchangeRatesController.getExchangeRates();
    }

    public void execute(Database.BatchableContext bc, List<Object> scope) {

        System.debug(baseCurrency);
        List<Exchange_Rate__c> exList = (List<Exchange_Rate__c>)scope;
        List<String> allCurrencies = ExchangeRatesController.fillSelect();
        for (Exchange_Rate__c ex : exList) {
            for (String field : allCurrencies) {
                if(ex.get(field + '__c') == null || ex.get(baseCurrency + '__c') == null)
                    ex.put(field + '__c', 0);
                else {
                	Decimal val = (Decimal)ex.get(field + '__c') / (Decimal)ex.get(baseCurrency + '__c');
                	ex.put(field + '__c', val.setScale(4));
                }
            }
            ex.BaseCurrency__c = baseCurrency;

            update ex;
        }

    }

    public void finish(Database.BatchableContext bc) {
    }
}