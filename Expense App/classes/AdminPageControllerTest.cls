/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class AdminPageControllerTest {

    @TestSetup
    static void setupTest(){
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test', Office__c = 'Office 1');
        insert contact1;

        Contact contact2 = new Contact(Email = 'ewq@mail.ru', Password__c = '111', LastName = 'test', Office__c = 'Office 2');
        insert contact2;

        Contact contact3 = new Contact(Email = 'weq@mail.ru', Password__c = '111', LastName = 'test', Office__c = 'Office 1');
        insert contact3;

        Date dat = Date.newInstance(2020, 01, 05);

        Expense_Card__c expenseCard1 = new Expense_Card__c(Amount__c = 100, CardKeeper__c = contact1.Id, CardDate__c = dat);
        insert expenseCard1;

        Expense_Card__c expenseCard2 = new Expense_Card__c(Amount__c = 100, CardKeeper__c = contact2.Id, CardDate__c = dat);
        insert expenseCard2;

        Expense_Card__c expenseCard3 = new Expense_Card__c(Amount__c = 50, CardKeeper__c = contact3.Id, CardDate__c = dat);
        insert expenseCard3;
    }

    @IsTest
    static void getTotalSumTest() {
        System.assertEquals('150.0', AdminPageController.getTotalSum(2020)[0]);
    }

    @IsTest
    static void getRegionalExpensesTest() {
        System.assertEquals('Regional Expenses 2019', AdminPageController.getRegionalExpenses()[1]);
    }

    @IsTest
    static void getBalanceTest() {
        Contact contact1 = [Select Id FROM Contact Where Email = 'qwe@mail.ru'];
        Monthly_Expense__c monthlyExpense = new Monthly_Expense__c(Balance__c = 0, Keeper__c = contact1.Id, MonthDate__c = Date.newInstance(2020, 01, 05));
        System.assertEquals('-150.0', AdminPageController.getBalance(2020)[0]);
    }

    @IsTest
    static void getAverageTest() {
        System.assertEquals('75.00', AdminPageController.getAverage(2020)[0]);
    }

    @IsTest
    static void goToOfficeTest() {
        Contact contact1 = [Select Id, Office__c FROM Contact Where Email = 'qwe@mail.ru'];
        System.assertEquals(contact1.Id, AdminPageController.goToOffice('Office 1'));
    }

    @IsTest
    static void getMonthTest() {
        System.assertEquals('March', AdminPageController.getMonths()[2]);
    }

    @IsTest
    static void getTotalTest() {
        System.assertEquals('250.0', AdminPageController.getTotal(2020));
    }
}