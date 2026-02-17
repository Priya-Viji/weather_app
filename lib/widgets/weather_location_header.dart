import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class WeatherLocationHeader extends StatelessWidget {
  final String city;

  const WeatherLocationHeader({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.white90, size: 24),
            const SizedBox(width: 8),
            Text(
              city,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
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
            color: AppColors.white80,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
