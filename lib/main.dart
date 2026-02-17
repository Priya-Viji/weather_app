import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:weather_app/core/theme/theme_provider.dart';

void main() async {
  //Flutter initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Localization initialized
  await EasyLocalization.ensureInitialized();

  //Hive initialize
  await Hive.initFlutter();

  // Register Hive adapter
  Hive.registerAdapter(WeatherModelAdapter());

  // Open Hive box to store cached weather data
  await Hive.openBox<WeatherModel>('weatherBox');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ta'), Locale('ml')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,

      // Localization setup
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      // Theme setup
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,

      home: const SplashScreen(),
    );
  }
}
