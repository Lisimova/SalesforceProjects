/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class ExpensesControllerTest {

    @TestSetup
    static void setupTest(){
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test');
        insert contact1;

        Date dat = Date.newInstance(2020, 01, 05);

        Expense_Card__c expenseCard1 = new Expense_Card__c(Amount__c = 100, CardKeeper__c = contact1.Id, CardDate__c = dat);
        insert expenseCard1;

        Date dat2 = dat.addDays(2);
        Expense_Card__c expenseCard2 = new Expense_Card__c(Amount__c = 100, CardKeeper__c = contact1.Id, CardDate__c = dat2);
        insert expenseCard2;
    }

    @IsTest
    static void sortExpenseCardsByDatesTest() {
        Contact contact = [SELECT Id, Email FROM Contact Where Email = 'qwe@mail.ru'];
        Map<String, List<Expense_Card__c>> result = ExpensesController.sortExpenseCardsByDates('1', '2020', contact.Id);
        System.equals(1, result.size());
    }

    @IsTest
    static void deleteExpenseCardTest() {
        Contact contact = [SELECT Id, Email FROM Contact Where Email = 'qwe@mail.ru'];
        Expense_Card__c expenseCard = [SELECT Id From Expense_Card__c Where CardKeeper__c = :contact.Id LIMIT 1];

        ExpensesController.deleteExpenseCard(expenseCard);
    }

    @IsTest
    static void updateExpenseCardsTest() {

        Contact contact1 = [SELECT Id, Email FROM Contact Where Email = 'qwe@mail.ru'];

        Expense_Card__c expenseCard = [SELECT Amount__c, Description__c FROM Expense_Card__c Where CardKeeper__c = :contact1.Id LIMIT 1];
        List<Expense_Card__c> expenseCards = new List<Expense_Card__c>();
        expenseCards.add(expenseCard);
        System.assertEquals(false, ExpensesController.updateExpenseCards(expenseCards));

        expenseCard.Amount__c = 60;
        expenseCards = new List<Expense_Card__c>();
        expenseCards.add(expenseCard);
        System.assertEquals(true, ExpensesController.updateExpenseCards(expenseCards));
    }
}