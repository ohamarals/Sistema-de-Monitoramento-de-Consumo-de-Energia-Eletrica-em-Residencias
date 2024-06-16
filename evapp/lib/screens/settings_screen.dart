import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter.
import 'package:shared_preferences/shared_preferences.dart'; // Importa a biblioteca para armazenamento de preferências compartilhadas.
import 'wifi_settings_screen.dart'; // Importa a tela de configurações de Wi-Fi.

// Define a classe SettingsScreen como um widget Stateful.
class SettingsScreen extends StatefulWidget {
  // Funções passadas como parâmetros para salvar o consumo excessivo e atualizar o limite de alerta.
  final Future<void> Function(double value) onSaveConsumoExcessivo;
  final void Function(double newLimite) onLimiteAlertaConsumoChanged;

  const SettingsScreen({
    Key? key,
    required this.onSaveConsumoExcessivo,
    required this.onLimiteAlertaConsumoChanged,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

// Define o estado associado ao widget SettingsScreen.
class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _controller =
      TextEditingController(); // Controlador para o campo de texto.
  double _maxEnergyConsumption =
      2.0; // Valor padrão recomendado para o consumo máximo de energia.

  @override
  void initState() {
    super.initState();
    _loadMaxEnergyConsumption(); // Carrega o consumo máximo de energia salvo.
  }

  // Carrega o valor do consumo máximo de energia das preferências compartilhadas.
  Future<void> _loadMaxEnergyConsumption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _maxEnergyConsumption = prefs.getDouble('maxEnergyConsumption') ?? 2.5;
      _controller.text = _maxEnergyConsumption.toString();
    });
  }

  // Salva o valor do consumo máximo de energia nas preferências compartilhadas.
  Future<void> _saveMaxEnergyConsumption(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('maxEnergyConsumption', value);
    widget.onSaveConsumoExcessivo(value);
  }

  // Método chamado ao salvar o valor do consumo máximo.
  void _onSave() {
    final double? value = double.tryParse(
        _controller.text); // Converte o valor do campo de texto para double.
    if (value != null) {
      _saveMaxEnergyConsumption(value);
      setState(() {
        _maxEnergyConsumption = value;
      });
      widget.onLimiteAlertaConsumoChanged(value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Limite de alerta de consumo atualizado para $value kW')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Opção de configuração para conexão Wi-Fi e dispositivo.
          _buildSettingsOption(
            context,
            title: 'Conexão ao Wi-Fi e Configuração ao Dispositivo',
            icon: Icons.wifi,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WiFiSettingsScreen()),
              );
            },
          ),
          // Opção de configuração para notificações.
          _buildSettingsOption(
            context,
            title: 'Configurações de Notificações',
            icon: Icons.notifications,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Configurações de Notificações'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Consumo máximo (kW)',
                            hintText: 'Insira o valor de consumo máximo',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Recomendado: 2.0 kW',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _onSave();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Salvar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // Opção de configuração para verificador de corrente.
          _buildSettingsOption(
            context,
            title: 'Verificador de Corrente',
            icon: Icons.check_circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrentCheckerScreen()),
              );
            },
          ),
          // Opção de configuração para verificador de tensão.
          _buildSettingsOption(
            context,
            title: 'Verificador de Tensão',
            icon: Icons.flash_on,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VoltageCheckerScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Método para construir uma opção de configuração.
  Widget _buildSettingsOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18.0),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// Classe para a tela de verificação de corrente.
class CurrentCheckerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificador de Corrente'),
      ),
      body: Center(
        child: Text('Conteúdo do Verificador de Corrente'),
      ),
    );
  }
}

// Classe para a tela de verificação de tensão.
class VoltageCheckerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificador de Tensão'),
      ),
      body: Center(
        child: Text('Conteúdo do Verificador de Tensão'),
      ),
    );
  }
}
