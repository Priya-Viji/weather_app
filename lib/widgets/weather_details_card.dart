import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class WeatherDetailsCard extends StatelessWidget {
  final dynamic weather;

  const WeatherDetailsCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white15,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow10,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            Icons.water_drop_rounded,
            "${weather.humidity}%",
            "humidity".tr(),
          ),
          Container(height: 60, width: 1, color: AppColors.divider),
          _buildDetailItem(Icons.air_rounded, "${weather.windSpeed}", "km/h"),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
