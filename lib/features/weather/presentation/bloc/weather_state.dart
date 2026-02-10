import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

class WeatherState extends Equatable {
  final bool loading;
  final Weather? weather;
  final String? error;

  const WeatherState({this.loading = false, this.weather, this.error});

  WeatherState copyWith({bool? loading, Weather? weather, String? error}) {
    return WeatherState(
      loading: loading ?? this.loading,
      weather: weather ?? this.weather,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, weather, error];
}
