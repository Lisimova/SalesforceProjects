/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class MonthControllerTest {

    @TestSetup
    static void setupTest(){
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test', Office__c = 'Office 1');
        insert contact1;

        Date dat = Date.newInstance(2020, 01, 05);
        Monthly_Expense__c monthlyExpense = new Monthly_Expense__c(Balance__c = 200, Keeper__c = contact1.Id, MonthDate__c = dat);
        insert monthlyExpense;
    }

    @IsTest
    static void getAllDataTest() {

        Contact contact = [SELECT Id From Contact Where Email = 'qwe@mail.ru'];
        Map<String, List<String>> result = MonthsController.getAllData(2020, contact.Id);
    }

    @IsTest
    static void getTotalAmountTest() {
        Contact contact = [SELECT Id From Contact Where Email = 'qwe@mail.ru'];
        System.assertEquals('0.0', MonthsController.getTotalAmount(2020, contact.Id));
    }

    @IsTest
    static void getTotalIncomeTest() {
        Contact contact = [SELECT Id From Contact Where Email = 'qwe@mail.ru'];
        System.assertEquals('200.0', MonthsController.getTotalIncome(2020, contact.Id));
    }
}