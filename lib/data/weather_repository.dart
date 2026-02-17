import 'package:weather_app/data/data_source/weather_api_service.dart';
import 'package:weather_app/data/data_source/weather_local_data_source.dart';
import 'package:weather_app/data/models/weather_model.dart';

class WeatherRepository {
  final WeatherApiService apiService;
  final WeatherLocalDataSource localDataSource;

  WeatherRepository({required this.apiService, required this.localDataSource});

  Future<WeatherModel> getWeather(String city) async {
    try {
      // Try API first
      final remoteWeather = await apiService.getWeather(city);

      // Cache the result
      await localDataSource.cacheWeather(remoteWeather);

      return remoteWeather;
    } catch (_) {
      // If API fails → try cached data
      final cached = localDataSource.getLastWeather();

      if (cached != null) {
        return cached;
      }

      rethrow;
    }
  }
}
