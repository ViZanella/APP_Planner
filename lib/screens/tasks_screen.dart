import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<String> _tasks = [];
  String _selectedFilter = "Todas"; // Filtro inicial

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        String newTask = "";
        return AlertDialog(
          title: const Text("Adicionar Nova Tarefa"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Digite o nome da tarefa"),
            onChanged: (value) {
              newTask = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  setState(() {
                    _tasks.add(newTask);
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
        title: const Text("Lista de Tarefas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewTask,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
              items: <String>["Todas", "Pendentes", "Concluídas"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text("Nenhuma tarefa adicionada"))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.check_box_outline_blank),
                        title: Text(_tasks[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _tasks.removeAt(index);
                            });
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
