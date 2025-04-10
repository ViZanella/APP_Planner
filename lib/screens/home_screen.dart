import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mocca Smart Planner'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Text(
                'Mocca Smart Planner',
                style: TextStyle(color: Colors.white, fontSize: 24),
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
      body: const Center(
        child: Text('Bem-vindo ao Mocca Smart Planner!'),
      ),
    );
  }
}
