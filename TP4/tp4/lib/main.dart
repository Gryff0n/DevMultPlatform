import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'meteo.dart';

const apiKey = 'e5da11c436cc4decafa6d0f0da95c0bc';

void main() => runApp(const MeteoApp());

class MeteoApp extends StatelessWidget {
  const MeteoApp({super.key});
  @override
  Widget build(BuildContext context) =>
      const MaterialApp(home: PageMeteo(), debugShowCheckedModeBanner: false);
}

class PageMeteo extends StatefulWidget {
  const PageMeteo({super.key});

  @override
  State<PageMeteo> createState() => _PageMeteoState();
}

class _PageMeteoState extends State<PageMeteo> {
  final _controller = TextEditingController();
  Meteo? _meteo;

  Future<void> _chercher(String ville) async {
    //création de l'url
    final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': ville.trim(),
      'appid': apiKey,
      'units': 'metric',
      'lang': 'fr',
    });
    //récup réponse
    final reponse = await http.get(url);
    if (reponse.statusCode != 200) return; // ville introuvable, etc.
    //set state réponse
    setState(() => _meteo = Meteo.fromJson(jsonDecode(reponse.body)));
  }

  @override
  Widget build(BuildContext context) {
    final m = _meteo;
    return Scaffold(
      body: Column(
        children: [
          //search bar
          TextField(controller: _controller, onSubmitted: _chercher),
          Expanded(
            child: Center(
              //mise en page météo
              child: m == null
                  ? const Text('Saisissez une ville.')
                  : m.ville == "Paris"
                  ? const Text('Wow super original (ㆆ_ㆆ).')
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${m.ville}, ${m.pays}'),
                        Image.network(
                          'https://openweathermap.org/img/wn/${m.icone}@4x.png',
                          width: 160,
                        ),
                        Text(m.description),
                        Text('${m.temp.round()} °C'),
                        Text('Ressenti : ${m.ressenti.round()} °C'),
                        Text('Min : ${m.tempMin.round()} °C'),
                        Text('Max : ${m.tempMax.round()} °C'),
                        Text('Humidité : ${m.humidite} %'),
                        Text('Vent : ${(m.vent * 3.6).round()} km/h'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
