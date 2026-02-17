import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/constants/app_constants.dart';

class GeocodingApiService {

  Future<List<dynamic>> searchCity(String query) async {
    final url = "${AppConstants.geoBaseUrl}$query&limit=5&appid=${AppConstants.apiKey}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      // Handle important status codes
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
      // Network or parsing error
      throw Exception("Network error. Please check your connection.");
    }
  }
}
