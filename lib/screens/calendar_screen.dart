// Importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Tela principal do calendário
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Define o formato atual do calendário (mês, semana, etc.)
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Dia atualmente em foco no calendário
  DateTime _focusedDay = DateTime.now();

  // Dia selecionado pelo usuário
  DateTime? _selectedDay;

  // Lista de eventos adicionados pelo usuário
  final List<Map<String, String>> _events = [];

  // Controladores para os campos do formulário de evento
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Função que mostra o diálogo para adicionar novo evento
  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adicionar Evento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo para nome do evento
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(labelText: "Evento"),
            ),
            // Campo para data do evento
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Data (DD/MM/AAAA)"),
              keyboardType: TextInputType.datetime,
            ),
            // Campo para hora do evento
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: "Hora (HH:MM)"),
              keyboardType: TextInputType.datetime,
            ),
            // Campo para local do evento
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Local"),
            ),
          ],
        ),
        actions: [
          // Botão para cancelar a ação
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          // Botão para salvar o evento na lista
          TextButton(
            onPressed: () {
              // Verifica se todos os campos foram preenchidos
              if (_eventController.text.isNotEmpty &&
                  _dateController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty &&
                  _locationController.text.isNotEmpty) {
                setState(() {
                  // Adiciona o evento à lista
                  _events.add({
                    "event": _eventController.text,
                    "date": _dateController.text,
                    "time": _timeController.text,
                    "location": _locationController.text,
                  });
                });
                // Limpa os campos após salvar
                _eventController.clear();
                _dateController.clear();
                _timeController.clear();
                _locationController.clear();
                Navigator.pop(context); // Fecha o diálogo
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior com título e botão de adicionar
      appBar: AppBar(
        title: const Text('Calendário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      // Corpo principal da tela
      body: Column(
        children: [
          // Widget do calendário
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1), // Primeira data permitida
            lastDay: DateTime.utc(2030, 12, 31), // Última data permitida
            focusedDay: _focusedDay, // Dia em foco
            calendarFormat: _calendarFormat, // Formato atual (mês/semana)
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day), // Dia selecionado
            onDaySelected: (selectedDay, focusedDay) {
              // Atualiza o dia selecionado e o dia em foco
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              // Altera o formato do calendário
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              // Atualiza o mês em foco
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 20),
          // Lista de eventos exibida abaixo do calendário
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event["event"] ?? "Evento sem nome"),
                  subtitle: Text(
                      "${event["date"]} às ${event["time"]} - ${event["location"]}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
