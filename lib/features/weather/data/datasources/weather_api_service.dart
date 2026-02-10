import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/failures.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  final http.Client client;
  final String apiKey;

  WeatherApiService(this.client, this.apiKey);

  Future<WeatherModel> fetchWeather(String city) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw CityNotFoundFailure();
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      throw Exception("No Internet");
    }
  }
}
