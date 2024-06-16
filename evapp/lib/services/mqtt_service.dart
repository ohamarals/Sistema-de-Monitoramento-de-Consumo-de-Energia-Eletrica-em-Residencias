import 'dart:async'; // Importa a biblioteca Dart para manipulação de assincronismo.
import 'dart:convert'; // Importa a biblioteca Dart para manipulação de JSON.
import 'package:mqtt_client/mqtt_client.dart'; // Importa a biblioteca MQTT para cliente MQTT.
import 'package:mqtt_client/mqtt_server_client.dart'; // Importa a biblioteca MQTT para cliente servidor MQTT.
import 'package:shared_preferences/shared_preferences.dart'; // Importa a biblioteca para armazenamento de preferências compartilhadas.

// Classe que gerencia a conexão e comunicação MQTT.
class MqttService {
  final MqttServerClient _client; // Cliente MQTT.
  final StreamController<Map<String, dynamic>> _controller = StreamController<
      Map<String,
          dynamic>>.broadcast(); // Controlador de stream para dados MQTT.
  Timer? _simulationTimer; // Timer para simulação de dados.

  double _current = 0.0; // Valor inicial de corrente.
  final double _voltage = 127.0; // Tensão constante.
  final List<double> _hourlyConsumption =
      List.filled(24, 0.0); // Lista para consumo horário.
  double _consumoExcessivo = 2.0; // Limite inicial de consumo excessivo.

  // Construtor da classe que inicializa o cliente MQTT e carrega o limite de consumo excessivo.
  MqttService(String broker, String clientIdentifier)
      : _client = MqttServerClient(broker, clientIdentifier) {
    _loadConsumoExcessivo();
  }

  // Getter para a stream de dados.
  Stream<Map<String, dynamic>> get dataStream => _controller.stream;

  // Inicializa as configurações do cliente MQTT.
  void initializeMQTTClient() {
    _client.logging(on: true); // Ativa o log.
    _client.keepAlivePeriod = 20; // Define o período de keep-alive.
    _client.onDisconnected = onDisconnected; // Callback para desconexão.
    _client.onConnected = onConnected; // Callback para conexão.
    _client.onSubscribed = onSubscribed; // Callback para inscrição em tópico.
  }

  // Callback chamado quando o cliente se conecta ao broker.
  void onConnected() {
    print('Connected');
  }

  // Callback chamado quando o cliente se desconecta do broker.
  void onDisconnected() {
    print('Disconnected');
  }

  // Callback chamado quando o cliente se inscreve em um tópico.
  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  // Método para conectar ao broker MQTT.
  Future<void> connect() async {
    try {
      await _client.connect(); // Tenta conectar ao broker.
    } catch (e) {
      print('Exception: $e');
      _client.disconnect(); // Desconecta em caso de erro.
    }
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? event) {
        if (event != null) {
          final MqttPublishMessage recMess =
              event[0].payload as MqttPublishMessage;
          final String payload =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          final Map<String, dynamic> data = jsonDecode(payload);
          _controller.add(data); // Adiciona os dados recebidos à stream.
          print('Received message: $payload from topic: ${event[0].topic}>');
        }
      });
    }
  }

  // Método para desconectar do broker MQTT.
  void disconnect() {
    _client.disconnect(); // Desconecta o cliente.
    _controller.close(); // Fecha a stream.
  }

  // Carrega o limite de consumo excessivo das preferências compartilhadas.
  Future<void> _loadConsumoExcessivo() async {
    final prefs = await SharedPreferences.getInstance();
    _consumoExcessivo = prefs.getDouble('consumoExcessivo') ?? 2.0;
  }

  // Define o limite de consumo excessivo nas preferências compartilhadas.
  Future<void> setConsumoExcessivo(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('consumoExcessivo', value);
    _consumoExcessivo = value;
  }

  // Método para simular dados para testes.
  void simulateData() {
    // Valores simulados de consumo horário (em kWh).
    final hourlyConsumptionValues = [
      0.4,
      0.3,
      0.3,
      0.2,
      0.3,
      1.2,
      1.5,
      1.7,
      1.4,
      1.3,
      1.4,
      1.6,
      1.5,
      1.3,
      1.2,
      1.4,
      2.0,
      2.3,
      2.5,
      2.2,
      1.9,
      1.5,
      1.0,
      0.5
    ];

    // Timer que simula a atualização dos dados a cada 15 segundos.
    _simulationTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      final currentHour = timer.tick % 24; // Hora atual da simulação.
      final power =
          hourlyConsumptionValues[currentHour] * 1000; // Converte kW para W.
      _current = power /
          _voltage; // Calcula a corrente com base na potência (W) e tensão (V).

      // Consumo de energia em kWh.
      final energyConsumption = hourlyConsumptionValues[currentHour];

      // Atualiza o consumo horário.
      _hourlyConsumption[currentHour] = energyConsumption;

      // Dados simulados a serem enviados pela stream.
      final data = {
        'current': _current,
        'voltage': _voltage,
        'energyConsumption': energyConsumption,
        'hourlyConsumption': List<double>.from(_hourlyConsumption),
      };
      _controller.add(data); // Adiciona os dados à stream.

      // Verifica se o consumo ultrapassa o limite de consumo excessivo.
      if (energyConsumption > _consumoExcessivo) {
        // Adiciona um alerta à stream.
        _controller.add({
          'alert': 'Consumo excessivo detectado!',
          'current': _current,
          'voltage': _voltage,
          'energyConsumption': energyConsumption,
          'hourlyConsumption': List<double>.from(_hourlyConsumption),
        });
      }

      // Reseta os valores no final do dia simulado.
      if (currentHour == 23) {
        Future.delayed(Duration(seconds: 15), () {
          _hourlyConsumption.fillRange(0, _hourlyConsumption.length, 0.0);
          _controller.add({
            'current': 0.0,
            'voltage': _voltage,
            'energyConsumption': 0.0,
            'hourlyConsumption': List.filled(24, 0.0),
          });
        });
      }
    });
  }

  // Método para parar a simulação.
  void stopSimulation() {
    _simulationTimer?.cancel();
  }
}
