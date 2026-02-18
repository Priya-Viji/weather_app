# Weather App

A Flutter application that displays real-time weather information for any city.  
This project follows uses BLoC for state management.

## Features
- Search weather by city name
- Shows temperature, humidity, wind speed, sunrise & sunset
- Clean UI
- Error handling for API failures
- Unit-tested BLoC logic

## Tech Stack
- Flutter
- BLoC (flutter_bloc)
- Hive
- bloc_test & mockito for testing
- OpenWeather API

## Running the Application
1. Install dependencies:
   flutter pub get

2. Run the app:
   flutter run

## API Key Setup
Create:
lib/core/constantsapi_keys.dart

Add:
const String weatherApiKey = "YOUR_API_KEY_HERE";

## Running Tests
Run all tests:
flutter test

If mocks are updated:
dart run build_runner build --delete-conflicting-outputs

## Testing Approach
Unit tests validate the WeatherBloc logic using bloc_test and mockito.  
The GetWeather use-case is mocked to isolate business logic.

## Contact
Feel free to reach out or improve this project.
