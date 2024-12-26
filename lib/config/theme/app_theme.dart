import 'package:flutter/material.dart';

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: "NeueHaasUnica",
      colorSchemeSeed: const Color(0xff99825D),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            Colors.white
          )
        )
      )
    );
  }
}
