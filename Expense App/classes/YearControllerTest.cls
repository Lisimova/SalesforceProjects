/**
 * Created by Lenovo on 15.04.2020.
 */

@IsTest
private class YearControllerTest {
    @IsTest
    static void getYearstest() {
        System.assertEquals('2018', YearsController.getYears(2020)[1]);
    }
}