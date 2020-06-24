/**
 * Created by alena on 14.02.2020.
 */

@IsTest
private class WeatherCalloutTest {

    @IsTest
    static void testGetCallout() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());
        List<WeatherCallout> result = WeatherCallout.makeGetResponse('London');
        Test.stopTest();

        List<WeatherCallout> expectedValue = new List<WeatherCallout>();
        WeatherCallout wc1 = new WeatherCallout();
        wc1.city = 'Altstadt';
        wc1.data='Thu';
        wc1.humidity='75';
        wc1.iconUrl='http://openweathermap.org/img/wn/01d@2x.png';
        wc1.info='Clear';
        wc1.pressure='972.73';
        wc1.temp=287;
        wc1.tempCels=287;
        wc1.tempFahr=549;
        wc1.temp_max=287;
        wc1.temp_maxCels=287;
        wc1.temp_maxFahr=549;
        wc1.temp_min=282;
        wc1.temp_minCels=282;
        wc1.temp_minFahr=540;
        wc1.windSpeed='1.81';

        expectedValue.add(wc1);
        System.assertEquals(expectedValue[0].temp, result[0].temp);
        System.assertEquals(expectedValue[0].data, result[0].data);

        List<WeatherCallout> expectedValueFahr = WeatherCallout.celsiusToFahrenheit(expectedValue);
        System.assertEquals(540, wc1.temp);

        List<WeatherCallout> expectedValueCels = WeatherCallout.FahrenheitTocelsius(expectedValue);
        System.assertEquals(wc1.temp, expectedValueCels[0].temp);

    }

}