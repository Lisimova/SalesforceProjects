/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class LoginPageControllerTest {

    @TestSetup
    static void setupTest(){
        Contact contact1 = new Contact(Email = 'qwe@mail.ru', Password__c = '111', LastName = 'test');
        insert contact1;
    }
    @IsTest
    static void getContactIdTest() {

        Contact contact = [Select Id From Contact Where Email = 'qwe@mail.ru' And Password__c = '111'];
        System.assertEquals(contact.Id, LoginPageController.getContactId('qwe@mail.ru', '111'));
        System.assertEquals(null, LoginPageController.getContactId(null, '111'));
        System.assertEquals(null, LoginPageController.getContactId('qwe@mail.ru', '123'));
    }

    @IsTest
    static void checkAdminTest(){
        Contact contact = [Select Id From Contact Where Email = 'qwe@mail.ru' And Password__c = '111'];
        System.assertEquals(false, LoginPageController.checkAdmin(contact.Id));
    }
}