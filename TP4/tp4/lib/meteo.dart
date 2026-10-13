class Meteo {
  final String ville;
  final String pays;
  final String description;
  final String icone;
  final double temp;
  final double ressenti;
  final double tempMin;
  final double tempMax;
  final int humidite;
  final double vent;

  Meteo({
    required this.ville,
    required this.pays,
    required this.description,
    required this.icone,
    required this.temp,
    required this.ressenti,
    required this.tempMin,
    required this.tempMax,
    required this.humidite,
    required this.vent,
  });

  factory Meteo.fromJson(Map<String, dynamic> json) {
    return Meteo(
      ville: json['name'] as String,
      pays: json['sys']['country'] as String? ?? '',
      description: json['weather'][0]['description'] as String,
      icone: json['weather'][0]['icon'] as String,
      temp: (json['main']['temp'] as num).toDouble(),
      ressenti: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidite: (json['main']['humidity'] as num).toInt(),
      vent: (json['wind']['speed'] as num).toDouble(),
    );
  }
}
