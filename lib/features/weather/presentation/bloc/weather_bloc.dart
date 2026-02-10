import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/failures.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';
import '../../domain/usecases/get_weather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  WeatherBloc(this.getWeather) : super(const WeatherState()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));

      try {
        final weather = await getWeather(event.city);
        emit(state.copyWith(loading: false, weather: weather));
      } on CityNotFoundFailure catch (e) {
        emit(state.copyWith(loading: false, error: e.message));
      } on Failure catch (e) {
        emit(state.copyWith(loading: false, error: e.message));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), loading: false));
      }
    });
  }
}
