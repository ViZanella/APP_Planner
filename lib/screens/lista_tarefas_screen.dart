import 'package:flutter/material.dart';

class ListaTarefasScreen extends StatefulWidget {
  final Map<String, dynamic> lista;

  const ListaTarefasScreen({super.key, required this.lista});

  @override
  State<ListaTarefasScreen> createState() => _ListaTarefasScreenState();
}

class _ListaTarefasScreenState extends State<ListaTarefasScreen> {
  late List<Map<String, dynamic>> _tarefas;

  @override
  void initState() {
    super.initState();
    _tarefas = List<Map<String, dynamic>>.from(widget.lista["tarefas"] ?? []);
  }

  void _adicionarTarefa() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Tarefa"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Descrição da tarefa"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final descricao = controller.text.trim();
              if (descricao.isNotEmpty) {
                setState(() {
                  _tarefas.add({"descricao": descricao, "feito": false});
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          "nome": widget.lista["nome"],
          "categoria": widget.lista["categoria"],
          "tarefas": _tarefas,
        });
        return false; // Interrompe o pop automático
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lista["nome"]),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _adicionarTarefa,
            ),
          ],
        ),
        body: _tarefas.isEmpty
            ? const Center(child: Text("Nenhuma tarefa nesta lista"))
            : ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  return CheckboxListTile(
                    title: Text(tarefa["descricao"]),
                    value: tarefa["feito"],
                    onChanged: (value) {
                      setState(() {
                        tarefa["feito"] = value;
                      });
                    },
                    secondary: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _tarefas.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
