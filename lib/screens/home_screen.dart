// Importa os widgets e recursos do Flutter para construção da interface
import 'package:flutter/material.dart';

// Declara o widget HomeScreen como um StatelessWidget (sem estado interno)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar (barra superior) com título e botão de menu
      appBar: AppBar(
        title: const Text('Mocca Smart Planner'), // Título da barra
        leading: Builder(
          // Adiciona um botão de menu que abre o drawer (menu lateral)
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

            // Cabeçalho do menu lateral
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown), // Cor de fundo
              child: Text(
                'Mocca Smart Planner', // Título do menu
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // Item: Configurações
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pushNamed(context, '/settings'); // Navega para /settings
              },
            ),

            // Item: Calendário
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendário'),
              onTap: () {
                Navigator.pushNamed(context, '/calendar'); // Navega para /calendar
              },
            ),

            // Item: Gestão de Despesas
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Gestão de Despesas'),
              onTap: () {
                Navigator.pushNamed(context, '/expenses'); // Navega para /expenses
              },
            ),

            // Item: Cronograma de Metas
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Cronograma de Metas'),
              onTap: () {
                Navigator.pushNamed(context, '/goals'); // Navega para /goals
              },
            ),           

            // Item: Listas de Tarefas
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Listas de Tarefas'),
              onTap: () {
                Navigator.pushNamed(context, '/tasks'); // Navega para /tasks
              },
            ),

            // Item: Anotações
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Anotações'),
              onTap: () {
                Navigator.pushNamed(context, '/notes'); // Navega para /notes
              },
            ),
          ],
        ),
      ),

      // Corpo principal da tela: apenas uma mensagem de boas-vindas
      body: const Center(
        child: Text('Bem-vindo ao Mocca Smart Planner!'), // Mensagem central
      ),
    );
  }
}
