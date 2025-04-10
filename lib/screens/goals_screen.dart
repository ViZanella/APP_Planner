import 'package:flutter/material.dart';
import 'package:planer/screens/goal_details_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Map<String, String>> _goals = [];
  String _selectedFilter = "Todas";

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = "";
        String goalType = "Curto Prazo"; // Valor padrão

        return AlertDialog(
          title: const Text("Nova Meta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Descrição"),
                onChanged: (value) {
                  newGoal = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: goalType,
                items: ["Curto Prazo", "Médio Prazo", "Longo Prazo"]
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  goalType = value!;
                },
                decoration: const InputDecoration(labelText: "Tipo da Meta"),
              ),
            ],
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
                    _goals.add({
                      "goal": newGoal,
                      "type": goalType,
                      "status": "Não iniciada",
                    });
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

  List<Map<String, String>> _filteredGoals() {
    if (_selectedFilter == "Todas") return _goals;
    return _goals.where((goal) => goal["status"] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metas"),
        actions: [
          // Ícone de Adicionar Nova Meta
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewGoal,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: _selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                    items: ["Todas", "Não iniciada", "Em progresso", "Concluída"]
                        .map((filter) => DropdownMenuItem(
                              value: filter,
                              child: Text(filter),
                            ))
                        .toList(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    dropdownColor: Colors.white,
                  ),
                  const Divider(height: 1, thickness: 1),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredGoals().isEmpty
                ? const Center(child: Text("Nenhuma meta adicionada"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredGoals().length,
                    itemBuilder: (context, index) {
                      final goal = _filteredGoals()[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.flag),
                          title: Text(goal["goal"]!),
                          subtitle: Text("Prazo: ${goal["type"]}"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            final result = await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => GoalDetailsScreen(goal: goal),
                             ),
                           );
                          if (result != null) {
                            setState(() {
                             goal["status"] = result["status"];
                            });
                           }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
