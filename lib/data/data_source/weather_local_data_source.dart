import 'package:hive/hive.dart';
import '../models/weather_model.dart';

class WeatherLocalDataSource {
  final Box<WeatherModel> box;

  WeatherLocalDataSource(this.box);

  Future<void> cacheWeather(WeatherModel model) async {
    await box.put('last_weather', model);
  }

  WeatherModel? getLastWeather() {
    return box.get('last_weather');
  }
}
