import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class RAppBarTheme {
  RAppBarTheme._();

  static AppBarThemeData lightAppBarTheme = AppBarThemeData(

    backgroundColor: AppColors.primary,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),

    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    actionsIconTheme:
        IconThemeData(color: AppColors.primary, size: AppSizes.v24),
  );

}
