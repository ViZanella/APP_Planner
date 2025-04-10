// Importa os componentes visuais e funcionais do Flutter
import 'package:flutter/material.dart';

// Tela principal de anotações
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Lista de anotações, cada uma com seu texto e categoria
  List<Map<String, String>> _notes = [];

  // Categoria selecionada no filtro. "Todas" é o valor padrão.
  String _selectedFilter = "Todas";

  // Método para exibir o modal de adicionar nova anotação
  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        String newNote = "";              // Texto da anotação
        String noteCategory = "Geral";    // Categoria padrão ao criar uma nova

        return AlertDialog(
          title: const Text("Adicionar Nova Anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto para digitar a anotação
              TextField(
                autofocus: true,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Digite sua anotação"),
                onChanged: (value) {
                  newNote = value;
                },
              ),
              const SizedBox(height: 10),
              // Dropdown para escolher a categoria da anotação
              DropdownButtonFormField<String>(
                value: noteCategory,
                decoration: const InputDecoration(
                  labelText: "Categoria",
                  border: UnderlineInputBorder(), // Exibe apenas a linha inferior
                ),
                items: ["Geral", "Importante", "Trabalho", "Pessoal"]
                    .map((String category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  noteCategory = value!;
                },
              ),
            ],
          ),
          actions: [
            // Botão "Cancelar"
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            // Botão "Salvar"
            TextButton(
              onPressed: () {
                if (newNote.isNotEmpty) {
                  setState(() {
                    // Adiciona a nova anotação à lista
                    _notes.add({"nota": newNote, "categoria": noteCategory});
                  });
                }
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aplica o filtro selecionado às anotações
    List<Map<String, String>> filteredNotes = _selectedFilter == "Todas"
        ? _notes
        : _notes.where((note) => note["categoria"] == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas e Anotações"),
        actions: [
          // Botão "+" na AppBar para adicionar nova anotação
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewNote,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro de categorias (Dropdown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: "Filtrar por categoria",
                border: UnderlineInputBorder(), // Visual leve com apenas a linha inferior
              ),
              items: ["Todas", "Importante", "Trabalho", "Pessoal"]
                  .map((String category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),
          // Lista de anotações (com ou sem filtro)
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text("Nenhuma anotação adicionada"))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.note),
                          title: Text(filteredNotes[index]["nota"]!),
                          subtitle: Text("Categoria: ${filteredNotes[index]["categoria"]}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                // Remove a anotação da lista original
                                _notes.remove(filteredNotes[index]);
                              });
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
