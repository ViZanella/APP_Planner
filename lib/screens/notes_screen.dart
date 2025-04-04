import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, String>> _notes = []; // Lista para armazenar as notas com categoria
  String _selectedFilter = "Todas"; // Filtro selecionado

  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        String newNote = "";
        String noteCategory = "Geral"; // Categoria padrão

        return AlertDialog(
          title: const Text("Adicionar Nova Anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Digite sua anotação"),
                onChanged: (value) {
                  newNote = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: noteCategory,
                decoration: const InputDecoration(
                  labelText: "Categoria",
                  border: UnderlineInputBorder(), // Mantendo apenas a linha inferior
                ),
                items: ["Geral", "Importante", "Trabalho", "Pessoal"].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  noteCategory = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                if (newNote.isNotEmpty) {
                  setState(() {
                    _notes.add({"nota": newNote, "categoria": noteCategory});
                  });
                }
                Navigator.pop(context);
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
    // Filtra as notas com base na categoria selecionada
    List<Map<String, String>> filteredNotes = _selectedFilter == "Todas"
        ? _notes
        : _notes.where((note) => note["categoria"] == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas e Anotações"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewNote,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro sobre o título, agora com apenas a linha inferior
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: "Filtrar por categoria",
                border: UnderlineInputBorder(), // Apenas a linha inferior
              ),
              items: ["Todas", "Importante", "Trabalho", "Pessoal"].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),
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
