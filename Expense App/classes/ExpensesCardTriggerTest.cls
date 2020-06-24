/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class ExpensesCardTriggerTest {

    @IsTest
    static void testBehavior() {
        Date dat = Date.newInstance(2020, 01, 05);
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test', Office__c = 'Office 1');
        insert contact1;

        Expense_Card__c expenseCard = new Expense_Card__c( CardDate__c = dat, CardKeeper__c = contact1.Id);
        insert expenseCard;
    }
}