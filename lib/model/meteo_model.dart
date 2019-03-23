import 'package:intl/intl.dart';


class MeteoModel{

  String lat, lon, timezone;

  CurrentlyModel currentlyModel;

  MeteoModel.fromJson(Map<String, dynamic> parsedJson){

    try{

      lat = parsedJson['lat'];
      lon = parsedJson['lon'];
      timezone = parsedJson['timezone'];

      print('timezone is $timezone');

      if(parsedJson['currently']!=null){

        print('parsing currently');

        currentlyModel = CurrentlyModel.fromJson(parsedJson['currently']);
      }

    }catch(e){
      print('MeteoModel error: $e');
    }

  }

}


class CurrentlyModel{


  String summary, icon ;
  int _lastUpdate;

  // Made these private to expose get methods for Celsius and Fahrenheit
  double _temperature, _apparentTemperature;


  CurrentlyModel.fromJson(Map<String, dynamic> parsedJson){

    try {
      _lastUpdate = parsedJson['time'];
      summary = parsedJson['summary'];
      icon = parsedJson['icon'];
      _temperature = parsedJson['temperature'] ?? 0.0;
      _apparentTemperature = parsedJson['apparentTemperature'] ?? 0.0;

    }catch(e){
      print('error $e');
    }
  }


  get lastUpdate{

    var when = DateTime.fromMillisecondsSinceEpoch(_lastUpdate*1000);

    var format = new DateFormat("HH:mm ss");
    var dateString = format.format(when);

    return '${dateString}sec';
  }

  String get celsiusTemperature => ((_temperature-32)*(5/9)).toStringAsFixed(1);

  String get celsiusApparentTemperature => ((_apparentTemperature-32)*(5/9)).toStringAsFixed(1);

  String get fahrenheitTemperature => _temperature.toStringAsFixed(1);

  String get fahrenheitApparentTemperature => _apparentTemperature.toStringAsFixed(1);

}


/*
* "currently": {
              "time": 1509993277,
              "summary": "Drizzle",
              "icon": "rain",
              "nearestStormDistance": 0,
              "precipIntensity": 0.0089,
              "precipIntensityError": 0.0046,
              "precipProbability": 0.9,
              "precipType": "rain",
              "temperature": 66.1,
              "apparentTemperature": 66.31,
              "dewPoint": 60.77,
              "humidity": 0.83,
              "pressure": 1010.34,
              "windSpeed": 5.59,
              "windGust": 12.03,
              "windBearing": 246,
              "cloudCover": 0.7,
              "uvIndex": 1,
              "visibility": 9.84,
              "ozone": 267.44
          },*/