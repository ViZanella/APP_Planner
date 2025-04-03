import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Map<String, String>> _goals = [];

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = "";
        String deadline = "";
        String goalType = "Curto Prazo"; // Valor padrão

        return AlertDialog(
          title: const Text("Adicionar Nova Meta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Nome da meta"),
                onChanged: (value) {
                  newGoal = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: "Prazo de conclusão"),
                onChanged: (value) {
                  deadline = value;
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
                if (newGoal.isNotEmpty && deadline.isNotEmpty) {
                  setState(() {
                    _goals.add({
                      "goal": newGoal,
                      "deadline": deadline,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Metas",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _goals.isEmpty
                ? const Center(child: Text("Nenhuma meta adicionada"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListTile(
                          title: Text(goal["goal"]!),
                          subtitle: Text("${goal["type"]} - Prazo: ${goal["deadline"]!}"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            // Aqui no futuro será direcionado para outra tela de controle detalhado
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: _addNewGoal,
        ),
      ),
    );
  }
}
