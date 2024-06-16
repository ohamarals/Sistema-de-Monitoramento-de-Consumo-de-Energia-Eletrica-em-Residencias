import 'dart:async'; // Importa a biblioteca de temporização
import 'package:flutter/material.dart'; // Importa a biblioteca de widgets do Flutter
import 'package:enervision_app/themes/app_theme.dart'; // Importa o tema do aplicativo

// Define a tela de monitoramento como um StatefulWidget
class MonitoramentoScreen extends StatefulWidget {
  final String voltageMessage; // Mensagem de tensão
  final String currentMessage; // Mensagem de corrente
  final String powerMessage; // Mensagem de potência

  // Construtor da classe MonitoramentoScreen
  const MonitoramentoScreen({
    Key? key,
    required this.voltageMessage,
    required this.currentMessage,
    required this.powerMessage,
  }) : super(key: key);

  @override
  _MonitoramentoScreenState createState() => _MonitoramentoScreenState();
}

// Define o estado da tela de monitoramento
class _MonitoramentoScreenState extends State<MonitoramentoScreen> {
  late Timer _timer; // Timer para verificar a conexão
  bool _isConnected = false; // Status da conexão

  // Função executada na inicialização do estado
  @override
  void initState() {
    super.initState();
    _startConnectionTimer(); // Inicia o temporizador de conexão
  }

  // Inicia o temporizador para verificar a conexão
  void _startConnectionTimer() {
    // Define um temporizador que será executado a cada 10 segundos
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        // Define o status da conexão como falso se nenhuma mensagem for recebida
        _isConnected = false;
      });
    });
  }

  // Função chamada quando uma mensagem é recebida
  void _onMessageReceived() {
    setState(() {
      // Atualiza o status da conexão para verdadeiro
      _isConnected = true;
    });
    _timer.cancel(); // Cancela o temporizador atual
    _startConnectionTimer(); // Reinicia o temporizador
  }

  // Constrói a interface do widget
  @override
  Widget build(BuildContext context) {
    _onMessageReceived(); // Chama esta função quando uma mensagem é recebida
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enervision App',
          style: TextStyle(
            color: Colors.white, // Define a cor do texto do título
            fontWeight:
                FontWeight.bold, // Define o estilo do texto como negrito
          ),
        ),
        backgroundColor:
            AppColors.backgroundColor, // Cor de fundo da barra de aplicativo
        elevation: 0,
        centerTitle: true, // Centraliza o título na AppBar
      ),
      body: Container(
        color: AppColors.backgroundColor, // Cor de fundo da tela
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isConnected // Verifica se está conectado
                    ? Column(
                        children: [
                          _buildColumnChartPlaceholder(), // Placeholder para o gráfico
                          _buildLargeInfoCard(
                              'Corrente (A)',
                              widget
                                  .currentMessage), // Cartão de informações da corrente
                          _buildLargeInfoCard(
                              'Tensão (V)',
                              widget
                                  .voltageMessage), // Cartão de informações da tensão
                          _buildLargeInfoCard(
                              'Potência (W)',
                              widget
                                  .powerMessage), // Cartão de informações da potência
                        ],
                      )
                    : Text(
                        'Sem conexão ao sensor',
                        style: TextStyle(
                          color:
                              Colors.red, // Define a cor do texto como vermelho
                          fontSize: MediaQuery.of(context).size.width *
                              0.05, // Ajuste dinâmico do tamanho do texto
                          fontWeight: FontWeight
                              .bold, // Define o estilo do texto como negrito
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função para criar um cartão de informações grandes
  Widget _buildLargeInfoCard(String title, String value) {
    return Card(
      elevation: 8.0, // Define a elevação do cartão
      margin: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0), // Define as margens do cartão
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Define o raio das bordas do cartão
      ),
      child: Padding(
        padding: const EdgeInsets.all(
            12.0), // Define o preenchimento interno do cartão
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.07, // Ajuste dinâmico do tamanho do texto
                fontWeight:
                    FontWeight.bold, // Define o estilo do texto como negrito
                color: Colors.black, // Define a cor do texto como preto
              ),
            ),
            const SizedBox(height: 8.0), // Espaçamento vertical
            Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.035, // Ajuste dinâmico do tamanho do texto
                color: Colors.black, // Define a cor do texto como preto
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder para o gráfico de consumo de energia
  Widget _buildColumnChartPlaceholder() {
    return Card(
      elevation: 8.0, // Define a elevação do cartão
      margin: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0), // Define as margens do cartão
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Define o raio das bordas do cartão
      ),
      child: Padding(
        padding: const EdgeInsets.all(
            12.0), // Define o preenchimento interno do cartão
        child: Container(
          height: MediaQuery.of(context).size.height *
              0.25, // Ajuste dinâmico do tamanho do container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DESENVOLVIMENTO DO GRAFICO EM ANDAMENTO',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.045, // Ajuste dinâmico do tamanho do texto
                  fontWeight:
                      FontWeight.bold, // Define o estilo do texto como negrito
                  color: Colors.black, // Define a cor do texto como preto
                ),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função chamada quando o widget é destruído
  @override
  void dispose() {
    _timer.cancel(); // Cancela o temporizador
    super.dispose();
  }
}
