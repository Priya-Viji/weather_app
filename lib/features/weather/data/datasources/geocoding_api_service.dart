import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingApiService {
  final String apiKey;

  GeocodingApiService(this.apiKey);

  Future<List<dynamic>> searchCity(String query) async {
    final url =
        "http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}
