import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, String>> _notes = [];
  String _selectedFilter = "Todas";

  late Box _notesBox;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Carrega as notas salvas no Hive
  Future<void> _loadNotes() async {
    _notesBox = await Hive.openBox('notesBox');
    final data = _notesBox.get('notesList', defaultValue: []);
    setState(() {
      _notes = List<Map<String, String>>.from(data);
    });
  }

  // Salva a lista de notas no Hive
  void _saveNotes() {
    _notesBox.put('notesList', _notes);
  }

  // Adiciona nova nota
  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        String newNote = "";
        String noteCategory = "Geral";

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
                  border: UnderlineInputBorder(),
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                if (newNote.isNotEmpty) {
                  setState(() {
                    _notes.add({"nota": newNote, "categoria": noteCategory});
                    _saveNotes(); // Salva após adicionar
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: "Filtrar por categoria",
                border: UnderlineInputBorder(),
              ),
              items: ["Todas", "Geral", "Importante", "Trabalho", "Pessoal"]
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
                                _saveNotes(); // Salva após remover
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
