import 'package:mytravaly_task/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'widget_themes/appbar_theme.dart';
import 'widget_themes/chip_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/input_decoration_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      useMaterial3: true,
      brightness: Brightness.light,
      chipTheme: RChipTheme.lightChipTheme,
      appBarTheme: RAppBarTheme.lightAppBarTheme,
      elevatedButtonTheme: RElevatedButtonTheme.lightElevatedButtonTheme,
      inputDecorationTheme: RTextFormFieldTheme.lightInputDecorationTheme,
      iconTheme: IconThemeData(color: AppColors.black),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(AppColors.black),
        ),
      ));

}
