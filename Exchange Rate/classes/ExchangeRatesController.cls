public with sharing class ExchangeRatesController {

    public with sharing class Wrapper {

        public Log__c log {get; set;}
        public  Exchange_Rate__c exchangeRate {get; set;}

    }

    @AuraEnabled
    @future(callout=true)
    public static void makeResponse(Date dat) {

        List<String> currencies = fillSelect();
        String symbols = String.join(currencies, ',');
        symbols = symbols.remove(',SCD');
        String currenciessString = String.join(currencies, '__c, ');
        currenciessString += '__c';
        System.debug(symbols);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.exchangeratesapi.io/' + String.valueOf(dat) + '?base=GBP&symbols=' + symbols);
        HttpResponse response = http.send(request);


        Log__c newlog = new Log__c(Response_Body__c = response.getBody(), Status_Code__c = String.valueOf(response.getStatusCode()));
        insert newlog;
        System.debug(newlog);

        Exchange_Rate__c newExchangeRate = new Exchange_Rate__c();
        newExchangeRate.Log__c = newlog.Id;
        newExchangeRate.Date__c = dat;

        if(response.getStatusCode() == 200) {

            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> rates = (Map<String, Object>) result.get('rates');

            for (String rate : rates.keySet()){
                newExchangeRate.put(rate + '__c', rates.get(rate));

            }
            insert newExchangeRate;

            List<Log__c> logList = [SELECT Id, Response_Body__c, Status_Code__c FROM Log__c WHERE Status_Code__c != '200'];
            System.debug('Select Date__c, ' + currencies + '__c' +
                    ' From Exchange_Rate__c Where Log__c In' + logList);

            if (logList.size() > 0) {
                List<Exchange_Rate__c> exchangeRates = Database.query('Select Date__c, ' + currenciessString +
                        ' From Exchange_Rate__c Where Log__r.Id IN :logList');
                getForErrorDay(exchangeRates);
            }
        }

    }

    @AuraEnabled
    public static void getForErrorDay (List <Exchange_Rate__c> exchangeRates) {

        List<String> currencies = fillSelect();
        String symbols = String.join(currencies, ',');
        symbols = symbols.remove(',SCD');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        for (Exchange_Rate__c ex : exchangeRates) {
            request.setEndpoint('https://api.exchangeratesapi.io/' + ex.Date__c + '?base=GBP&symbols=' + symbols);
            HttpResponse response = http.send(request);

            Log__c newlog = [SELECT Status_Code__c, Response_Body__c From Log__c Where Id = :ex.Log__c];

            newlog.Response_Body__c = response.getBody();
            newlog.Status_Code__c = String.valueOf(response.getStatusCode());


            if (response.getStatusCode() == 200) {

                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> rates = (Map<String, Object>) result.get('rates');

                for (String rate : rates.keySet()) {
                    ex.put(rate + '__c', rates.get(rate));
                }
            }
            update ex;
        }

    }

    @AuraEnabled
    public static List<String> fillSelect() {

        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Exchange_Rate__c.BaseCurrency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    @AuraEnabled
    public static List<Exchange_Rate__c> getExchangeRates() {

        List<String> currencies = fillSelect(); 
        String currenciessString = String.join(currencies, '__c, ');
        currenciessString += '__c';
        System.debug(currencies);
        return Database.query('Select Date__c, ' + currenciessString + ' From Exchange_Rate__c Order By Date__c DESC');
    }

    @AuraEnabled
    public static void getExchangeRatesPeriod(Date dateFrom, Date dateTo) {
        Wrapper wrapper;
        List<Exchange_Rate__c> exList = getExchangeRates();
        List<Date> exDates = new List<Date>();
        List<Date> dates = new List<Date>();
        List<Exchange_Rate__c> nRates = new List<Exchange_Rate__c>();
        List<Log__c> nLogs = new List<Log__c>();
        for (Exchange_Rate__c exchangeRate : exList)
            exDates.add(exchangeRate.Date__c);

        for(Date d = dateFrom; d <= dateTo; d = d.addDays(1)) {
            if (!exDates.contains(d))
                dates.add(d);

            if (dates.size() == 100)
                break;
        }
        for (Date d : dates) {

            wrapper = getForOneDay(d);
            Exchange_Rate__c newEx = wrapper.exchangeRate;
            Log__c newLog = wrapper.log;
            newEx.Log__c = newLog.Id;
            nLogs.add(newLog);
            nRates.add(newEx);

        }
        insert nLogs;
        for (Integer i = 0; i < nRates.size(); i++) {
            nRates[i].Log__c = nLogs[i].Id;
        }
        insert nRates;
    }

    @AuraEnabled
    public static Decimal getValueForField(Exchange_Rate__c exchangeRate, String field, String baseCurrency) {

        Decimal obj = (Decimal)exchangeRate.get(field + '__c') / (Double)exchangeRate.get(baseCurrency + '__c');
        return obj.setScale(4);
    }

    @AuraEnabled
    public static List<Exchange_Rate__c> showPeriod(Date dateFrom, Date dateTo) {

        Exchange_Rate__c searchEx;
        List<Exchange_Rate__c> exList = new List<Exchange_Rate__c>();
        List<Exchange_Rate__c> exLst = getExchangeRates();
        for (Date d = dateFrom; d < dateTo.addDays(1); d = d.addDays(1)) {

            for (Exchange_Rate__c exr : exLst) {

                if (exr.Date__c == d) {
                    exList.add(exr);
                    searchEx = exr;
                }
            }
        }
        return exList;

    }

    public static Wrapper getForOneDay(Date dat) {

        List<String> currencies = fillSelect();
        String symbols = String.join(currencies, ',');
        symbols = symbols.remove(',SCD');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.exchangeratesapi.io/' + String.valueOf(dat) + '?base=GBP&symbols=' + symbols);
        HttpResponse response = http.send(request);


        Log__c newlog = new Log__c(Response_Body__c = response.getBody(), Status_Code__c = String.valueOf(response.getStatusCode()));


        Exchange_Rate__c newExchangeRate = new Exchange_Rate__c();
        newExchangeRate.Log__c = newlog.Id;

        if(response.getStatusCode() == 200) {

            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> rates = (Map<String, Object>) result.get('rates');
            newExchangeRate.Date__c = dat;
            for (String rate : rates.keySet()){
                newExchangeRate.put(rate + '__c', rates.get(rate));
            }

        }

        Wrapper wrapper = new Wrapper();
        wrapper.exchangeRate = newExchangeRate;
        wrapper.log = newlog;

        return wrapper;

    }

    @AuraEnabled
    public static void updateDataByBaseCurrency(String baseCurrency) {
        List<Exchange_Rate__c> exList = getExchangeRates();
        List<String> allCurrencies = fillSelect();
        for (Exchange_Rate__c ex : exList) {
            Decimal bCurrency = (Decimal)ex.get(baseCurrency + '__c');
            for (String field : allCurrencies) {
                if(ex.get(field + '__c') == null || ex.get(baseCurrency + '__c') == null)
                    ex.put(field + '__c', 0);
                else {
                	Decimal val = (Decimal)ex.get(field + '__c') / bCurrency;
                    System.debug((Decimal)ex.get(field + '__c') + '---' + bCurrency + '---'+ val);
                	ex.put(field + '__c', val.setScale(4));
                }
            }
            ex.BaseCurrency__c = baseCurrency;

            update ex;
        }
    }
}