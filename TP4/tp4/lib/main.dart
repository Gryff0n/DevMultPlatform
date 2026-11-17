import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _mapController = MapController();

  Meteo? _meteo;
  LatLng? _point; // position affichée par le marqueur
  List<String> _favoris = [];

  @override
  void initState() {
    super.initState();
    _chargerFavoris();
  }

  // ---------- Favoris ----------

  Future<void> _chargerFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _favoris = prefs.getStringList('favoris') ?? []);
  }

  Future<void> _sauverFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoris', _favoris);
  }

  void _basculerFavori(String ville) {
    setState(() {
      _favoris.contains(ville) ? _favoris.remove(ville) : _favoris.add(ville);
    });
    _sauverFavoris();
  }

  // ---------- Appels API ----------

  /// Appel générique : [params] contient soit 'q' (ville), soit 'lat'+'lon'.
  Future<Meteo?> _appeler(Map<String, String> params) async {
    final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      ...params,
      'appid': apiKey,
      'units': 'metric',
      'lang': 'fr',
    });
    final reponse = await http.get(url);
    if (reponse.statusCode != 200) return null; // introuvable, etc.
    return Meteo.fromJson(jsonDecode(reponse.body));
  }

  /// Recherche par nom de ville (barre de recherche / favoris).
  Future<void> _chercher(String ville) async {
    final m = await _appeler({'q': ville.trim()});
    if (m == null) return;
    final p = LatLng(m.lat, m.lon);
    setState(() {
      _meteo = m;
      _point = p;
    });
    // recentre la carte sur la ville trouvée
    _mapController.move(p, _mapController.camera.zoom);
  }

  /// Recherche par coordonnées (clic sur la carte).
  Future<void> _chercherParPosition(LatLng p) async {
    setState(() => _point = p);
    final m = await _appeler({
      'lat': p.latitude.toString(),
      'lon': p.longitude.toString(),
    });
    if (m == null) return;
    setState(() => _meteo = m);
  }

  // ---------- UI ----------

  Widget _carte() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(46.6, 2.5), // centre de la France
        initialZoom: 5,
        onTap: (tapPosition, point) => _chercherParPosition(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.meteo',
        ),
        if (_point != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _point!,
                width: 40,
                height: 40,
                alignment: Alignment.topCenter,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _panneauMeteo() {
    final m = _meteo;
    return Center(
      child: m == null
          ? const Text('Saisissez une ville ou cliquez sur la carte.')
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        m.ville.isEmpty
                            ? 'Lieu inconnu'
                            : '${m.ville}, ${m.pays}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (m.ville.isNotEmpty)
                        IconButton(
                          tooltip: 'Ajouter / retirer des favoris',
                          icon: Icon(
                            _favoris.contains(m.ville)
                                ? Icons.star
                                : Icons.star_border,
                          ),
                          onPressed: () => _basculerFavori(m.ville),
                        ),
                    ],
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${m.icone}@4x.png',
                    width: 120,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // barre de recherche
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                onSubmitted: _chercher,
                decoration: const InputDecoration(
                  hintText: 'Rechercher une ville',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // liste des favoris
            if (_favoris.isNotEmpty)
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _favoris.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final ville = _favoris[i];
                    return InputChip(
                      avatar: const Icon(Icons.star, size: 18),
                      label: Text(ville),
                      onPressed: () {
                        _controller.text = ville;
                        _chercher(ville);
                      },
                      onDeleted: () => _basculerFavori(ville),
                    );
                  },
                ),
              ),

            // carte + météo : côte à côte si l'écran est large, sinon empilées
            Expanded(
              child: LayoutBuilder(
                builder: (context, contraintes) {
                  if (contraintes.maxWidth >= 700) {
                    return Row(
                      children: [
                        Expanded(flex: 3, child: _carte()),
                        Expanded(flex: 2, child: _panneauMeteo()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Expanded(flex: 2, child: _carte()),
                      Expanded(flex: 3, child: _panneauMeteo()),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
