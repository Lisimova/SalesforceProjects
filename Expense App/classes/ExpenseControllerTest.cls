/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class ExpenseControllerTest {

    @TestSetup
    static void setupTest(){
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test');
        insert contact1;

        Contact contact2 = new Contact(Email = 'ewq@mail.ru', Password__c = '111', LastName = 'test');
        insert contact2;

        Date dat = Date.newInstance(2020, 01, 05);

        Expense_Card__c expenseCard1 = new Expense_Card__c(Amount__c = 100, CardKeeper__c = contact1.Id, CardDate__c = dat);
        insert expenseCard1;

        Expense_Card__c expenseCard2 = new Expense_Card__c(Amount__c = 100, CardKeeper__c = contact2.Id, CardDate__c = dat);
        insert expenseCard2;
    }

    @IsTest
    static void getTotalAmountTest() {

        Contact contact = new Contact(Email = 'weq@mail.ru', Password__c = '111', LastName = 'test');
        insert contact;

        Date dat = Date.newInstance(2020, 01, 05);

        Expense_Card__c expenseCard1 = new Expense_Card__c(Amount__c = 75.5, CardKeeper__c = contact.Id, CardDate__c = dat);
        insert expenseCard1;

        System.assertEquals('75.5', ExpenseController.getTotalAmount('2020-01-05', contact.Id));
    }
}