import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class WeatherDisplay extends StatelessWidget {
  final dynamic weather;
  final IconData weatherIcon;

  const WeatherDisplay({
    super.key,
    required this.weather,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.white15,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow10,
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(weatherIcon, size: 100, color: AppColors.white),
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
                    color: AppColors.white,
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
                      color: AppColors.white,
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
            color: AppColors.white95,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_upward, color: AppColors.white80, size: 16),
            Text(
              "${weather.tempMax}°",
              style: TextStyle(fontSize: 16, color: AppColors.white80),
            ),
            const SizedBox(width: 16),
            Icon(Icons.arrow_downward, color: AppColors.white80, size: 16),
            Text(
              "${weather.tempMin}°",
              style: TextStyle(fontSize: 16, color: AppColors.white80),
            ),
          ],
        ),
      ],
    );
  }
}
