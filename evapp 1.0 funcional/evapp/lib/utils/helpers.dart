import 'dart:convert'; // Importa a biblioteca para codificação e decodificação JSON
import 'package:intl/intl.dart'; // Importa a biblioteca para formatação de datas
import 'constants.dart'; // Importa a classe de constantes

// Classe que contém métodos auxiliares usados no aplicativo
class Helpers {
  // Formata um objeto DateTime em uma string conforme o formato definido em AppConstants
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat(AppConstants
        .dateFormat); // Cria um formatador de data com o formato definido em AppConstants
    return formatter.format(date); // Retorna a data formatada como string
  }

  // Formata um valor de corrente (double) em uma string com 2 casas decimais e adiciona "A" (ampere)
  static String formatCurrent(double current) {
    return '${current.toStringAsFixed(2)} A'; // Retorna a corrente formatada como string
  }

  // Formata um valor de tensão (double) em uma string com 2 casas decimais e adiciona "V" (volt)
  static String formatVoltage(double voltage) {
    return '${voltage.toStringAsFixed(2)} V'; // Retorna a tensão formatada como string
  }

  // Verifica se uma string é um JSON válido
  static bool isValidJson(String jsonString) {
    try {
      json.decode(jsonString); // Tenta decodificar a string JSON
      return true; // Retorna true se a string for um JSON válido
    } catch (e) {
      return false; // Retorna false se ocorrer uma exceção durante a decodificação
    }
  }
}
