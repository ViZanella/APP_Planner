import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<String> _goals = [];

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = "";
        return AlertDialog(
          title: const Text("Adicionar Nova Meta"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Digite o nome da meta"),
            onChanged: (value) {
              newGoal = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                if (newGoal.isNotEmpty) {
                  setState(() {
                    _goals.add(newGoal);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Metas")),
      body: _goals.isEmpty
          ? const Center(child: Text("Nenhuma meta adicionada"))
          : ListView.builder(
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star_border),
                  title: Text(_goals[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _goals.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGoal,
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}