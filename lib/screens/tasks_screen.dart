import 'package:flutter/material.dart';
import 'lista_tarefas_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Map<String, dynamic>> _listas = [];

  void _criarNovaLista() {
    String nomeLista = "";
    String categoriaSelecionada = "Estudos";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nova Lista de Tarefas"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Descrição"),
                onChanged: (value) => nomeLista = value,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                decoration: const InputDecoration(labelText: "Categoria"),
                items: ["Estudos", "Financeiro", "Trabalho", "Bem Estar", "Compras"]
                    .map((categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                onChanged: (value) => categoriaSelecionada = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomeLista.trim().isNotEmpty) {
                  setState(() {
                    _listas.add({
                      "nome": nomeLista.trim(),
                      "categoria": categoriaSelecionada,
                      "tarefas": [],
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Criar"),
            ),
          ],
        );
      },
    );
  }

  void _abrirLista(Map<String, dynamic> lista) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListaTarefasScreen(lista: lista),
      ),
    ).then((listaAtualizada) {
      if (listaAtualizada != null) {
        setState(() {
          final index = _listas.indexOf(lista);
          _listas[index] = listaAtualizada;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listas de Tarefa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _criarNovaLista,
          ),
        ],
      ),
      body: _listas.isEmpty
          ? const Center(child: Text("Nenhuma lista criada"))
          : ListView.builder(
              itemCount: _listas.length,
              itemBuilder: (context, index) {
                final lista = _listas[index];
                return ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(lista["nome"]),
                  subtitle: Text(lista["categoria"]),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _abrirLista(lista),
                );
              },
            ),
    );
  }
}
