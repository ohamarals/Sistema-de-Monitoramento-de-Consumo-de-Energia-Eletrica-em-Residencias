import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.

// Classe que define constantes usadas no aplicativo.
class AppConstants {
  // Cores usadas no aplicativo.
  static const Color primaryColor =
      Color(0xFF1B5E20); // Cor primária (verde escuro).
  static const Color secondaryColor =
      Color(0xFFFF5722); // Cor secundária (laranja).
  static const Color backgroundColor =
      Color(0xFFFFFFFF); // Cor de fundo (branco).
  static const Color accentColor =
      Color(0xFF388E3C); // Cor de destaque (verde).

  // Constantes para configuração do MQTT.
  static const String mqttBrokerUrl =
      'test.mosquitto.org'; // URL do broker MQTT para testes.
  static const int mqttBrokerPort = 1883; // Porta padrão do broker MQTT.

  // Constantes para os tópicos do MQTT.
  static const String mqttTopicCurrent =
      'home/+/current'; // Tópico MQTT para corrente.
  static const String mqttTopicVoltage =
      'home/+/voltage'; // Tópico MQTT para tensão.

  // Formato de data padrão.
  static const String dateFormat =
      'yyyy-MM-dd HH:mm:ss'; // Formato de data e hora.

  // Constantes de estilo para cartões.
  static const double cardElevation = 5.0; // Elevação padrão para cartões.
  static const double borderRadius = 10.0; // Raio de borda padrão para cartões.
}
