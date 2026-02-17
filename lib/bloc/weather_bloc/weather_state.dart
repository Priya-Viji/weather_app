import 'package:weather_app/data/models/weather_model.dart';

class WeatherState {
  final bool loading;
  final WeatherModel? weather;
  final String? error;
  final bool fromCache;

  WeatherState({
    this.loading = false,
    this.weather,
    this.error,
    this.fromCache = false,
  });

  WeatherState copyWith({
    bool? loading,
    WeatherModel? weather,
    String? error,
    bool? fromCache,
  }) {
    return WeatherState(
      loading: loading ?? this.loading,
      weather: weather ?? this.weather,
      error: error,
      fromCache: fromCache ?? this.fromCache,
    );
  }

  factory WeatherState.initial() {
    return WeatherState(
      loading: false,
      weather: null,
      error: null,
      fromCache: false,
    );
  }
}
