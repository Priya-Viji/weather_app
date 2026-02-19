import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/core/theme/theme_provider.dart';


/// A reusable custom AppBar widget used in WeatherScreen.
class WeatherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,

      // BACK BUTTON
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white20,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white30),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      ),

      // ACTION BUTTONS
      actions: [
        // LANGUAGE SWITCHER
        _buildActionContainer(
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: AppColors.white),
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

        // THEME TOGGLE
        _buildActionContainer(
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.white,
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

  /// Reusable container style for AppBar action buttons
  Widget _buildActionContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.white20,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white30),
      ),
      child: child,
    );
  }
}
