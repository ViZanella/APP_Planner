import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Map<String, String>> _goals = [];
  String _selectedFilter = "Todas";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredGoals = _goals.where((goal) {
      if (_selectedFilter == "Todas") return true;
      return goal["status"] == _selectedFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestão de Metas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
              items: ["Todas", "Concluídas", "Em andamento", "Não iniciadas"]
                  .map((filter) => DropdownMenuItem(value: filter, child: Text(filter)))
                  .toList(),
              decoration: const InputDecoration(
                labelText: "Filtrar Metas",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredGoals.isEmpty
                ? const Center(child: Text("Nenhuma meta adicionada"))
                : ListView.builder(
                    itemCount: filteredGoals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(filteredGoals[index]["goal"]!),
                          subtitle: Text(
                              "Prazo: ${filteredGoals[index]["deadline"]!} | ${filteredGoals[index]["type"]}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                            onPressed: () {
                              // Aqui irá a navegação para a tela de controle detalhado da meta
                            },
                          ),
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
