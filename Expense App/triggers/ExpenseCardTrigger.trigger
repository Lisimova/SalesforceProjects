/**
 * Created by Lenovo on 30.03.2020.
 */

trigger ExpenseCardTrigger on Expense_Card__c (before insert) {

    Monthly_Expense__c newMonthlyExpense = new Monthly_Expense__c();

    for (Expense_Card__c expenseCard : Trigger.new) {

        Integer month = expenseCard.CardDate__c.month();
        Integer year = expenseCard.CardDate__c.year();
        List<Monthly_Expense__c> monthlyExpenses = [SELECT Id, MonthDate__c From Monthly_Expense__c Where CALENDAR_MONTH(MonthDate__c) = :month AND CALENDAR_YEAR(MonthDate__c) = :year And  Keeper__c = :expenseCard.CardKeeper__c];

        if (monthlyExpenses.size() > 0 )
            expenseCard.MonthlyExpense__c = monthlyExpenses[0].Id;
        else {
            newMonthlyExpense.Keeper__c = expenseCard.CardKeeper__c;
            newMonthlyExpense.MonthDate__c = expenseCard.CardDate__c;
            insert newMonthlyExpense;

            expenseCard.MonthlyExpense__c = newMonthlyExpense.Id;
        }
    }

}