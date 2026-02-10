import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_api_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService apiService;

  WeatherRepositoryImpl(this.apiService);

  @override
  Future<Weather> getWeather(String city) {
    return apiService.fetchWeather(city);
  }
}
