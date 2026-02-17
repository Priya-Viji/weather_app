import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class SunTimesCard extends StatelessWidget {
  final dynamic weather;

  const SunTimesCard({super.key, required this.weather});

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
          _buildSunTimeItem(
            Icons.wb_sunny_rounded,
            DateFormat('h:mm a').format(weather.sunrise),
            "sunrise".tr(),
          ),
          Container(height: 60, width: 1, color: AppColors.divider),
          _buildSunTimeItem(
            Icons.nights_stay_rounded,
            DateFormat('h:mm a').format(weather.sunset),
            "sunset".tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildSunTimeItem(IconData icon, String time, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white20,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            time,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
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
