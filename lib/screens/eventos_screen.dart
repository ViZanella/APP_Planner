import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  String _selectedArea = "Todas";
  final List<String> _areas = ["Todas", "Saúde", "Trabalho", "Lazer", "Escolar"];
  List<Map<String, String>> _eventos = [];
  late Box _eventosBox;

  @override
  void initState() {
    super.initState();
    _abrirHive();
  }

  Future<void> _abrirHive() async {
    _eventosBox = await Hive.openBox('eventosBox');
    final dados = _eventosBox.get('eventos');
    if (dados != null) {
      setState(() {
        _eventos = List<Map<String, String>>.from(dados);
      });
    }
  }

  void _salvarHive() {
    _eventosBox.put('eventos', _eventos);
  }

  void _adicionarEvento() {
    String descricao = "";
    String areaSelecionada = _areas[1]; // Padrão "Saúde"

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Novo Evento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(labelText: "Descrição do evento"),
              onChanged: (value) => descricao = value,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: areaSelecionada,
              decoration: const InputDecoration(labelText: "Área"),
              items: _areas.where((a) => a != "Todas").map((area) {
                return DropdownMenuItem(value: area, child: Text(area));
              }).toList(),
              onChanged: (value) {
                if (value != null) areaSelecionada = value;
              },
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
              if (descricao.isNotEmpty) {
                setState(() {
                  _eventos.add({"event": descricao, "area": areaSelecionada});
                  _salvarHive();
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventosFiltrados = _selectedArea == "Todas"
        ? _eventos
        : _eventos.where((e) => e["area"] == _selectedArea).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos Agendados"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Adicionar Evento",
            onPressed: _adicionarEvento,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedArea,
              decoration: const InputDecoration(labelText: "Filtrar por Área"),
              items: _areas.map((area) {
                return DropdownMenuItem(value: area, child: Text(area));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedArea = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: eventosFiltrados.isEmpty
                ? const Center(child: Text("Nenhum evento encontrado"))
                : ListView.builder(
                    itemCount: eventosFiltrados.length,
                    itemBuilder: (context, index) {
                      final evento = eventosFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(evento["event"] ?? ""),
                          subtitle: Text("Área: ${evento["area"]}"),
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
