/**
 * Created by alena on 17.03.2020.
 */

public with sharing class YearsController {

    @AuraEnabled
    public static List<String> getYears(Integer year) {

        List<String> years = new List<String>();
        for (Integer i = 0; i < 4; i++)
            years.add(String.valueOf(year - i));

        years.sort();
        return years;
    }

}