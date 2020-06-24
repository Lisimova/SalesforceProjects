/**
 * Created by alena on 04.03.2020.
 */
@isTest
private class ScheduleTest {

    public static String CRON_EXP = '0 0 0 * * ? *';

    @isTest
    static void testScheduledJob() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExchangeHttpMock());
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new ScheduleClass());
        Test.stopTest();
    }
}