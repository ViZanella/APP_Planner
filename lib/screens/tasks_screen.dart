import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'lista_tarefas_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, dynamic>> _listas = [];
  String _filtroCategoria = "Todas";

  final List<String> _categorias = [
    "Todas",
    "Estudos",
    "Financeiro",
    "Trabalho",
    "Bem-estar",
    "Compras"
  ];

  late Box _taskListsBox;

  @override
  void initState() {
    super.initState();
    _abrirHive();
  }

  Future<void> _abrirHive() async {
    _taskListsBox = await Hive.openBox('taskListsBox');
    final dadosSalvos = _taskListsBox.get('listas');
    if (dadosSalvos != null) {
      setState(() {
        _listas = List<Map<String, dynamic>>.from(dadosSalvos);
      });
    }
  }

  void _salvarHive() {
    _taskListsBox.put('listas', _listas);
  }

  void _adicionarNovaLista() {
    String nomeLista = "";
    String categoriaSelecionada = _categorias[1];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Lista de Tarefas"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Nome da lista"),
              onChanged: (value) => nomeLista = value,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: categoriaSelecionada,
              onChanged: (value) {
                if (value != null) categoriaSelecionada = value;
              },
              items: _categorias
                  .where((c) => c != "Todas")
                  .map((categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: "Categoria"),
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
              if (nomeLista.isNotEmpty) {
                setState(() {
                  _listas.add({
                    "nome": nomeLista,
                    "categoria": categoriaSelecionada,
                    "tarefas": [],
                  });
                  _salvarHive();
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

  void _abrirLista(Map<String, dynamic> lista) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListaTarefasScreen(lista: lista),
      ),
    );

    if (resultado != null) {
      setState(() {
        final index = _listas.indexWhere((e) => e["nome"] == resultado["nome"]);
        if (index != -1) _listas[index] = resultado;
        _salvarHive();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listasFiltradas = _filtroCategoria == "Todas"
        ? _listas
        : _listas.where((l) => l["categoria"] == _filtroCategoria).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listas de Tarefa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _adicionarNovaLista,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: DropdownButton<String>(
              value: _filtroCategoria,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _filtroCategoria = value;
                  });
                }
              },
              items: _categorias
                  .map((categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ))
                  .toList(),
              isExpanded: true,
              underline: Container(height: 1, color: Colors.grey),
            ),
          ),
          Expanded(
            child: listasFiltradas.isEmpty
                ? const Center(child: Text("Nenhuma lista encontrada"))
                : ListView.builder(
                    itemCount: listasFiltradas.length,
                    itemBuilder: (context, index) {
                      final lista = listasFiltradas[index];
                      return ListTile(
                        title: Text(lista["nome"]),
                        subtitle: Text("Categoria: ${lista["categoria"]}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _abrirLista(lista),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
