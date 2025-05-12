// Importações dos pacotes Flutter e das telas do aplicativo
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planer/screens/home_screen.dart';
import 'package:planer/screens/calendar_screen.dart';
import 'package:planer/screens/tasks_screen.dart';
import 'package:planer/screens/goals_screen.dart';
import 'package:planer/screens/settings_screen.dart';
import 'package:planer/screens/notes_screen.dart';
import 'package:planer/screens/expenses_screen.dart';
import 'package:planer/screens/eventos_screen.dart';
import 'package:planer/theme/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MoccaSmartPlanner(),
    ),
  );
}

class MoccaSmartPlanner extends StatelessWidget {
  const MoccaSmartPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mocca Smart Planner',
      theme: themeProvider.currentTheme,
      home: const HomeScreen(),
      routes: {
        '/calendar': (context) => const CalendarScreen(),
        '/events': (context) => EventosScreen(),
        '/tasks': (context) => const TaskScreen(),
        '/goals': (context) => const GoalsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notes': (context) => const NotesScreen(),
        '/expenses': (context) => const ExpensesScreen(),
        // adicione outras rotas aqui
      },
    );
  }
}
