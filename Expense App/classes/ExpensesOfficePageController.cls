/**
 * Created by alena on 16.03.2020.
 */

public with sharing class ExpensesOfficePageController {

    @AuraEnabled
    public static String getOffice(Id contactId) {

        Contact contact = [SELECT Office__c from Contact Where Id = :contactId Limit 1];
        return contact.Office__c;
    }

    @AuraEnabled
    public static String getBalance (Id contactId) {

        List<AggregateResult> sumAmount = [Select SUM(SpentAmount__c)sumA, SUM(Balance__c)sumB FROM Monthly_Expense__c Where Keeper__c = :contactId];
        Decimal result = 0;

        if (sumAmount[0].get('sumB') == null && sumAmount[0].get('sumA') == null)
            result = 0;
        else {
            if (sumAmount[0].get('sumB') == null)
               result = -Double.valueOf(sumAmount[0].get('sumA'));
            else if (sumAmount[0].get('sumA') == null)
                result = Double.valueOf(sumAmount[0].get('sumB'));
            else
                result = Double.valueOf(sumAmount[0].get('sumB')) - Double.valueOf(sumAmount[0].get('sumA'));
        }
        return String.valueOf(result.setScale(1));
    }

    @AuraEnabled
    public static void saveNewExpense (Expense_Card__c newExpense, Id contactId) {

        if (newExpense.Amount__c == null)
            newExpense.Amount__c = 0;

        newExpense.CardKeeper__c = contactId;

        insert newExpense;
    }

    @AuraEnabled
    public static void topBalance (String month, String year, Id contactId, Integer amount) {

        List<String> months = MonthsController.getAllMonths();
        Integer index = months.indexOf(month);
        Integer monthNumber = index + 1;
        Integer yearNumber = Integer.valueOf(year);

        List<Monthly_Expense__c> monthlyExpense = [SELECT Id, Reminder__c, Balance__c From Monthly_Expense__c
                                            Where CALENDAR_MONTH(MonthDate__c) = :monthNumber AND CALENDAR_YEAR(MonthDate__c) = :yearNumber AND Keeper__c = :contactId];
        if (monthlyExpense.size() > 0){
            System.debug(monthlyExpense[0]);
            if(monthlyExpense[0].Balance__c == null)
                monthlyExpense[0].Balance__c = amount;
            else
                monthlyExpense[0].Balance__c += amount;
            update  monthlyExpense[0];
        }
        else {
            Monthly_Expense__c monthlyExp = new Monthly_Expense__c();
            monthlyExp.Balance__c = amount;
            monthlyExp.Keeper__c = contactId;
            monthlyExp.MonthDate__c = Date.newInstance(yearNumber, monthNumber, 10);

            insert monthlyExp;
        }
    }
}