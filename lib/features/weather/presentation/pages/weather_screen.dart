import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/app_constants.dart';
import 'package:weather_app/features/weather/data/datasources/weather_api_service.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';
import 'package:weather_app/theme_provider.dart';

class WeatherScreen extends StatelessWidget {
  final String city;

  const WeatherScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final api = WeatherApiService(http.Client(), AppConstants.apiKey);
        final repo = WeatherRepositoryImpl(api);
        final usecase = GetWeather(repo);
        return WeatherBloc(usecase)..add(FetchWeatherEvent(city));
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state.loading) {
              return _buildLoadingState(context);
            }

            if (state.error != null) {
              return _buildErrorState(context, state.error!);
            }

            if (state.weather == null) {
              return _buildEmptyState(context);
            }

            return _buildWeatherContent(context, state);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      ),
      actions: [
        _buildAppBarAction(
          context,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) => context.setLocale(Locale(value)),
            itemBuilder: (context) => AppConstants.supportedLanguages
                .map(
                  (lang) => PopupMenuItem(
                    value: lang['code'],
                    child: Text(lang['label']!),
                  ),
                )
                .toList(),
          ),
        ),
        _buildAppBarAction(
          context,
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: Colors.white,
                ),
                onPressed: () => themeProvider.toggleTheme(!isDark),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAppBarAction(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: child,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? AppConstants.darkGradient
        : AppConstants.lightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Loading weather data...",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? AppConstants.darkGradient
        : AppConstants.lightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  error == "No Internet"
                      ? Icons.wifi_off_rounded
                      : Icons.cloud_off_rounded,
                  color: Colors.white,
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
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                error == "No Internet"
                    ? "Please check your connection"
                    : "Try searching for another city",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<WeatherBloc>().add(FetchWeatherEvent(city));
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text("retry".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: gradientColors.first,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        "getWeather".tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherState state) {
    final weather = state.weather!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? AppConstants.darkGradient
        : AppConstants.lightGradient;

    final weatherIcon = _getWeatherIcon(weather.description);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
                _buildLocationHeader(context),
                const SizedBox(height: 40),
                _buildMainWeatherDisplay(context, weather, weatherIcon),
                const SizedBox(height: 40),
                _buildWeatherDetailsCard(context, weather),
                const SizedBox(height: 20),
                _buildSunTimesCard(context, weather),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_rounded,
              color: Colors.white.withValues(alpha: 0.9),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              city,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEEE, MMMM d').format(DateTime.now()),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildMainWeatherDisplay(
    BuildContext context,
    dynamic weather,
    IconData weatherIcon,
  ) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(weatherIcon, size: 100, color: Colors.white),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: weather.temperature.toDouble()),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 88,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "°C",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          weather.description,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white.withValues(alpha:0.95),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_upward,
              color: Colors.white.withValues(alpha: 0.8),
              size: 16,
            ),
            Text(
              "${weather.tempMax}°",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha:0.8),
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_downward,
              color: Colors.white.withValues(alpha: 0.8),
              size: 16,
            ),
            Text(
              "${weather.tempMin}°",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetailsCard(BuildContext context, dynamic weather) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                context,
                Icons.water_drop_rounded,
                "${weather.humidity}%",
                "humidity".tr(),
              ),
              _buildDivider(),
              _buildDetailItem(
                context,
                Icons.air_rounded,
                "${weather.windSpeed}",
                "km/h",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunTimesCard(BuildContext context, dynamic weather) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSunTimeItem(
            context,
            Icons.wb_sunny_rounded,
            DateFormat('h:mm a').format(weather.sunrise),
            "sunrise".tr(),
          ),
          _buildDivider(),
          _buildSunTimeItem(
            context,
            Icons.nights_stay_rounded,
            DateFormat('h:mm a').format(weather.sunset),
            "sunset".tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunTimeItem(
    BuildContext context,
    IconData icon,
    String time,
    String label,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

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
