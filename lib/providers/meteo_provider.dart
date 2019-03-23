import 'dart:convert';


import 'package:http/http.dart' show Client;


import 'package:test_moneymour/model/meteo_model.dart';

class MeteoProvider{

  final Client _client = Client();


  Future<MeteoModel> fetchData(double lat, double lon) async {


    //https://api.darksky.net/forecast/47fd732fa3e7cad1f01bb386392566c9/45.46427,%209.18951?lang=it&%20unit=auto
    var response = await _client.get("https://api.darksky.net/forecast/47fd732fa3e7cad1f01bb386392566c9/$lat,$lon?lang=it");

    if (response.statusCode == 200) {
      print('200');
      print(response.body.toString());
      MeteoModel meteo = MeteoModel.fromJson(json.decode(response.body));


      return meteo;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load');
    }

  }
}