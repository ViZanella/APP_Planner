import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, String>> _events = [];

  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late Box _eventsBox;

  @override
  void initState() {
    super.initState();
    _abrirHive();
  }

  Future<void> _abrirHive() async {
    _eventsBox = await Hive.openBox('calendarEventsBox');
    final dadosSalvos = _eventsBox.get('eventos');
    if (dadosSalvos != null) {
      setState(() {
        _events.addAll(List<Map<String, String>>.from(dadosSalvos));
      });
    }
  }

  void _salvarHive() {
    _eventsBox.put('eventos', _events);
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adicionar Evento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(labelText: "Evento"),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Data (DD/MM/AAAA)"),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: "Hora (HH:MM)"),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Local"),
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
              if (_eventController.text.isNotEmpty &&
                  _dateController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty &&
                  _locationController.text.isNotEmpty) {
                setState(() {
                  _events.add({
                    "event": _eventController.text,
                    "date": _dateController.text,
                    "time": _timeController.text,
                    "location": _locationController.text,
                  });
                  _salvarHive();
                });
                _eventController.clear();
                _dateController.clear();
                _timeController.clear();
                _locationController.clear();
                Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('Calendário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _events.isEmpty
                ? const Center(child: Text("Nenhum evento adicionado"))
                : ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return ListTile(
                        title: Text(event["event"] ?? "Evento sem nome"),
                        subtitle: Text(
                          "${event["date"]} às ${event["time"]} - ${event["location"]}",
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
