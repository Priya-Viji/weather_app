import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_bloc/weather_state.dart';
import 'package:weather_app/data/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherState.initial()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));

      try {
        final weather = await repository.getWeather(event.city);

        emit(
          state.copyWith(loading: false, weather: weather, fromCache: false),
        );
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      }
    });
  }
}
