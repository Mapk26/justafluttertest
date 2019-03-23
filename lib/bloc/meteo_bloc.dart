

import 'package:test_moneymour/model/meteo_model.dart';
import 'package:test_moneymour/providers/meteo_provider.dart';
import 'package:rxdart/rxdart.dart';


class MeteoBloc{

  MeteoModel meteo;

  MeteoProvider meteoProvider = new MeteoProvider();

  /// Using RxDart

  final _meteoFetcher = PublishSubject<MeteoModel>();

  void dispose(){
    _meteoFetcher.close();
  }

  Observable<MeteoModel> get getMeteoStream => _meteoFetcher.stream;

  fetchMeteo(double lat, double lon) async{

    meteo = await meteoProvider.fetchData(lat, lon);

    _meteoFetcher.sink.add(meteo);
  }



}