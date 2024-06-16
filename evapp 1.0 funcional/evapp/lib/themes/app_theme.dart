import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColor,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: AppColors.secondaryTextColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundColor,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey[400],
    ),
  );
}

class AppColors {
  static const primaryColor = Color(0xFF0A0E21);
  static const secondaryColor = Color(0xFF1D1E33);
  static const backgroundColor = Color(0xFF004D40); // Verde escuro
  static const primaryTextColor = Color(0xFFFFFFFF);
  static const secondaryTextColor = Color(0xFF8D8E98);
  static const chartGreenColor = Color.fromRGBO(0, 255, 0, 1); // Verde claro
  static const chartGreenTransparent =
      Color.fromRGBO(0, 255, 0, 0.5); // Verde claro transparente
  static const chartOrangeColor = Colors.orange;
  static const chartRedColor = Colors.red;

  // Adicionando as cores específicas dos cartões
  static const currentCardColor = Color(0xFFB2FF59); // Verde claro
  static const voltageCardColor = Color(0xFFFFEB3B); // Amarelo
  static const powerCardColor = Color(0xFFFF5252); // Vermelho
  static const cardBackgroundColor = Color(0xFFFFFFFF); // Fundo branco
}
