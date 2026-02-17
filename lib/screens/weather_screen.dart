import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/data_source/weather_api_service.dart';
import 'package:weather_app/data/data_source/weather_local_data_source.dart';
import 'package:weather_app/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather_app/bloc/weather_bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_bloc/weather_state.dart';
import 'package:weather_app/data/weather_repository.dart';
import 'package:weather_app/widgets/sun_times_card.dart';
import 'package:weather_app/widgets/weather_app_bar.dart';
import 'package:weather_app/widgets/weather_details_card.dart';
import 'package:weather_app/widgets/weather_display.dart';
import 'package:weather_app/widgets/weather_location_header.dart';

class WeatherScreen extends StatelessWidget {
  final String city;

  const WeatherScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final api = WeatherApiService(client: http.Client());

        final weatherBox = Hive.box<WeatherModel>('weatherBox');
        final local = WeatherLocalDataSource(weatherBox);

        final repo = WeatherRepository(
          apiService: api,
          localDataSource: local,
        );


        return WeatherBloc(repo)..add(FetchWeatherEvent(city));
      },

      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const WeatherAppBar(),

        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state.loading) return _buildLoading(context);
            if (state.error != null) return _buildError(context, state.error!);
            if (state.weather == null) return _buildEmpty(context);

            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  // ---------------- LOADING ----------------

  Widget _buildLoading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark ? AppColors.darkGradient : AppColors.lightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white20,
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "loadingWeather".tr(),
              style: TextStyle(
                color: AppColors.white90,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- ERROR ----------------

  Widget _buildError(BuildContext context, String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark ? AppColors.darkGradient : AppColors.lightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white20,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  error == "No Internet"
                      ? Icons.wifi_off_rounded
                      : Icons.cloud_off_rounded,
                  color: AppColors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                error == "City not found"
                    ? "errorCityNotFound".tr()
                    : error == "No Internet"
                    ? "noInternet".tr()
                    : "errorGeneric".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                error == "No Internet"
                    ? "checkConnection".tr()
                    : "tryAnotherCity".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white80, fontSize: 14),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<WeatherBloc>().add(FetchWeatherEvent(city));
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text("retry".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: gradient.first,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- EMPTY ----------------

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        "getWeather".tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  // ---------------- CONTENT ----------------

  Widget _buildContent(BuildContext context, WeatherState state) {
    final weather = state.weather!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark ? AppColors.darkGradient : AppColors.lightGradient;

    final weatherIcon = _getWeatherIcon(weather.description);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Extracted widgets
                WeatherLocationHeader(city: city),
                const SizedBox(height: 40),

                WeatherDisplay(weather: weather, weatherIcon: weatherIcon),
                const SizedBox(height: 40),

                WeatherDetailsCard(weather: weather),
                const SizedBox(height: 20),

                SunTimesCard(weather: weather),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- ICON LOGIC ----------------

  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains("rain") || desc.contains("drizzle")) {
      return Icons.water_drop_rounded;
    } else if (desc.contains("thunder") || desc.contains("storm")) {
      return Icons.thunderstorm_rounded;
    } else if (desc.contains("snow")) {
      return Icons.ac_unit_rounded;
    } else if (desc.contains("cloud")) {
      return Icons.cloud_rounded;
    } else if (desc.contains("clear")) {
      return Icons.wb_sunny_rounded;
    } else if (desc.contains("mist") || desc.contains("fog")) {
      return Icons.cloud_queue_rounded;
    }
    return Icons.wb_cloudy_rounded;
  }
}
