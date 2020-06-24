public with sharing class ExpenseController {

    @AuraEnabled
    public static String getTotalAmount(String expenseCards, Id contactId) {

        Double sum = 0;
        List<String> datStrings = expenseCards.split('-');
        Date dat = Date.newInstance(Integer.valueOf(datStrings[0]), Integer.valueOf(datStrings[1]), Integer.valueOf(datStrings[2]));
        List<Expense_Card__c> exp = [SELECT Amount__c FROM Expense_Card__c Where CardDate__c = :dat And CardKeeper__c = :contactId];
        for(Expense_Card__c expenseCard : exp)
            sum += expenseCard.Amount__c;
        if (sum.intValue() == sum)
            return String.valueOf(sum.intValue());

        return String.valueOf(sum);
    }
}