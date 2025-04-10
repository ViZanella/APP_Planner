// Importa os pacotes necessários do Flutter e a tela de detalhes da meta
import 'package:flutter/material.dart';
import 'package:planer/screens/goal_details_screen.dart';

// Define o widget com estado para a tela de metas
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  // Lista que armazena as metas criadas
  List<Map<String, String>> _goals = [];

  // Filtro selecionado (ex.: "Todas", "Em progresso", etc.)
  String _selectedFilter = "Todas";

  // Função para exibir o modal de criação de nova meta
  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) {
        String newGoal = "";
        String goalType = "Curto Prazo"; // Tipo padrão de meta

        return AlertDialog(
          title: const Text("Nova Meta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto para descrição da meta
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Descrição"),
                onChanged: (value) {
                  newGoal = value;
                },
              ),
              const SizedBox(height: 10),
              // Dropdown para selecionar o tipo da meta
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
            // Botão para cancelar o cadastro
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            // Botão para adicionar a nova meta à lista
            TextButton(
              onPressed: () {
                if (newGoal.isNotEmpty) {
                  setState(() {
                    _goals.add({
                      "goal": newGoal,
                      "type": goalType,
                      "status": "Não iniciada", // Status inicial
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

  // Função que filtra a lista de metas de acordo com o filtro selecionado
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
          // Ícone de "+" na AppBar para adicionar nova meta
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
                  // Dropdown para filtrar as metas por status
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
            // Se a lista estiver vazia, exibe mensagem
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
                          leading: const Icon(Icons.flag), // Ícone de bandeira
                          title: Text(goal["goal"]!),       // Título da meta
                          subtitle: Text("Prazo: ${goal["type"]}"), // Tipo da meta
                          trailing: const Icon(Icons.arrow_forward_ios),
                          // Ao tocar na meta, vai para a tela de detalhes
                          onTap: () async {
                            final result = await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => GoalDetailsScreen(goal: goal),
                             ),
                           );
                           // Atualiza o status da meta com base na tela de detalhes
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
