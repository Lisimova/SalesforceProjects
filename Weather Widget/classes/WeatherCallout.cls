/**
 * Created by alena on 12.02.2020.
 */

public with sharing class WeatherCallout {

    @AuraEnabled public String city {get; set;}
    @AuraEnabled public Integer temp {get; set;}
    @AuraEnabled public Integer temp_min {get; set;}
    @AuraEnabled public Integer temp_max {get; set;}

    @AuraEnabled public Integer tempFahr {get; set;}
    @AuraEnabled public Integer temp_minFahr {get; set;}
    @AuraEnabled public Integer temp_maxFahr {get; set;}

    @AuraEnabled public Integer tempCels {get; set;}
    @AuraEnabled public Integer temp_minCels {get; set;}
    @AuraEnabled public Integer temp_maxCels {get; set;}


    @AuraEnabled public String pressure {get; set;}
    @AuraEnabled public String humidity {get; set;}
    @AuraEnabled public String windSpeed {get; set;}
    @AuraEnabled public String info {get; set;}
    @AuraEnabled public String iconUrl {get; set;}
    @AuraEnabled public String data {get; set;}

    @AuraEnabled
    public static List<WeatherCallout> makeGetResponse(String city) {

        String endPoint = 'https://api.openweathermap.org/data/2.5/forecast?q=';
        String apiKey = '5c70d247a4c5a231037adb8fa9612b8d';
        String url = 'http://openweathermap.org/img/wn/';

        List<WeatherCallout> weatherList = new List<WeatherCallout> ();
        Http http = new Http();
        HttpRequest request = new HttpRequest();


        if (city == null) {

            alenalis96__Default_City__mdt dc = [SELECT Id, Name__c From alenalis96__Default_City__mdt  Limit 1];
            city = dc.Name__c;
        }


        request.setEndpoint(endPoint + city + '&units=metric&appid=' + apiKey);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
          Map <String, Object> weather = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            List<Object> resultList = (List<Object>) weather.get('list');


            for(Integer i = 0; i < resultList.size(); i+=8) {

                WeatherCallout weatherCallout = new WeatherCallout();

                Map<String, Object> name = (Map<String, Object>) weather.get('city');
                weatherCallout.city = String.valueOf((name.get('name')));

                Map<String, Object> results = (Map<String, Object>)resultList[i];
                weatherCallout.data = DateTime.valueOf(String.valueOf(results.get('dt_txt'))).format('E');

                Map<String, Object> wind = (Map<String, Object>) results.get('wind');
                weatherCallout.windSpeed = String.valueOf(wind.get('speed'));

                List<Object> weatherInfo = (List<Object>) results.get('weather');
                Map<String, Object> mapInfo = (Map<String, Object>)weatherInfo[0];
                weatherCallout.info = String.valueOf(mapInfo.get('main'));
                weatherCallout.iconUrl = url +  String.valueOf(mapInfo.get('icon')) + '@2x.png';

                Map<String, Object> resultTemp = (Map<String, Object>) results.get('main');
                weatherCallout.pressure = String.valueOf(resultTemp.get('pressure'));
                weatherCallout.humidity = String.valueOf(resultTemp.get('humidity'));

                weatherCallout.temp = Math.round(Double.valueOf(resultTemp.get('temp')));
                weatherCallout.temp_min = Math.round(Double.valueOf(resultTemp.get('temp_min')));
                weatherCallout.temp_max = Math.round(Double.valueOf(resultTemp.get('temp_max')));

                weatherCallout.tempFahr = celsiusToFahrenheit(weatherCallout.temp);
                weatherCallout.temp_minFahr = celsiusToFahrenheit(weatherCallout.temp_min);
                weatherCallout.temp_maxFahr = celsiusToFahrenheit(weatherCallout.temp_max);

                weatherCallout.tempCels = weatherCallout.temp;
                weatherCallout.temp_minCels = weatherCallout.temp_min;
                weatherCallout.temp_maxCels = weatherCallout.temp_max;

                weatherList.add(weatherCallout);

            }
        }

        else
            return null;
        return weatherList;
    }

    @AuraEnabled
    public static Integer celsiusToFahrenheit (Double celsiusTemp) {

        Double fahrenheitTemp = celsiusTemp * 9/5 + 32;

        return Math.round(fahrenheitTemp);
    }

    @AuraEnabled
    public static List<WeatherCallout> celsiusToFahrenheit (List<WeatherCallout> weatherList) {

        for (WeatherCallout wc : weatherList) {
            wc.temp = wc.temp_minFahr;
            wc.temp_max = wc.temp_maxFahr;
            wc.temp_min = wc.temp_minFahr;
        }

        return weatherList;
    }

    @AuraEnabled
    public static List<WeatherCallout> fahrenheitToCelsius (List<WeatherCallout> weatherList) {

        for (WeatherCallout wc : weatherList) {
            wc.temp = wc.temp_minCels;
            wc.temp_max = wc.temp_maxCels;
            wc.temp_min = wc.temp_minCels;
        }

        return weatherList;
    }

}