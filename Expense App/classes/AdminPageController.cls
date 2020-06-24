/**
 * Created by Lenovo on 13.04.2020.
 */

public with sharing class AdminPageController {

    @AuraEnabled
    public static List<String> getRegionalExpenses(){

        Date now = Date.today();
        Integer year = now.year();
        List<String> regionalExpenses = new List<String>();
        for(Integer i = 0; i < 4; i++)
            regionalExpenses.add('Regional Expenses ' + (year - i));

        return regionalExpenses;
    }

    @AuraEnabled
    public static List<String> getAllOffices(){

        List<String> offices = new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.Office__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry pickListVal : ple) {
            offices.add(pickListVal.getLabel());
        }
        return offices;
    }

    @AuraEnabled
    public static List<String> getBalance(Integer year){

        List<String> offices = getAllOffices();
        List<String> balances = new List<String>();
        List<AggregateResult> monthlyExpenses = [Select SUM(SpentAmount__c)sumA, SUM(Balance__c)sumB, Keeper__r.Office__c FROM Monthly_Expense__c Where CALENDAR_YEAR(MonthDate__c) = :year GROUP BY Keeper__r.Office__c ORDER BY Keeper__r.Office__c];

        for(String office : offices) {
            Boolean isOffice = false;
            for(AggregateResult agr : monthlyExpenses) {
                if(office == agr.get('Office__c')) {
                    if (agr.get('sumB') == null && agr.get('sumA') == null)
                        balances.add('0');
                    else {
                        if (agr.get('sumB') == null)
                            balances.add('-' + String.valueOf(Double.valueOf(agr.get('sumA'))));
                        else if (agr.get('sumA') == null)
                            balances.add(String.valueOf(Double.valueOf(agr.get('sumB'))));
                        else {
                            Decimal result = Double.valueOf(agr.get('sumB')) - Double.valueOf(agr.get('sumA'));
                            balances.add(String.valueOf(result.setScale(1)));
                        }
                    }

                    isOffice = true;

                }
            }
            if(!isOffice)
                balances.add('0');
        }
        return balances;
    }

    @AuraEnabled
    public static List<String> getAverage(Integer year){

        List<String> average = new List<String>();
        List<String> offices = getAllOffices();
        List<AggregateResult> monthlyExpenses = [Select AVG(SpentAmount__c)avg, Keeper__r.Office__c FROM Monthly_Expense__c Where SpentAmount__c != 0 And CALENDAR_YEAR(MonthDate__c) = :year GROUP BY Keeper__r.Office__c ORDER BY Keeper__r.Office__c];
        for(String office : offices) {
            Boolean isOffice = false;
            for(AggregateResult agr : monthlyExpenses) {
                if(office == agr.get('Office__c')) {
                    Decimal result = Double.valueOf(agr.get('avg'));
                    average.add(String.valueOf(result.setScale(2)));
                    isOffice = true;
                }
            }
            if(!isOffice)
                average.add('0');
        }

        return average;
    }

    @AuraEnabled
    public static List<String> getMonths() {
        return MonthsController.getAllMonths();
    }

    @AuraEnabled
    public static List<List<String>> getAllData(Integer year) {

        List<String> offices = AdminPageController.getAllOffices();
        List<AggregateResult> monthlyExpenses = [Select SUM(SpentAmount__c)sum, Keeper__r.Office__c, CALENDAR_MONTH(MonthDate__c)mon  From Monthly_Expense__c Where CALENDAR_YEAR(MonthDate__c) = :year GROUP BY CALENDAR_MONTH(MonthDate__c), Keeper__r.Office__c];
        List<List<String>> allData = new List<List<String>>();

        for(Integer i = 0; i < 12; i++) {
            List<String> forOneMonth = new List<String>();
            for (String office : offices) {
                Boolean isOffice = false;
                for (AggregateResult agr : monthlyExpenses) {
                    if (office == agr.get('Office__c') && i == (Integer)agr.get('mon') - 1) {
                        Decimal result = Double.valueOf(agr.get('sum'));
                        if(result == 0)
                            forOneMonth.add('0');
                        else
                            forOneMonth.add(String.valueOf(result.setScale(2)));
                        
                        isOffice = true;
                    }
                }
                if(!isOffice)
                    forOneMonth.add('0');
            }
            allData.add(forOneMonth);
        }
        for(List<String> er : allData)
            System.debug(er);
        return allData;
    }

    @AuraEnabled
    public static List<String> getSumOffices(Integer year) {

        List<String> result = new List<String>();
        List<List<String>> allData = getAllData(year);
        List<String> oneMonth = new List<String>();
        Decimal sum = 0;
        for(Integer i = 0; i < 12; i++){
            sum = 0;
            oneMonth = allData[i];
            for(String one : oneMonth)
                sum += Double.valueOf(one);

            if(sum == 0)
                result.add('0');
            else
                result.add(String.valueOf(sum.setScale(2)));
        }
        return result;
    }

    @AuraEnabled
    public static List<String> getTotalSum(Integer year){

        List<List<String>> monthlyData = getAllData(year);
        Integer length = monthlyData[0].size();
        List<String> totalSum = new List<String>();

        for(Integer j = 0; j < length; j++) {
            Decimal sum = 0;
            for (Integer i = 0; i < 12; i++)
                sum += Double.valueOf(monthlyData[i][j]);
            if(sum == 0)
                totalSum.add('0');
            else
                totalSum.add(String.valueOf(sum.setScale(1)));
        }
        return totalSum;
    }

    @AuraEnabled
    public static String getTotal(Integer year){

        List<String> sumData = getSumOffices(year);
        Decimal sum = 0;
        for (Integer i = 0; i < 12; i++)
            sum += Double.valueOf(sumData[i]);

        return String.valueOf(sum.setScale(1));
    }

    @AuraEnabled
    public static Id goToOffice(String office) {

        Contact contact = [Select Id FROM Contact Where Office__c = :office LIMIT 1];
        return contact.Id;
    }
}