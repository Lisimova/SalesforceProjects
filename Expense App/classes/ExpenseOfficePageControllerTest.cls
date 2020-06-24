/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class ExpenseOfficePageControllerTest {

    @TestSetup
    static void setupTest(){
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test', Office__c = 'Office 1');
        insert contact1;

        Date dat = Date.newInstance(2020, 01, 05);
        Monthly_Expense__c monthlyExpense = new Monthly_Expense__c(Balance__c = 200, Keeper__c = contact1.Id, MonthDate__c = dat);
        insert monthlyExpense;
    }

    @IsTest
    static void getOfficeTest() {
        Contact contact = [SELECT Office__c FROM Contact Where Email = 'qwe@mail.ru'];
        System.assertEquals('Office 1', ExpensesOfficePageController.getOffice(contact.Id));

    }

    @IsTest
    static void getBalanceTest() {

        Contact contact = [SELECT Id From Contact Where Email = 'qwe@mail.ru'];
        System.assertEquals('200.0', ExpensesOfficePageController.getBalance(contact.Id));
    }

    @IsTest
    static void saveNewExpenseTest() {
        Contact contact = [SELECT Id From Contact Where Email = 'qwe@mail.ru'];
        Date dat = Date.newInstance(2020, 01, 05);
        Monthly_Expense__c monthlyExpense2 = [SELECT Id From Monthly_Expense__c Where Balance__c = 200];
        Expense_Card__c newExpenseCard2 = new Expense_Card__c(Amount__c = 30, CardDate__c = dat, MonthlyExpense__c = monthlyExpense2.Id);
        ExpensesOfficePageController.saveNewExpense(newExpenseCard2, contact.Id);
    }

    @IsTest
    static void topBalanceTest() {
        Contact contact = [SELECT Id From Contact Where Email = 'qwe@mail.ru'];
        ExpensesOfficePageController.topBalance('1', '2020', contact.Id, 40);
        ExpensesOfficePageController.topBalance('4', '2018', contact.Id, 40);
    }
}