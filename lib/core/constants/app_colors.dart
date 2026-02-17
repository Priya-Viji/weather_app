import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static final Color white20 = Colors.white.withValues(alpha: 0.20);
  static final Color white30 = Colors.white.withValues(alpha: 0.30);
  static final Color white70 = Colors.white.withValues(alpha: 0.70);
  static final Color white80 = Colors.white.withValues(alpha: 0.80);
  static final Color white90 = Colors.white.withValues(alpha: 0.90);
  static final Color white95 = Colors.white.withValues(alpha: 0.95);
  static final Color white15 = Colors.white.withValues(alpha: 0.15);

  static final Color shadow10 = Colors.black.withValues(alpha: 0.10);
  static final Color divider = Colors.white.withValues(alpha: 0.30);

  static const List<Color> lightGradient = [
    Color(0xFF56CCF2),
    Color(0xFF2F80ED),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF0F2027),
    Color(0xFF203A43),
    Color(0xFF2C5364),
  ];
}
