import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/city_search/city_search_event.dart';
import 'package:weather_app/bloc/city_search/city_search_state.dart';
import 'package:weather_app/data/data_source/geocoding_api_service.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final GeocodingApiService api;

  CitySearchBloc(this.api) : super(CitySearchState.initial()) {
    on<SearchCityEvent>(_onSearchCity);
  }

  Future<void> _onSearchCity(
    SearchCityEvent event,
    Emitter<CitySearchState> emit,
  ) async {
    final query = event.query.trim();

    // If user typed less than 2 characters → clear results
    if (query.length < 2) {
      emit(state.copyWith(loading: false, results: [], error: null));
      return;
    }

    emit(state.copyWith(loading: true, error: null));

    try {
      final results = await api.searchCity(query);

      emit(state.copyWith(loading: false, results: results));
    } catch (_) {
      emit(state.copyWith(loading: false, results: [], error: "NO_INTERNET"));
    }
  }
}
