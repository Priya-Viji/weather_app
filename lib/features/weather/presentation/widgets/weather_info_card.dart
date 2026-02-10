import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WeatherInfoCard extends StatelessWidget {
  final double temperature;
  final String description;

  const WeatherInfoCard({
    super.key,
    required this.temperature,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${"temperature".tr()}: ${temperature.toStringAsFixed(1)} °C',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('${"condition".tr()}: $description'),
          ],
        ),
      ),
    );
  }
}
