import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.tempMin,
    required super.tempMax,
    required super.sunrise,
    required super.sunset,
  });

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
