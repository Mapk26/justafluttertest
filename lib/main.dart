import 'package:flutter/material.dart';
import 'package:test_moneymour/bloc/meteo_bloc.dart';
import 'package:test_moneymour/model/meteo_model.dart';

import 'package:geolocator/geolocator.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Meteo test',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Meteo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  MeteoBloc meteoBloc = new MeteoBloc();
  Position position;
  List<Placemark> places;
  bool isLoading;

//  _update(context){
//    _getPosition();
//    Scaffold.of(context).showSnackBar( SnackBar(content: Text('Aggiornamento...'), duration: Duration(seconds: 1), ) );
//  }

  _getPosition() async{

    setState(() {
      isLoading = true;
    });

    try {
      position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (position == null)
        position = await Geolocator().getLastKnownPosition(
            desiredAccuracy: LocationAccuracy.high);

      if (position == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      places = await Geolocator().placemarkFromCoordinates(
            position.latitude, position.longitude);

      meteoBloc.fetchMeteo(position.latitude, position.longitude);
      setState(() {
        isLoading = false;
      });

    }catch(e){
      print('getPosition error: $e ');
      setState(() {
        isLoading = false;
        position = null;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  @override
  void dispose() {
    meteoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Container(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        child: StreamBuilder(
          stream: meteoBloc.getMeteoStream,
          builder: (context, AsyncSnapshot<MeteoModel> snapshot){

            if(isLoading)
              return Center( child: CircularProgressIndicator(), );

            if(snapshot.hasData && position!=null){

              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                    Padding(
                      child: Image.asset('${snapshot.data.currentlyModel.icon.replaceAll('-', '')}.png'),
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    ),


                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 12.0),
                        children: [

                          TextSpan( text: '${places.first.locality}\n',
                              style: TextStyle(color: Colors.blue, fontSize: 34.0),
                          ),
                          TextSpan(
                              text: '${places.first.subAdministrativeArea}\n',
                              style: TextStyle(color: Colors.blue, fontSize: 12.0),
                          ),
                          TextSpan(
                              text: '${places.first.thoroughfare}, ${places.first.subThoroughfare}\n\n',
                              style: TextStyle(color: Colors.blue, fontSize: 12.0),
                          ),

                          TextSpan(
                            text: '${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}',

                          ),

                          TextSpan(
                            text: '\nUltimo aggiornamento: ${snapshot.data.currentlyModel.lastUpdate}',
                            style: TextStyle(color: Colors.blueGrey)
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 20.0,),

                    ListTile(
                      leading: Icon(Icons.brightness_6),
                      title: Text('${snapshot.data.currentlyModel.summary}'),
                    ),

                    ListTile(
                      leading: Icon(Icons.equalizer),
                      title: Text('Temperatura ${snapshot.data.currentlyModel.celsiusTemperature} °C'),
                    ),

                    ListTile(
                      leading: Icon(Icons.hot_tub),
                      title: Text('Percepita  ${snapshot.data.currentlyModel.celsiusApparentTemperature} °C'),
                    ),



                  ],
                );
            }

            if(snapshot.connectionState==ConnectionState.waiting && position==null){

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 50.0, color: Colors.blue,),
                  SizedBox( height: 20.0,),
                  Flexible(
                    child: Text(
                      'Posizione non disponibile.\nRiprova o verifica di '
                      'aver fornito i permessi per accedere alla tua posizione.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ]
              );
            }

            return Center( child: CircularProgressIndicator(), );

          },
        ),
      ),

      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: _getPosition,
          tooltip: 'Update',
          child: Icon(Icons.update),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


/*
* */
