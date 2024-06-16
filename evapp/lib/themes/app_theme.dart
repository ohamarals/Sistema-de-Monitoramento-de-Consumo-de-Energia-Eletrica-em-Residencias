import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.

// Classe que define o tema do aplicativo.
class AppTheme {
  // Tema claro do aplicativo.
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor, // Cor primária do tema.
    scaffoldBackgroundColor:
        AppColors.backgroundColor, // Cor de fundo do scaffold.
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor, // Cor primária do esquema de cores.
      secondary:
          AppColors.secondaryColor, // Cor secundária do esquema de cores.
    ),
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColor, // Cor de fundo da AppBar.
      foregroundColor: Colors.white, // Cor do texto e ícones na AppBar.
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.0, // Tamanho da fonte.
        fontWeight: FontWeight.bold, // Peso da fonte.
        color: AppColors.primaryTextColor, // Cor do texto.
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0, // Tamanho da fonte.
        color: AppColors.secondaryTextColor, // Cor do texto.
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:
          AppColors.backgroundColor, // Cor de fundo da BottomNavigationBar.
      selectedItemColor: Colors.amber[800], // Cor do item selecionado.
      unselectedItemColor: Colors.grey[400], // Cor dos itens não selecionados.
    ),
  );
}

// Classe que define as cores usadas no aplicativo.
class AppColors {
  static const primaryColor = Color(0xFF0A0E21); // Cor primária.
  static const secondaryColor = Color(0xFF1D1E33); // Cor secundária.
  static const backgroundColor =
      Color(0xFF004D40); // Cor de fundo (verde escuro).
  static const primaryTextColor =
      Color(0xFFFFFFFF); // Cor do texto primário (branco).
  static const secondaryTextColor =
      Color(0xFF8D8E98); // Cor do texto secundário (cinza).
  static const chartGreenColor =
      Color.fromRGBO(0, 255, 0, 1); // Cor verde claro para gráficos.
  static const chartGreenTransparent = Color.fromRGBO(
      0, 255, 0, 0.5); // Cor verde claro transparente para gráficos.
  static const chartOrangeColor = Colors.orange; // Cor laranja para gráficos.
  static const chartRedColor = Colors.red; // Cor vermelha para gráficos.

  // Cores específicas para os cartões.
  static const currentCardColor = Color(0xFFB2FF59); // Verde claro.
  static const voltageCardColor = Color(0xFFFFEB3B); // Amarelo.
  static const powerCardColor = Color(0xFFFF5252); // Vermelho.
  static const cardBackgroundColor = Color(0xFFFFFFFF); // Fundo branco.
}
