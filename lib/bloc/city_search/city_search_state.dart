import 'package:equatable/equatable.dart';

class CitySearchState extends Equatable {
  final bool loading;
  final List<dynamic> results;
  final String? error;

  const CitySearchState({
    this.loading = false,
    this.results = const [],
    this.error,
  });

  CitySearchState copyWith({
    bool? loading,
    List<dynamic>? results,
    String? error,
  }) {
    return CitySearchState(
      loading: loading ?? this.loading,
      results: results ?? this.results,
      error: error,
    );
  }

  factory CitySearchState.initial() {
    return const CitySearchState(loading: false, results: [], error: null);
  }

  @override
  List<Object?> get props => [loading, results, error];
}
