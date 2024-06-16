import 'package:flutter/material.dart'; // Importa a biblioteca de widgets do Flutter
import 'services/mqtt_client.dart'; // Importa o arquivo que contém a lógica do cliente MQTT
import 'screens/monitoramento_screen.dart'; // Importa a tela de monitoramento

// Função principal que inicializa o aplicativo
void main() {
  runApp(MyApp()); // Executa o widget MyApp
}

// Define o widget principal do aplicativo
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); // Cria o estado do widget MyApp
}

// Define o estado do widget MyApp
class _MyAppState extends State<MyApp> {
  // Instancia o wrapper do cliente MQTT
  MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();

  // Strings que armazenarão as mensagens de tensão, corrente e potência
  String voltageMessage = "";
  String currentMessage = "";
  String powerMessage = "";

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient(); // Prepara o cliente MQTT

    // Escuta o stream de mensagens de tensão e atualiza o estado quando uma nova mensagem é recebida
    mqttClientWrapper.voltageStream.listen((String message) {
      setState(() {
        voltageMessage = message; // Atualiza a mensagem de tensão
      });
    });

    // Escuta o stream de mensagens de corrente e atualiza o estado quando uma nova mensagem é recebida
    mqttClientWrapper.currentStream.listen((String message) {
      setState(() {
        currentMessage = message; // Atualiza a mensagem de corrente
      });
    });

    // Escuta o stream de mensagens de potência e atualiza o estado quando uma nova mensagem é recebida
    mqttClientWrapper.powerStream.listen((String message) {
      setState(() {
        powerMessage = message; // Atualiza a mensagem de potência
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define o widget principal do aplicativo
    return MaterialApp(
      home: MonitoramentoScreen(
        voltageMessage:
            voltageMessage, // Passa a mensagem de tensão para a tela de monitoramento
        currentMessage:
            currentMessage, // Passa a mensagem de corrente para a tela de monitoramento
        powerMessage:
            powerMessage, // Passa a mensagem de potência para a tela de monitoramento
      ),
    );
  }
}
