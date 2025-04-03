import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  bool _notificationsEnabled = true;

  void _changeFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: Column(
        children: [
          // Modo Claro/Escuro
          SwitchListTile(
            title: const Text("Modo Claro/Escuro"),
            secondary: const Icon(Icons.brightness_6),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),

          // Tamanho da Fonte
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

          // Notificações
          SwitchListTile(
            title: const Text("Notificações"),
            secondary: const Icon(Icons.notifications),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),

          // Configurar Senha
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
 