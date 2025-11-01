import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class RChipTheme {
  RChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    backgroundColor: AppColors.white,
    selectedColor: AppColors.primary,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r8),
        side: BorderSide(color: AppColors.primary, width: AppSizes.w1)),
    deleteIconColor: AppColors.black,
    padding:
        EdgeInsets.symmetric(horizontal: AppSizes.h12, vertical: AppSizes.v8),
    side: const BorderSide(color: AppColors.primary),
    checkmarkColor: AppColors.white,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    labelStyle: const TextStyle(color: AppColors.white),
    backgroundColor: AppColors.black,
    selectedColor: AppColors.primary,
    padding:
        EdgeInsets.symmetric(horizontal: AppSizes.h12, vertical: AppSizes.v8),
    checkmarkColor: AppColors.black,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r8),
        side: BorderSide(color: AppColors.primary, width: AppSizes.w1)),
    side: const BorderSide(color: AppColors.primary),
  );
}
