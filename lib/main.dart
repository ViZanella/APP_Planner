// Importações dos pacotes Flutter e das telas do aplicativo
import 'package:flutter/material.dart';
import 'package:planer/screens/home_screen.dart';
import 'package:planer/screens/calendar_screen.dart';
import 'package:planer/screens/tasks_screen.dart';
import 'package:planer/screens/goals_screen.dart';
import 'package:planer/screens/settings_screen.dart';
import 'package:planer/screens/notes_screen.dart';
import 'package:planer/screens/expenses_screen.dart';

// Função principal que inicia o aplicativo
void main() {
  runApp(const MoccaSmartPlanner()); // Executa o widget raiz da aplicação
}

// Widget principal do aplicativo, sem estado (StatelessWidget)
class MoccaSmartPlanner extends StatelessWidget {
  const MoccaSmartPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o banner "debug" do canto da tela
      title: 'Mocca Smart Planner',       // Título do app (pode aparecer em multitarefa ou notificações)

      // Define o tema do aplicativo (neste caso, usa tons de marrom)
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),

      // Tela inicial ao abrir o app
      home: const HomeScreen(),

      // Definição das rotas nomeadas que permitem navegação entre as telas
      routes: {
        '/calendar': (context) => const CalendarScreen(),
        '/tasks': (context) => const TaskScreen(),
        '/goals': (context) => const GoalsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notes': (context) => const NotesScreen(),
        '/expenses': (context) => const ExpensesScreen(),
      },
    );
  }
}
