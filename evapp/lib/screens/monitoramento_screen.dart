import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.
import 'package:provider/provider.dart'; // Importa a biblioteca Provider para gerenciamento de estado.
import 'package:syncfusion_flutter_charts/charts.dart'; // Importa a biblioteca Syncfusion para gráficos.
import 'package:enervision_app/services/mqtt_service.dart'; // Importa o serviço MQTT.
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importa a biblioteca para notificações locais.
import 'settings_screen.dart'; // Importa a tela de configurações.
import 'package:shared_preferences/shared_preferences.dart'; // Importa a biblioteca para armazenamento de preferências compartilhadas.
import 'package:enervision_app/themes/app_theme.dart'; // Importa o tema do aplicativo.
import 'wifi_login_screen.dart'; // Importa a tela de login Wi-Fi.

// Define a classe MonitoramentoScreen como um widget Stateful.
class MonitoramentoScreen extends StatefulWidget {
  const MonitoramentoScreen({Key? key}) : super(key: key);

  @override
  _MonitoramentoScreenState createState() => _MonitoramentoScreenState();
}

// Define o estado associado ao widget MonitoramentoScreen.
class _MonitoramentoScreenState extends State<MonitoramentoScreen> {
  int _selectedIndex =
      0; // Índice do item selecionado na barra de navegação inferior.
  late FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin; // Plugin para notificações locais.
  double _limiteAlertaConsumo =
      2.0; // Valor limite padrão para alertas de consumo.

  // Método chamado ao selecionar um item na barra de navegação inferior.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Inicializa o plugin de notificações.
    _checkWiFiStatus(); // Verifica o status da conexão Wi-Fi.
    _loadLimiteAlertaConsumo(); // Carrega o limite de alerta de consumo salvo.
  }

  // Inicializa o plugin de notificações locais.
  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Exibe uma notificação com a mensagem especificada.
  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alerta de Consumo',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Carrega o limite de alerta de consumo das preferências compartilhadas.
  Future<void> _loadLimiteAlertaConsumo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _limiteAlertaConsumo = prefs.getDouble('limiteAlertaConsumo') ?? 2.0;
    });
  }

  // Salva o limite de alerta de consumo nas preferências compartilhadas.
  Future<void> _saveLimiteAlertaConsumo(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('limiteAlertaConsumo', value);
    setState(() {
      _limiteAlertaConsumo = value;
    });
  }

  // Verifica o status da conexão Wi-Fi e navega para a tela de login Wi-Fi se não estiver conectado.
  Future<void> _checkWiFiStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isConnected = prefs.getBool('isConnected') ?? false;
    if (!isConnected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WiFiLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqttService = Provider.of<MqttService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enervision App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundColor, // Cor verde escuro.
        elevation: 0,
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? Container(
              color: AppColors.backgroundColor, // Fundo verde escuro.
              child: StreamBuilder<Map<String, dynamic>>(
                stream: mqttService.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Nenhum dado disponível'));
                  }
                  final data = snapshot.data!;
                  final current =
                      (data['current'] as double).toStringAsFixed(2) + ' A';
                  final voltage =
                      (data['voltage'] as double).toStringAsFixed(2) + ' V';
                  final power = ((data['current'] as double) *
                              (data['voltage'] as double))
                          .toStringAsFixed(2) +
                      ' W';
                  final energyConsumption =
                      (data['energyConsumption'] as double).toStringAsFixed(2) +
                          ' kWh';
                  final hourlyConsumption =
                      data['hourlyConsumption'] as List<dynamic>;

                  if (data['energyConsumption'] > _limiteAlertaConsumo) {
                    _showNotification(
                        'Consumo excessivo de energia detectado!');
                  }

                  return AnimatedOpacity(
                    opacity: snapshot.hasData ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildLargeInfoCard(
                                'Consumo de Energia (kWh)', energyConsumption),
                            _buildColumnChart(hourlyConsumption.cast<double>()),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSmallInfoCard(
                                      'Corrente (A)', current),
                                ),
                                Expanded(
                                  child: _buildSmallInfoCard(
                                      'Tensão (V)', voltage),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSmallInfoCard(
                                      'Potência (W)', power),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : SettingsScreen(
              onLimiteAlertaConsumoChanged: (double newLimite) {
                setState(() {
                  _limiteAlertaConsumo = newLimite;
                });
              },
              onSaveConsumoExcessivo: _saveLimiteAlertaConsumo,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'Monitoramento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  // Método para construir um cartão de informação grande.
  Widget _buildLargeInfoCard(String title, String value) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width * 0.1, // Ajuste dinâmico
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width * 0.05, // Ajuste dinâmico
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir um cartão de informação pequeno.
  Widget _buildSmallInfoCard(String title, String value) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width * 0.08, // Ajuste dinâmico
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width * 0.04, // Ajuste dinâmico
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir um gráfico de colunas.
  Widget _buildColumnChart(List<double> hourlyConsumption) {
    // Garantir que a lista tenha exatamente 23 elementos (de 1h a 23h)
    List<double> adjustedHourlyConsumption = hourlyConsumption.sublist(1, 24);

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3, // Ajuste dinâmico
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: 'Hora do Dia'),
              interval: 1,
              majorGridLines: const MajorGridLines(width: 0),
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                return ChartAxisLabel('${args.value.toInt() + 1}h',
                    null); // Ajuste para iniciar em 1h
              },
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value} kWh',
              maximum: 3,
            ),
            title: ChartTitle(text: 'Consumo de Energia (kWh)'),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Consumo de Energia: ${(point.y as double).toStringAsFixed(2)} kWh',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              zoomMode: ZoomMode.xy,
            ),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                dataSource: List.generate(23, (index) {
                  return ChartData(
                      (index + 1).toString(),
                      adjustedHourlyConsumption.length > index
                          ? adjustedHourlyConsumption[index]
                          : 0.0);
                }),
                xValueMapper: (ChartData data, _) => data.hour,
                yValueMapper: (ChartData data, _) => data.consumption,
                pointColorMapper: (ChartData data, _) {
                  if (data.consumption > 2.0) {
                    return Colors.red; // Vermelho para consumo > 2.0 kWh
                  } else if (data.consumption > 1.5) {
                    return Colors
                        .orange; // Laranja para consumo entre 1.5 kWh e 2.0 kWh
                  } else {
                    return AppColors
                        .chartGreenColor; // Verde claro para consumo ≤ 1.5 kWh
                  }
                },
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: AppColors.chartGreenColor, // Verde claro
                borderColor: AppColors.chartGreenColor, // Verde claro
                borderWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe para armazenar dados do gráfico.
class ChartData {
  ChartData(this.hour, this.consumption);
  final String hour; // Hora do dia
  final double consumption; // Consumo de energia
}
