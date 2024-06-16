import 'package:enervision_app/screens/monitoramento_screen.dart'; // Importa a tela de monitoramento.
import 'package:enervision_app/screens/wifi_settings_screen.dart'; // Importa a tela de configurações de Wi-Fi.
import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.
import 'package:provider/provider.dart'; // Importa a biblioteca Provider para gerenciamento de estado.
import 'package:enervision_app/services/mqtt_service.dart'; // Importa o serviço MQTT.
import 'package:enervision_app/themes/app_theme.dart'; // Importa o tema do aplicativo.
import 'package:enervision_app/screens/wifi_login_screen.dart'; // Importa a tela de login de Wi-Fi.

void main() {
  // Cria uma instância do serviço MQTT.
  final mqttService = MqttService('broker.hivemq.com', 'flutter_client');
  mqttService.initializeMQTTClient(); // Inicializa o cliente MQTT.
  mqttService.connect(); // Conecta ao broker MQTT.
  mqttService.simulateData(); // Adiciona a simulação de dados.

  // Executa o aplicativo Flutter.
  runApp(
    // MultiProvider para fornecer o serviço MQTT ao aplicativo.
    MultiProvider(
      providers: [
        Provider<MqttService>.value(value: mqttService),
      ],
      child: MyApp(), // Define MyApp como o widget raiz.
    ),
  );
}

// Define o widget principal do aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enervision', // Define o título do aplicativo.
      theme: AppTheme.lightTheme, // Define o tema do aplicativo.
      home:
          WiFiLoginScreen(), // Define a tela de login de Wi-Fi como a tela inicial.
      // Define as rotas do aplicativo.
      routes: {
        '/wifi_login': (context) => WiFiLoginScreen(),
        '/monitoramento': (context) => MonitoramentoScreen(),
        '/wifi_settings': (context) => WiFiSettingsScreen(),
      },
    );
  }
}
