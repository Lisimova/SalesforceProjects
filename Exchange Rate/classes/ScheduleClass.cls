public with sharing class ScheduleClass implements Schedulable {

    public static String CRON_EXP = '0 0 0 * * ? *';
    public static void execute(SchedulableContext sc) {
        ExchangeRatesController.makeResponse(Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day()));
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        System.debug(ct.CronExpression);
        System.debug(ct.TimesTriggered);
        System.debug(String.valueOf(ct.NextFireTime));
    }

}