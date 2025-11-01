import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class RElevatedButtonTheme {
  RElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.black,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.h16,
        horizontal: AppSizes.h24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      elevation: 2,
      surfaceTintColor: AppColors.primary,
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.v16,
        horizontal: AppSizes.h24,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r8)),
      surfaceTintColor: AppColors.primary,
    ),
  );
}
