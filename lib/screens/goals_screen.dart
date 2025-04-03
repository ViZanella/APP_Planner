import 'package:flutter/material.dart';

class GoalDetailsScreen extends StatefulWidget {
  final String goalType;

  const GoalDetailsScreen({super.key, required this.goalType});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  List<Map<String, dynamic>> _goals = [];
  
  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = "";
        String deadline = "";
        String status = "Não iniciada";
        IconData selectedIcon = Icons.star;
        
        // Lista de ícones disponíveis para seleção
        List<IconData> availableIcons = [
          Icons.star, Icons.favorite, Icons.attach_money, 
          Icons.home, Icons.car_rental, Icons.school, 
          Icons.fitness_center, Icons.local_hospital,
          Icons.flight_takeoff, Icons.sports
        ];

        return AlertDialog(
          title: const Text("Adicionar Nova Meta"),
          content: SingleChildScrollView(
            child: Column(
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
                  value: status,
                  items: ["Não iniciada", "Em andamento", "Concluída"]
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    status = value!;
                  },
                  decoration: const InputDecoration(labelText: "Status da Meta"),
                ),
                const SizedBox(height: 16),
                const Text("Selecione um ícone para sua meta:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: availableIcons.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          selectedIcon = availableIcons[index];
                          Navigator.of(context).pop();
                          
                          // Reabrir o diálogo para manter os dados e atualizar o ícone selecionado
                          _addNewGoal();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(availableIcons[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
                      "status": status,
                      "icon": selectedIcon,
                      "completed": false
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

  void _deleteGoal(int index) {
    setState(() {
      _goals.removeAt(index);
    });
  }

  void _toggleGoalCompletion(int index) {
    setState(() {
      _goals[index]["completed"] = !_goals[index]["completed"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalType),
      ),
      body: _goals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flag_outlined, size: 60, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    "Nenhuma meta adicionada para ${widget.goalType}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: _goals[index]["completed"],
                      onChanged: (_) => _toggleGoalCompletion(index),
                    ),
                    title: Text(
                      _goals[index]["goal"]!,
                      style: TextStyle(
                        decoration: _goals[index]["completed"] 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text("Prazo: ${_goals[index]["deadline"]!}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_goals[index]["status"]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _goals[index]["status"]!,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getTextColor(_goals[index]["status"]!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(_goals[index]["icon"] ?? Icons.star),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteGoal(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
  
  Color _getStatusColor(String status) {
    switch (status) {
      case "Não iniciada":
        return Colors.grey.shade300;
      case "Em andamento":
        return Colors.amber.shade200;
      case "Concluída":
        return Colors.green.shade200;
      default:
        return Colors.grey.shade300;
    }
  }
  
  Color _getTextColor(String status) {
    switch (status) {
      case "Não iniciada":
        return Colors.black87;
      case "Em andamento":
        return Colors.black87;
      case "Concluída":
        return Colors.black87;
      default:
        return Colors.black87;
    }
  }
}