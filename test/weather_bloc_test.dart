import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';
import 'mocks/mock_get_weather.mocks.dart';

void main() {
  late MockGetWeather mockGetWeather;

  setUp(() {
    mockGetWeather = MockGetWeather();
  });

  final testWeather = Weather(
    cityName: "Chennai",
    temperature: 30,
    description: "Clear sky",
    humidity: 60,
    windSpeed: 5,
    tempMin: 25,
    tempMax: 35,
    sunrise: DateTime(2024, 1, 1, 6, 0),
    sunset: DateTime(2024, 1, 1, 18, 0),
  );

  blocTest<WeatherBloc, WeatherState>(
    'emits [loading, success] when weather is fetched successfully',
    build: () {
      when(mockGetWeather.call("Chennai")).thenAnswer((_) async => testWeather);

      return WeatherBloc(mockGetWeather);
    },
    act: (bloc) => bloc.add(FetchWeatherEvent("Chennai")),
    expect: () => [
      const WeatherState(loading: true, error: null, weather: null),
      WeatherState(loading: false, weather: testWeather, error: null),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'emits [loading, error] when API fails',
    build: () {
      when(mockGetWeather.call("Chennai")).thenThrow(Exception("No Internet"));

      return WeatherBloc(mockGetWeather);
    },
    act: (bloc) => bloc.add(FetchWeatherEvent("Chennai")),
    expect: () => [
      const WeatherState(loading: true, error: null, weather: null),
      const WeatherState(
        loading: false,
        error: "Exception: No Internet",
        weather: null,
      ),
    ],
  );
}
