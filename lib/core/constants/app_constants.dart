import 'package:flutter/material.dart';

class AppConstants {
  // City search URL
  static const String geoBaseUrl =
      'http://api.openweathermap.org/geo/1.0/direct?q=';

  // Weather data URL
  static const String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=';

  // API Key
  static const String apiKey = '1c38b5bad5a8eccf0563b6164576de28';

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
