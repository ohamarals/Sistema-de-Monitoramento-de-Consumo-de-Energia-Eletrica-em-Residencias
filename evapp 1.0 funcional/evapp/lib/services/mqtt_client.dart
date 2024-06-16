import 'dart:async'; // Importa a biblioteca para manipulação de temporizadores e streams
import 'dart:io'; // Importa a biblioteca para manipulação de I/O (Input/Output)
import 'package:mqtt_client/mqtt_client.dart'; // Importa a biblioteca MQTT
import 'package:mqtt_client/mqtt_server_client.dart'; // Importa a implementação do cliente MQTT para servidor

class MQTTClientWrapper {
  // Variáveis de configuração do cliente MQTT
  final String serverUri =
      '6a100913b4c6440fb83678b718a03f49.s1.eu.hivemq.cloud'; // URI do servidor MQTT
  final String username =
      'amaral'; // Nome de usuário para autenticação no servidor MQTT
  final String password =
      '22051978'; // Senha para autenticação no servidor MQTT
  final List<String> topics = [
    // Lista de tópicos aos quais o cliente irá se inscrever
    'home/sensor/voltage',
    'home/sensor/current',
    'home/sensor/power'
  ];

  late MqttServerClient client; // Declaração do cliente MQTT
  StreamController<String> _voltageController =
      StreamController<String>(); // Controlador de stream para tensão
  StreamController<String> _currentController =
      StreamController<String>(); // Controlador de stream para corrente
  StreamController<String> _powerController =
      StreamController<String>(); // Controlador de stream para potência

  // Construtor da classe MQTTClientWrapper
  MQTTClientWrapper() {
    // Inicializa o cliente MQTT com o servidor e porta
    client = MqttServerClient.withPort(
        serverUri,
        'flutter_client_' + DateTime.now().millisecondsSinceEpoch.toString(),
        8883);
    client.secure = true; // Define a conexão como segura (TLS)
    client.securityContext =
        SecurityContext.defaultContext; // Define o contexto de segurança padrão
    client.keepAlivePeriod =
        20; // Define o período de keep-alive para 20 segundos
    client.onDisconnected =
        onDisconnected; // Define a função de callback para desconexão
    client.onConnected =
        onConnected; // Define a função de callback para conexão
    client.onSubscribed =
        onSubscribed; // Define a função de callback para inscrição em tópicos
    client.logging(on: true); // Ativar logging para depuração
  }

  // Streams para acesso externo aos dados dos sensores
  Stream<String> get voltageStream => _voltageController.stream;
  Stream<String> get currentStream => _currentController.stream;
  Stream<String> get powerStream => _powerController.stream;

  // Prepara o cliente MQTT para conexão e inscrição nos tópicos
  void prepareMqttClient() async {
    try {
      // Conecta ao servidor MQTT com autenticação
      await client.connect(username, password);
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        // Inscreve-se nos tópicos se a conexão for bem-sucedida
        for (String topic in topics) {
          client.subscribe(
              topic,
              MqttQos
                  .atMostOnce); // Inscrição com QoS 0 (entrega no máximo uma vez)
        }
        // Escuta as atualizações nos tópicos inscritos
        client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final MqttPublishMessage recMess = c![0].payload
              as MqttPublishMessage; // Recebe a mensagem publicada
          final message = MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message); // Converte a mensagem para string
          // Direciona a mensagem para o controlador de stream correto com base no tópico
          switch (c[0].topic) {
            case 'home/sensor/voltage':
              _voltageController
                  .add(message); // Adiciona a mensagem ao controlador de tensão
              break;
            case 'home/sensor/current':
              _currentController.add(
                  message); // Adiciona a mensagem ao controlador de corrente
              break;
            case 'home/sensor/power':
              _powerController.add(
                  message); // Adiciona a mensagem ao controlador de potência
              break;
          }
        });
      } else {
        // Se a conexão falhar, imprime uma mensagem de erro
        print('ERROR: MQTT connection failed - ${client.connectionStatus}');
      }
    } on Exception catch (e) {
      // Se uma exceção ocorrer, imprime a exceção e desconecta o cliente
      print('Exception: $e');
      client.disconnect();
    }
  }

  // Função de callback chamada quando um tópico é inscrito
  void onSubscribed(String topic) {
    print(
        'Subscribed to topic $topic'); // Imprime uma mensagem indicando o tópico inscrito
  }

  // Função de callback chamada quando o cliente se desconecta
  void onDisconnected() {
    print(
        'MQTT client disconnected'); // Imprime uma mensagem indicando a desconexão
  }

  // Função de callback chamada quando o cliente se conecta
  void onConnected() {
    print('MQTT client connected'); // Imprime uma mensagem indicando a conexão
  }

  // Função para liberar recursos quando o cliente é destruído
  void dispose() {
    _voltageController.close(); // Fecha o controlador de tensão
    _currentController.close(); // Fecha o controlador de corrente
    _powerController.close(); // Fecha o controlador de potência
  }
}
