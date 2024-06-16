import 'dart:convert'; // Importa a biblioteca Dart para manipulação de JSON.
import 'package:intl/intl.dart'; // Importa a biblioteca Intl para formatação de datas.
import 'constants.dart'; // Importa o arquivo de constantes.

class Helpers {
  // Formata uma data para o formato especificado em AppConstants.dateFormat.
  static String formatDate(DateTime date) {
    final DateFormat formatter =
        DateFormat(AppConstants.dateFormat); // Cria um formatador de data.
    return formatter.format(date); // Retorna a data formatada.
  }

  // Formata um valor de corrente elétrica para uma string com duas casas decimais e a unidade "A".
  static String formatCurrent(double current) {
    return '${current.toStringAsFixed(2)} A'; // Retorna a corrente formatada como string.
  }

  // Formata um valor de tensão elétrica para uma string com duas casas decimais e a unidade "V".
  static String formatVoltage(double voltage) {
    return '${voltage.toStringAsFixed(2)} V'; // Retorna a tensão formatada como string.
  }

  // Verifica se uma string é um JSON válido.
  static bool isValidJson(String jsonString) {
    try {
      json.decode(jsonString); // Tenta decodificar a string JSON.
      return true; // Retorna true se a string é um JSON válido.
    } catch (e) {
      return false; // Retorna false se ocorrer uma exceção.
    }
  }
}
