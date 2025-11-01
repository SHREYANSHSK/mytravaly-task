import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class RElevatedButtonTheme {
  RElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );

}
