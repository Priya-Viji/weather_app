import 'package:hive/hive.dart';

part 'weather_model.g.dart';

/// This model converts API JSON into a Weather entity.
/// It also supports saving and loading from Hive.
@HiveType(typeId: 1)
class WeatherModel {
  @HiveField(0)
  final String cityName;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int humidity;

  @HiveField(4)
  final double windSpeed;

  @HiveField(5)
  final double tempMin;

  @HiveField(6)
  final double tempMax;

  @HiveField(7)
  final DateTime sunrise;

  @HiveField(8)
  final DateTime sunset;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.tempMin,
    required this.tempMax,
    required this.sunrise,
    required this.sunset,
  });

  /// Creates a WeatherModel from API JSON.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunrise'] * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
    );
  }
}
