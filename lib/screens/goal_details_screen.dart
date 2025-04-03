import 'package:flutter/material.dart';

class GoalDetailsScreen extends StatefulWidget {
  final Map<String, String> goal; // Recebe os dados da meta selecionada

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late String _status; // Status atual da meta
  final TextEditingController _notesController = TextEditingController(); // Campo de notas

  @override
  void initState() {
    super.initState();
    _status = widget.goal["status"] ?? "Não iniciada"; // Define status inicial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Meta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.goal["goal"]!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Tipo: ${widget.goal["type"]}"),
            const SizedBox(height: 10),
            if (widget.goal["deadline"] != null) 
                 Text("Prazo: ${widget.goal["deadline"]}"),

            const SizedBox(height: 20),
            
            // Dropdown para alterar o status
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: "Status"),
              items: ["Não iniciada", "Em progresso", "Concluída"]
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Campo de notas
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Sobre a meta",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Botão de salvar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulação de salvamento (futuramente pode ser armazenado no banco de dados)
                  Navigator.pop(context, {"status": _status, "notes": _notesController.text});
                },
                child: const Text("Salvar Alterações"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
