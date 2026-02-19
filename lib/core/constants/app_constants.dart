import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // City search URL
  static const String geoBaseUrl =
      'http://api.openweathermap.org/geo/1.0/direct?q=';

  // Weather data URL
  static const String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=';

  // API Key
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // Supported languages
  static const supportedLanguages = [
    {'code': 'en', 'label': 'English', 'flag': '🇬🇧'},
    {'code': 'ta', 'label': 'தமிழ்', 'flag': '🇮🇳'},
    {'code': 'ml', 'label': 'മലയാളം', 'flag': '🇮🇳'},
  ];

  // UI constants
  static const double padding = 20.0;
  static const double radius = 14.0;

  static const int searchLimit = 5;

  // Gradients
  static const darkGradient = [Colors.black87, Colors.black54];

  static const lightGradient = [Color(0xFF4A90E2), Color(0xFF50C9C3)];
}
