// Importa o pacote de widgets do Flutter
import 'package:flutter/material.dart';

// Importa a tela que mostra as tarefas individuais de cada lista
import 'lista_tarefas_screen.dart';

/// Tela principal que exibe as listas de tarefas agrupadas por categorias
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // Lista de mapas contendo as listas de tarefas com nome, categoria e tarefas
  List<Map<String, dynamic>> _listas = [];

  // Categoria atual usada para filtrar a exibição das listas
  String _filtroCategoria = "Todas";

  // Lista de categorias disponíveis (inclusive o filtro "Todas")
  final List<String> _categorias = [
    "Todas",
    "Estudos",
    "Financeiro",
    "Trabalho",
    "Bem-estar",
    "Compras"
  ];

  /// Mostra o diálogo para criar uma nova lista de tarefas
  void _adicionarNovaLista() {
    String nomeLista = ""; // Nome da nova lista
    String categoriaSelecionada = _categorias[1]; // Categoria padrão (Estudos)

    // Abre um AlertDialog com campos para nome e categoria
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Lista de Tarefas"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo para digitar o nome da lista
            TextField(
              decoration: const InputDecoration(hintText: "Nome da lista"),
              onChanged: (value) => nomeLista = value,
            ),
            const SizedBox(height: 10),
            // Dropdown para selecionar a categoria (exclui "Todas")
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
          // Botão para cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          // Botão para adicionar nova lista (se o nome não estiver vazio)
          ElevatedButton(
            onPressed: () {
              if (nomeLista.isNotEmpty) {
                setState(() {
                  _listas.add({
                    "nome": nomeLista,
                    "categoria": categoriaSelecionada,
                    "tarefas": [],
                  });
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

  /// Abre a tela de tarefas individuais de uma lista
  /// e atualiza a lista ao voltar com alterações
  void _abrirLista(Map<String, dynamic> lista) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListaTarefasScreen(lista: lista), // Tela que recebe a lista
      ),
    );

    // Se houver resultado (lista atualizada), substitui a antiga
    if (resultado != null) {
      setState(() {
        final index = _listas.indexWhere(
          (elemento) => elemento["nome"] == resultado["nome"],
        );
        if (index != -1) _listas[index] = resultado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtra as listas de acordo com a categoria selecionada
    final listasFiltradas = _filtroCategoria == "Todas"
        ? _listas
        : _listas.where((l) => l["categoria"] == _filtroCategoria).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listas de Tarefa"),
        actions: [
          // Botão de adicionar nova lista (ícone de "+")
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _adicionarNovaLista,
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown de filtro por categoria
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
              underline: Container(height: 1, color: Colors.grey), // Linha inferior customizada
            ),
          ),

          // Exibição das listas filtradas
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
                        trailing: const Icon(Icons.arrow_forward_ios), // Ícone de navegação
                        onTap: () => _abrirLista(lista), // Abre a lista selecionada
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
