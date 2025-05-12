import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GoalDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late String _status;
  String _selectedAplicacao = "Mensal";
  String _selectedMes = "Mês 1";
  int _quantidadeAplicacao = 1;
  final TextEditingController _notesController = TextEditingController();
  final Map<String, List<Map<String, dynamic>>> _checklistsPorMes = {};

  late Box goalBox;

  @override
  void initState() {
    super.initState();
    _status = widget.goal["status"] ?? "Não iniciada";
    _notesController.text = widget.goal["notes"] ?? "";

    goalBox = Hive.box('goalsBox');

    // Recupera os dados salvos se houver
    final savedGoal = goalBox.get(widget.goal["id"]);
    if (savedGoal != null) {
      _status = savedGoal["status"] ?? _status;
      _selectedAplicacao = savedGoal["aplicacao"] ?? _selectedAplicacao;
      _quantidadeAplicacao = savedGoal["quantidade"] ?? _quantidadeAplicacao;
      _notesController.text = savedGoal["notes"] ?? "";
      _checklistsPorMes.addAll(Map<String, List<Map<String, dynamic>>>.from(savedGoal["checklists"] ?? {}));
    }
  }

  int _getTotalPeriodos() {
    switch (_selectedAplicacao) {
      case "Mensal":
        return 1 * _quantidadeAplicacao;
      case "Bimestral":
        return 2 * _quantidadeAplicacao;
      case "Trimestral":
        return 3 * _quantidadeAplicacao;
      case "Semestral":
        return 6 * _quantidadeAplicacao;
      case "Anual":
        return 12 * _quantidadeAplicacao;
      default:
        return 0;
    }
  }

  List<String> _gerarMeses() {
    int totalMeses = _getTotalPeriodos();
    return List.generate(totalMeses, (index) => "Mês ${index + 1}");
  }

  void _adicionarItemChecklist(String mes) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Novo item para $mes"),
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
                  _checklistsPorMes[mes]!.add({"descricao": descricao, "feito": false});
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

  void _salvarDadosHive() {
    goalBox.put(widget.goal["id"], {
      "status": _status,
      "notes": _notesController.text,
      "aplicacao": _selectedAplicacao,
      "quantidade": _quantidadeAplicacao,
      "checklists": _checklistsPorMes,
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> meses = _gerarMeses();
    if (!meses.contains(_selectedMes)) {
      _selectedMes = meses.isNotEmpty ? meses.first : "Mês 1";
    }

    final checklistAtual = _checklistsPorMes[_selectedMes] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Meta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.goal["goal"] ?? "", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.goal["type"] ?? "", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            const Text("Descrição da Meta", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _notesController, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: ["Não iniciada", "Em progresso", "Concluída"]
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (value) => setState(() => _status = value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedAplicacao,
                    decoration: const InputDecoration(labelText: "Aplicação"),
                    items: ["Mensal", "Bimestral", "Trimestral", "Semestral", "Anual"]
                        .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedAplicacao = value!),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    initialValue: _quantidadeAplicacao.toString(),
                    decoration: const InputDecoration(labelText: "Qtd"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _quantidadeAplicacao = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMes,
                    decoration: const InputDecoration(labelText: "Mês"),
                    items: meses
                        .map((mes) => DropdownMenuItem(value: mes, child: Text(mes)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedMes = value!),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _adicionarItemChecklist(_selectedMes),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (checklistAtual.isNotEmpty)
              ...checklistAtual.map((item) => ListTile(
                    title: Text(item["descricao"]),
                    trailing: Checkbox(
                      value: item["feito"],
                      onChanged: (value) {
                        setState(() => item["feito"] = value!);
                      },
                    ),
                  )),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                _salvarDadosHive();
                Navigator.pop(context, {
                  "status": _status,
                  "notes": _notesController.text,
                  "aplicacao": _selectedAplicacao,
                  "quantidade": _quantidadeAplicacao,
                  "checklists": _checklistsPorMes,
                });
              },
              child: const Text("Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}
