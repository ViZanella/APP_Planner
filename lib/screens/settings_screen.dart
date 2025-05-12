import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:planer/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  bool _notificationsEnabled = true;
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Carrega as configurações salvas
  }

  // Carrega os valores salvos no Hive
  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('settingsBox');
    setState(() {
      _fontSize = _settingsBox.get('fontSize', defaultValue: 16.0);
      _notificationsEnabled = _settingsBox.get('notifications', defaultValue: true);
    });
  }

  // Salva uma configuração
  void _saveSetting(String key, dynamic value) {
    _settingsBox.put(key, value);
  }

  // Atualiza o tamanho da fonte e salva
  void _changeFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
    _saveSetting('fontSize', size);
  }

  // Atualiza o estado da notificação e salva
  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _saveSetting('notifications', value);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Modo Claro/Escuro"),
            secondary: const Icon(Icons.brightness_6),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
              _saveSetting('isDarkMode', value); // Se quiser salvar o tema também
            },
          ),
          SwitchListTile(
            title: const Text("Notificações"),
            secondary: const Icon(Icons.notifications),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text("Tamanho da Fonte"),
            trailing: DropdownButton<double>(
              value: _fontSize,
              items: const [
                DropdownMenuItem(value: 14.0, child: Text("Pequena")),
                DropdownMenuItem(value: 16.0, child: Text("Média")),
                DropdownMenuItem(value: 18.0, child: Text("Grande")),
              ],
              onChanged: (value) {
                if (value != null) {
                  _changeFontSize(value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Configurar Senha"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opção de senha em desenvolvimento")),
              );
            },
          ),
        ],
      ),
    );
  }
}
