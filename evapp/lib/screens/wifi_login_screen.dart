import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.
import 'package:shared_preferences/shared_preferences.dart'; // Importa a biblioteca para armazenamento de preferências compartilhadas.
import 'monitoramento_screen.dart'; // Importa a tela de monitoramento.

// Define a classe WiFiLoginScreen como um widget Stateful.
class WiFiLoginScreen extends StatefulWidget {
  @override
  _WiFiLoginScreenState createState() => _WiFiLoginScreenState();
}

// Define o estado associado ao widget WiFiLoginScreen.
class _WiFiLoginScreenState extends State<WiFiLoginScreen> {
  // Controladores para os campos de texto SSID e senha.
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // SSID e senha corretos para conexão (valores fixos neste exemplo).
  final String _correctSSID = 'Amaral';
  final String _correctPassword = 'password123';

  // Método para tentar conectar ao Wi-Fi com os dados fornecidos.
  Future<void> _connect() async {
    // Verifica se os valores inseridos correspondem aos valores corretos.
    if (_ssidController.text == _correctSSID &&
        _passwordController.text == _correctPassword) {
      // Obtém uma instância das preferências compartilhadas.
      final prefs = await SharedPreferences.getInstance();
      // Define o estado de conexão como verdadeiro.
      await prefs.setBool('isConnected', true);
      // Navega para a tela de monitoramento substituindo a tela atual.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MonitoramentoScreen()),
      );
    } else {
      // Exibe uma mensagem de erro se SSID ou senha estiverem incorretos.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SSID ou senha incorretos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Corpo da tela centralizado.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título da tela.
              Text(
                'Conecte-se à rede Wi-Fi ou ao Dispositivo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Campo de texto para SSID.
              TextField(
                controller: _ssidController,
                decoration: InputDecoration(
                  labelText: 'SSID da Rede Wi-Fi',
                ),
              ),
              // Campo de texto para senha, com texto oculto.
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha da Rede Wi-Fi',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              // Botão para tentar conectar.
              ElevatedButton(
                onPressed: _connect,
                child: Text('Conectar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
