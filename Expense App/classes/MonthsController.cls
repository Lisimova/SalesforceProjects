/**
 * Created by alena on 17.03.2020.
 */

public with sharing class MonthsController {

    @AuraEnabled
    public static Map<String,List<String>> getAllData(Integer year, Id contactId) {

        Map<String, List<String>> result = new Map<String, List<String>>();
        List<List<String>> amountBalance = joinAmountBalance(year, contactId);
        List<String> monthsList = getAllMonths();
        for (Integer i = 0; i < monthsList.size(); i++)
            result.put(monthsList[i], amountBalance[i]);

        return result;

    }

    @AuraEnabled
    public static List<String> getAllMonths() {

        List<String> monthList = new List<String>();
        for(Datetime dat = Datetime.newInstance(2020, 1, 1); dat.month() < 12; dat = dat.addMonths(1)) {
            String mon = dat.format('MMMMM');
            monthList.add(mon);
        }

        monthList.add('December');
        return monthList;
    }

    private static List<String> getAllAmounts(Integer year, Id contactId) {

        List<String> sumList = new List<String>() ;

        for(Integer i = 1; i <= 12; i++) {
            List<Monthly_Expense__c> monthly_expenses = [SELECT SpentAmount__c From Monthly_Expense__c Where CALENDAR_YEAR(MonthDate__c) = :year AND CALENDAR_MONTH(MonthDate__c) = :i And Keeper__c = :contactId];
            if(monthly_expenses.size() > 0)
                sumList.add(String.valueOf(monthly_expenses[0].SpentAmount__c));
            else
                sumList.add('');
        }

        return sumList;
    }

    private static List<String> getAllIncome(Integer year, Id contactId) {

        List<String> incomeList = new List<String>();

        for(Integer i = 1; i <= 12; i++) {

            List<Monthly_Expense__c> monthly_expenses = [SELECT Balance__c From Monthly_Expense__c Where CALENDAR_YEAR(MonthDate__c) = :year AND CALENDAR_MONTH(MonthDate__c) = :i And Keeper__c = :contactId];

            if(monthly_expenses.size() > 0)
                incomeList.add(String.valueOf(monthly_expenses[0].Balance__c));
            else
                incomeList.add('');
        }
        return incomeList;
    }
    private static List<List<String>> joinAmountBalance(Integer year, Id contactId) {

        List<List<String>> amountIncome = new List<List<String>>();
        List<String> amountList = getAllAmounts(year, contactId);
        List<String> incomeList = getAllIncome(year, contactId);

        for (Integer i = 0; i < amountList.size(); i++) {
            List <String> oneRecord = new List<String>();
            oneRecord.add(amountList[i]);
            oneRecord.add(incomeList[i]);
            amountIncome.add(oneRecord);
        }

        return amountIncome;
    }

    @AuraEnabled
    public static String getTotalAmount(Integer year, Id contactId) {

        List<String> sumList = getAllAmounts(year, contactId);

        Double sum = 0;
        for(String str : sumList) {
            if(str == '')
                continue;
            if(str == null)
                continue;
            sum += Double.valueOf(str);
        }

        return String.valueOf(sum);
    }

    @AuraEnabled
    public static String getTotalIncome(Integer year, Id contactId) {

        List<String> sumList = getAllIncome(year, contactId);

        Double sum = 0;
        for(String str : sumList) {
            if(str == '')
                continue;
            if(str == null)
                continue;
            sum += Double.valueOf(str);
        }
        return String.valueOf(sum);
    }
}