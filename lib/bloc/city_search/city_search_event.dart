import 'package:equatable/equatable.dart';

abstract class CitySearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchCityEvent extends CitySearchEvent {
  final String query;

  SearchCityEvent(this.query);

  @override
  List<Object?> get props => [query];
}
