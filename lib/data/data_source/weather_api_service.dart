import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/data/models/weather_model.dart';

class WeatherApiService {
  final http.Client client;

  WeatherApiService({required this.client});

  Future<WeatherModel> getWeather(String city) async {
    final uri = Uri.parse(
      '${AppConstants.weatherBaseUrl}$city&appid=${AppConstants.apiKey}&units=metric',
    );

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return WeatherModel.fromJson(jsonMap);
      }

      // Handle known status codes
      switch (response.statusCode) {
        case 400:
          throw Exception("Invalid request. Please check the city name.");
        case 401:
          throw Exception("Invalid API key.");
        case 403:
          throw Exception("Access denied. API key may be restricted.");
        case 404:
          throw Exception("City not found.");
        case 429:
          throw Exception("Too many requests. Try again later.");
        default:
          if (response.statusCode >= 500) {
            throw Exception("Server error: ${response.statusCode}");
          }
          throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error. Please check your connection.");
    }
  }
}
