// Importa os widgets do Flutter e o Hive
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa a box do usuário
    final userBox = Hive.box('userBox');
    final nomeUsuario = userBox.get('nome', defaultValue: 'Usuário');

    return Scaffold(
      // AppBar (barra superior) com título e botão de menu
      appBar: AppBar(
        title: const Text('Mocca Smart Planner'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abre o menu lateral
            },
          ),
        ),
      ),

      // Drawer: menu lateral que desliza da esquerda
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.brown),
              child: Text(
                'Olá, $nomeUsuario!',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendário'),
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text('Eventos'),
              onTap: () {
                Navigator.pushNamed(context, '/events');
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Gestão de Despesas'),
              onTap: () {
                Navigator.pushNamed(context, '/expenses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Cronograma de Metas'),
              onTap: () {
                Navigator.pushNamed(context, '/goals');
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Listas de Tarefas'),
              onTap: () {
                Navigator.pushNamed(context, '/tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Anotações'),
              onTap: () {
                Navigator.pushNamed(context, '/notes');
              },
            ),
          ],
        ),
      ),

      // Corpo com imagem de fundo e texto central
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
          Image.asset(
            'assets/images/home.jpg',
            fit: BoxFit.cover,
          ),
          // Texto sobreposto
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Bem-vindo ao Mocca Smart Planner, $nomeUsuario!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
