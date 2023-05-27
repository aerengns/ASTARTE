import 'package:flutter/material.dart';

import 'colors.dart';

class AstarteTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors.astarteRed,
      scaffoldBackgroundColor: CustomColors.astarteBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          backgroundColor: CustomColors.astarteRed,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        ),
      ),
    );
  }
}
