import 'package:flutter/material.dart';
import 'package:planer/screens/home_screen.dart';
import 'package:planer/screens/calendar_screen.dart';
import 'package:planer/screens/tasks_screen.dart';
import 'package:planer/screens/goals_screen.dart';
import 'package:planer/screens/settings_screen.dart';
import 'package:planer/screens/notes_screen.dart';
import 'package:planer/screens/expenses_screen.dart';

void main() {
  runApp(const MoccaSmartPlanner());
}

class MoccaSmartPlanner extends StatelessWidget {
  const MoccaSmartPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mocca Smart Planner',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const HomeScreen(),
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
