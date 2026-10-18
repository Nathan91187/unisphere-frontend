import 'package:flutter/material.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';

abstract final class AppTheme {
  static final appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light)
        .copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface
    ),
    scaffoldBackgroundColor: AppColors.background,

  );
}