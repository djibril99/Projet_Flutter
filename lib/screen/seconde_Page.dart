

import 'package:flutter/material.dart';



import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  //chaine de caractere  afficher en dessous de la barre de progression
  var chaine_afficher = "Veillez patienter SVP";

  double progressValue = 0.0;
  Timer? timer;
  int currentCityIndex = 0;
  // QUELque CITy
  City paris = City(2.3522, 48.8566, 'Paris');
  City washingtonDC = City(-77.0369, 38.9072, 'Washington, D.C.');
  City tokyo = City(139.6917, 35.6895, 'Tokyo');
  City moscow = City(37.6176, 55.7558, 'Moscow');
  City cairo = City(31.2357, 30.0444, 'Cairo');

  List<City> cities = [];

  String currentMessage = 'Nous téléchargeons les données...';
  List<Map<String, dynamic>> weatherData = [];
  bool showResults = false;

  @override
  void initState() {
    super.initState();

    cities.add(paris);
    cities.add(washingtonDC);
    cities.add(tokyo);
    cities.add(moscow);
    cities.add(cairo);

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const duration = const Duration(seconds: 60);
    const tick = const Duration(seconds: 1);
    int elapsedSeconds = 0;

    timer = Timer.periodic(tick, (Timer t) {
      setState(() {
        elapsedSeconds += 1;
        progressValue = elapsedSeconds / duration.inSeconds;

        if (elapsedSeconds % 10 == 0) {
          if (currentCityIndex < cities.length) {
            City currentCity = cities[currentCityIndex] ;

            int pourcentage = ((currentCityIndex/cities.length )*100) as int ;
            currentMessage = 'Téléchargement pour ${currentCity.name} $pourcentage%...';
            fetchWeatherData(currentCity);
            currentCityIndex++;
          } else {
            currentMessage = 'C\'est presque fini...';
          }
        }
      });

      if (elapsedSeconds >= duration.inSeconds) {
        t.cancel();
        currentMessage = 'Plus que quelques secondes avant d\'avoir le résultat...';
        showResults = true;
      }
    });
  }

  Future<void> fetchWeatherData(City city) async {
    final apiKey = '9fba0b611dd17d7383a4533599c904b2';
    double lat = city.latitude ;
    double long = city.longitude;
    String name = city.name;
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherData.add({
          'city': name,
          'temperature': data['main']['temp'],
          'cloudiness': data['weather'][0]['description'],
        });
      });
    } else {
      print('Erreur lors du chargement des données pour $city');
    }
  }

  Widget buildProgressMessage() {
    return Text(
      currentMessage,
      style: TextStyle(fontSize: 20),
    );
  }

  Widget buildWeatherTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Résultats obtenus :',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        DataTable(
          columns: [
            DataColumn(label: Text('City')),
            DataColumn(label: Text('Temperature')),
            DataColumn(label: Text('Cloudiness')),

          ],
          rows: List<DataRow>.generate(
            weatherData.length,
                (index) {
              final data = weatherData[index];
              final color = index % 2 == 0 ? Colors.white : Colors.grey.withOpacity(0.5);

              return DataRow(
                color: MaterialStateColor.resolveWith((states) => color),
                cells: [
                  DataCell(Text(data['city'])),
                  DataCell(Text(data['temperature'].toString())),
                  DataCell(Text(data['cloudiness'])),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Center(
            child:ElevatedButton(
              onPressed: () {
                setState(() {
                  progressValue = 0.0;
                  currentCityIndex = 0;
                  currentMessage = 'Nous téléchargeons les données...';
                  weatherData.clear();
                  showResults = false;
                  startTimer();
                });
              },
              child: Text('Recommencer'),
            ),
          )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !showResults?
              Text(
               "Les données sont en cours de chargement",
                style: TextStyle(fontSize: 24),
              )
                :
              Image.network(
                "assets/images/soleil.gif",
                width: 100,
                height: 100,
              )
            ,
            SizedBox(height: 20),
            showResults ? buildWeatherTable() : buildProgressMessage(),
            SizedBox(height: 20),

            if(!showResults)
              Container(
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // Arrondir les coins du conteneur
                  color: Colors.grey[300], // Couleur de fond du conteneur
                ),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 25,
                  backgroundColor: Colors.transparent, // Définir la couleur de fond de la barre de progression comme transparente
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Couleur de la barre de progression
                ),
              ),

          ],
        ),
      ),
    );
  }
}


class City {
  late double longitude;
  late double latitude;
  late String name;

  City(double lon, double lat , String name) {
    this.latitude = lat;
    this.longitude = lon;
    this.name = name;
  }
}
