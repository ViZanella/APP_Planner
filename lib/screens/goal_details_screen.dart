import 'package:flutter/material.dart';

// Tela de detalhes de uma meta específica (goal)
class GoalDetailsScreen extends StatefulWidget {
  final Map<String, String> goal; // Recebe os dados da meta (nome, tipo, status, etc.)

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late String _status; // Armazena o status atual da meta
  String _selectedAplicacao = "Mensal"; // Frequência de acompanhamento
  String _selectedMes = "Mês 1"; // Mês atual selecionado
  final TextEditingController _notesController = TextEditingController(); // Controller do campo de texto (detalhes da meta)

  // Armazena os checklists associados a cada mês (ex: {"Mês 1": [{"descricao": "Estudar Flutter", "feito": false}]})
  final Map<String, List<Map<String, dynamic>>> _checklistsPorMes = {};

  @override
  void initState() {
    super.initState();
    _status = widget.goal["status"] ?? "Não iniciada"; // Inicializa o status com o valor da meta recebida
  }

  // Retorna a quantidade de meses com base na aplicação escolhida
  int _getMesCount(String aplicacao) {
    switch (aplicacao) {
      case "Mensal": return 12;
      case "Bimestral": return 6;
      case "Trimestral": return 4;
      case "Semestral": return 2;
      case "Anual": return 1;
      default: return 0;
    }
  }

  // Adiciona um novo item ao checklist de um mês específico
  void _adicionarItemChecklist(String mes) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Adicionar item para $mes"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Descrição do item"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final descricao = controller.text.trim();
              if (descricao.isNotEmpty) {
                setState(() {
                  _checklistsPorMes.putIfAbsent(mes, () => []);
                  _checklistsPorMes[mes]!.add({
                    "descricao": descricao,
                    "feito": false,
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

  @override
  Widget build(BuildContext context) {
    // Gera os nomes dos meses com base na aplicação (frequência)
    final int mesCount = _getMesCount(_selectedAplicacao);
    final List<String> meses = List.generate(mesCount, (index) => "Mês ${index + 1}");

    // Garante que o mês selecionado ainda existe
    if (!meses.contains(_selectedMes)) {
      _selectedMes = meses.first;
    }

    // Recupera o checklist do mês atual
    final checklistAtual = _checklistsPorMes[_selectedMes] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Meta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Nome da meta
              Text(
                widget.goal["goal"]!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // Tipo da meta
              Text(widget.goal["type"] ?? "", style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 20),

              // Campo para anotações ou descrição da meta
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Detalhes da meta",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Dropdown para selecionar o status atual da meta
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Status"),
                items: ["Não iniciada", "Em progresso", "Concluída"]
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Dropdown para selecionar a aplicação (frequência)
              DropdownButtonFormField<String>(
                value: _selectedAplicacao,
                decoration: const InputDecoration(labelText: "Aplicação"),
                items: ["Mensal", "Bimestral", "Trimestral", "Semestral", "Anual"]
                    .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAplicacao = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Dropdown de mês + botão para adicionar item
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMes,
                      decoration: const InputDecoration(labelText: "Mês"),
                      items: meses
                          .map((mes) => DropdownMenuItem(value: mes, child: Text(mes)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMes = value!;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                    tooltip: "Adicionar item ao mês selecionado",
                    onPressed: () => _adicionarItemChecklist(_selectedMes),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Exibe a checklist atual, se houver
              if (checklistAtual.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Check List",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: checklistAtual.map((item) {
                          return Row(
                            children: [
                              // Descrição do item
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                                  child: Text(item["descricao"]),
                                ),
                              ),
                              // Checkbox de conclusão
                              Expanded(
                                flex: 1,
                                child: Checkbox(
                                  value: item["feito"],
                                  onChanged: (value) {
                                    setState(() {
                                      item["feito"] = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              // Botão para salvar alterações e retornar à tela anterior
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      "status": _status,
                      "notes": _notesController.text,
                      "aplicacao": _selectedAplicacao,
                      "mes": _selectedMes,
                      "checklists": _checklistsPorMes,
                    });
                  },
                  child: const Text("Salvar Alterações"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
