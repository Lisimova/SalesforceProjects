/**
 * Created by alena on 26.03.2020.
 */

public with sharing class ExpensesController {

    private static List<Expense_Card__c> getMonthExpenseCards(Integer month, Integer year, Id contactId) {

        List<Expense_Card__c> expenseCards = [Select Id, Description__c, Amount__c, CardDate__c From Expense_Card__c Where CALENDAR_MONTH(CardDate__c) = :month AND CALENDAR_YEAR(CardDate__c) = :year AND CardKeeper__c = :contactId];

        return expenseCards;
    }

    private static List<Date> getDatesOfExpenseCards(Integer month, Integer year, Id contactId) {

        List<Expense_Card__c> expenseCards = getMonthExpenseCards(month, year, contactId);

        List<Date> dateList = new List<Date>();

        for(Expense_Card__c expenseCard : expenseCards)
        {
            if(!dateList.contains(expenseCard.CardDate__c))
                dateList.add(expenseCard.CardDate__c);
        }
        dateList.sort();

        return dateList;
    }

    @AuraEnabled
    public static Map<String, List<Expense_Card__c>> sortExpenseCardsByDates(String month, String year, Id contactId) {

        List<String> months = MonthsController.getAllMonths();
        Integer index = months.indexOf(month);

        if(month.isNumeric())
            index = Integer.valueOf(month);
        Integer monthNumber = index + 1;
        Integer yearNumber = Integer.valueOf(year);

        List<DateTime> dateList = getDatesOfExpenseCards(monthNumber, yearNumber, contactId);
        List<Expense_Card__c> expenseCards = new List<Expense_Card__c>();
        Map<String, List<Expense_Card__c>> sortBCardsByDates = new Map<String, List<Expense_Card__c>>();

        for (DateTime dat : dateList) {
            expenseCards = [Select Id, Description__c, Amount__c, CardDate__c From Expense_Card__c WHERE CardDate__c = :dat.dateGmt() AND CardKeeper__c = :contactId];
            sortBCardsByDates.put(dat.formatGmt('yyyy-MM-dd'), expenseCards);
        }
        return sortBCardsByDates;
    }

    @AuraEnabled
    public static void deleteExpenseCard (Expense_Card__c expenseCard) {

        delete expenseCard;
    }

    @AuraEnabled
    public static Boolean updateExpenseCards (List<Expense_Card__c> expenseCards) {

        Expense_Card__c expense_cards = [SELECT Amount__c, Description__c From Expense_Card__c Where Id In :expenseCards LIMIT 1];

        if (expense_cards.Description__c == expenseCards[0].Description__c && expense_cards.Amount__c == expenseCards[0].Amount__c)
            return false;
        else {
            update expenseCards;
            return true;
        }
    }

}