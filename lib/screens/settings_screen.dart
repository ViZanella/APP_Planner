// Importa o pacote de componentes visuais do Flutter
import 'package:flutter/material.dart';

// Componente principal da tela de configurações
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// Estado da tela de configurações, onde são controladas as interações
class _SettingsScreenState extends State<SettingsScreen> {
  // Variável que controla o modo escuro
  bool _isDarkMode = false;

  // Tamanho da fonte escolhido pelo usuário
  double _fontSize = 16.0;

  // Controle das notificações (ativadas ou não)
  bool _notificationsEnabled = true;

  // Função para alterar o tamanho da fonte e atualizar a tela
  void _changeFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior com o título
      appBar: AppBar(title: const Text("Configurações")),

      // Corpo da tela com os ajustes
      body: Column(
        children: [
          // Switch para alternar entre modo claro e escuro
          SwitchListTile(
            title: const Text("Modo Claro/Escuro"),
            secondary: const Icon(Icons.brightness_6), // Ícone de brilho
            value: _isDarkMode, // Estado atual
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value; // Atualiza o valor ao interagir
              });
            },
          ),

          // Switch para ativar/desativar notificações
          SwitchListTile(
            title: const Text("Notificações"),
            secondary: const Icon(Icons.notifications), // Ícone de notificação
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),

          // Lista para selecionar o tamanho da fonte
          ListTile(
            leading: const Icon(Icons.text_fields), // Ícone de texto
            title: const Text("Tamanho da Fonte"),
            trailing: DropdownButton<double>(
              value: _fontSize, // Valor atual selecionado
              items: const [
                DropdownMenuItem(value: 14.0, child: Text("Pequena")),
                DropdownMenuItem(value: 16.0, child: Text("Média")),
                DropdownMenuItem(value: 18.0, child: Text("Grande")),
              ],
              onChanged: (value) {
                if (value != null) {
                  _changeFontSize(value); // Atualiza o tamanho da fonte
                }
              },
            ),
          ),

          // Opção fictícia para configurar senha
          ListTile(
            leading: const Icon(Icons.lock), // Ícone de cadeado
            title: const Text("Configurar Senha"),
            trailing: const Icon(Icons.arrow_forward_ios), // Seta de navegação
            onTap: () {
              // Exibe um aviso de que essa funcionalidade está em desenvolvimento
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
