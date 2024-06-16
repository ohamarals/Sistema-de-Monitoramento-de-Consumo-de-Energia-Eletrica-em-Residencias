import 'package:flutter/material.dart'; // Importa a biblioteca de widgets do Flutter

// Classe contendo constantes usadas no aplicativo
class AppConstants {
  // Definição de cores utilizadas no tema do aplicativo
  static const Color primaryColor =
      Color(0xFF1B5E20); // Cor primária do aplicativo
  static const Color secondaryColor =
      Color(0xFFFF5722); // Cor secundária do aplicativo
  static const Color backgroundColor =
      Color(0xFFFFFFFF); // Cor de fundo do aplicativo
  static const Color accentColor =
      Color(0xFF388E3C); // Cor de destaque do aplicativo

  // Configurações do broker MQTT
  static const String mqttBrokerUrl =
      'test.mosquitto.org'; // URL do broker MQTT para conexão
  static const int mqttBrokerPort = 1883; // Porta do broker MQTT para conexão

  // Tópicos MQTT para os dados de corrente e tensão
  static const String mqttTopicCurrent =
      'home/+/current'; // Tópico para os dados de corrente
  static const String mqttTopicVoltage =
      'home/+/voltage'; // Tópico para os dados de tensão

  // Formato de data usado no aplicativo
  static const String dateFormat =
      'yyyy-MM-dd HH:mm:ss'; // Formato de data padrão para exibição

  // Configurações de estilo para os cartões de informações
  static const double cardElevation =
      5.0; // Elevação dos cartões para sombreamento
  static const double borderRadius =
      10.0; // Raio de borda dos cartões para arredondamento
}
