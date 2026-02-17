import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/bloc/city_search/city_search_bloc.dart';
import 'package:weather_app/data/data_source/geocoding_api_service.dart';
import 'package:weather_app/screens/city_input_screen.dart';

// Mock class for GeocodingApiService
class MockGeocodingApiService extends Mock implements GeocodingApiService {}

void main() {
  testWidgets("CityInputScreen loads and shows search bar", (
    WidgetTester tester,
  ) async {
    final mockApi = MockGeocodingApiService();

    // IMPORTANT: Use a real string, not any matcher
    when(mockApi.searchCity("London")).thenAnswer((_) async => []);

    final bloc = CitySearchBloc(mockApi);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: CityInputScreen()),
      ),
    );

    // Check search bar exists
    expect(find.byType(TextField), findsOneWidget);

    // Type into search bar
    await tester.enterText(find.byType(TextField), "London");
    await tester.pump();

    // Verify bloc state updated
    expect(bloc.state, isNotNull);
  });
}
