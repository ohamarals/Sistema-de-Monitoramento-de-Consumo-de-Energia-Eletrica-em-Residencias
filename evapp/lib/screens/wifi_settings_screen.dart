import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.
import 'package:shared_preferences/shared_preferences.dart'; // Importa a biblioteca para armazenamento de preferências compartilhadas.
import 'wifi_login_screen.dart'; // Importa a tela de login de Wi-Fi.

// Define a classe WiFiSettingsScreen como um widget Stateful.
class WiFiSettingsScreen extends StatefulWidget {
  @override
  _WiFiSettingsScreenState createState() => _WiFiSettingsScreenState();
}

// Define o estado associado ao widget WiFiSettingsScreen.
class _WiFiSettingsScreenState extends State<WiFiSettingsScreen> {
  bool _isConnected = false; // Estado de conexão inicializado como falso.
  String _ssid = 'Amaral'; // Nome do SSID fixo para este exemplo.

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus(); // Verifica o status da conexão ao iniciar.
  }

  // Método para verificar o status da conexão.
  Future<void> _checkConnectionStatus() async {
    final prefs = await SharedPreferences
        .getInstance(); // Obtém uma instância das preferências compartilhadas.
    setState(() {
      _isConnected = prefs.getBool('isConnected') ??
          false; // Atualiza o estado de conexão com base nas preferências.
    });
  }

  // Método para desconectar do Wi-Fi.
  Future<void> _disconnect() async {
    final prefs = await SharedPreferences
        .getInstance(); // Obtém uma instância das preferências compartilhadas.
    await prefs.setBool('isConnected',
        false); // Define o estado de conexão como falso nas preferências.
    setState(() {
      _isConnected = false; // Atualiza o estado de conexão no aplicativo.
    });
    // Exibe uma mensagem indicando que foi desconectado.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Desconectado de $_ssid')),
    );
    // Navega para a tela de login de Wi-Fi substituindo a tela atual.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WiFiLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexão ao Wi-Fi e Configuração ao Dispositivo'),
      ),
      body: Center(
        // Centraliza o conteúdo
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Exibe informações de conexão se estiver conectado.
              if (_isConnected) ...[
                Text(
                  'Conectado à $_ssid',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Força do Sinal: Excelente',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'IP: 192.168.1.2',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              ],
              // Container estilizado indicando sucesso na conexão.
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent, // Fundo verde claro
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Conexão com o dispositivo com sucesso',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Texto preto
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              // Botão para desconectar do Wi-Fi.
              ElevatedButton(
                onPressed: _disconnect,
                child: Text(
                  'Desconectar',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
