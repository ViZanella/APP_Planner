import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> _notes = [];

  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        String newNote = "";
        return AlertDialog(
          title: const Text("Adicionar Nova Anotação"),
          content: TextField(
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Digite sua anotação"),
            onChanged: (value) {
              newNote = value;
            },
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
                    _notes.add(newNote);
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
    return Scaffold(
      appBar: AppBar(title: const Text("Notas e Anotações")),
      body: _notes.isEmpty
          ? const Center(child: Text("Nenhuma anotação adicionada"))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(_notes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _notes.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
