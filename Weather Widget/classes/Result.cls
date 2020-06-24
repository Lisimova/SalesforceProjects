/**
 * Created by alena on 12.02.2020.
 */
    public class Result {

        public cls_coord coord;
        public cls_weather[] weather;
        public String base; //stations
        public cls_main main;
        public Integer visibility;  //10000
        public cls_wind wind;
        public cls_clouds clouds;
        public Integer dt;  //1485789600
        public cls_sys sys;
        public Integer id;  //2643743
        public String name; //London
        public Integer cod; //200

        public class cls_coord {
            public Double lon;  //-0.13
            public Double lat;  //51.51
        }
        public class cls_weather {
            public Integer id;  //300
            public String main; //Drizzle
            public String description;  //light intensity drizzle
            public String icon; //09d
        }
        public class cls_main {
            public Double temp; //280.32
            public Integer pressure;    //1012
            public Integer humidity;    //81
            public Double temp_min; //279.15
            public Double temp_max; //281.15
        }
        public class cls_wind {
            public Double speed;    //4.1
            public Integer deg; //80
        }
        public class cls_clouds {
            public Integer all; //90
        }
        public class cls_sys {
            public Integer type;    //1
            public Integer id;  //5091
            public Double message;  //0.0103
            public String country;  //GB
            public Integer sunrise; //1485762037
            public Integer sunset;  //1485794875
        }


    public with sharing class WeatherCallout {

        public Result weatherCallout() {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22');
            HttpResponse response = http.send(request);

            Result weather = new Result();
            if (response.getStatusCode() == 200) {
                weather = (Result) JSON.deserialize(response.getBody(), Result.class);
                System.debug('weather = ' + weather);

                System.debug('weather = ' + weather.main.temp_min); //Type is not visible: FromJSON.cls_main
            }
            return weather;
        }
    }
}