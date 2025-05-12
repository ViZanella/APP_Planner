import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MonthlyExpenseScreen extends StatefulWidget {
  final String monthYear;

  const MonthlyExpenseScreen({super.key, required this.monthYear});

  @override
  State<MonthlyExpenseScreen> createState() => _MonthlyExpenseScreenState();
}

class _MonthlyExpenseScreenState extends State<MonthlyExpenseScreen> {
  double _initialBalance = 0.0;
  double _income = 0.0;
  double _totalExpenses = 0.0;

  List<Map<String, dynamic>> _entries = [];
  List<Map<String, dynamic>> _expenses = [];

  bool _showEntries = false;
  bool _showExpenses = false;

  Box? _financeBox;

  double get _netBalance => _initialBalance + _income - _totalExpenses;

  @override
  void initState() {
    super.initState();
    _loadFromHive();
  }

  void _loadFromHive() async {
    final boxName = 'finance_${widget.monthYear.replaceAll(' ', '_')}';
    _financeBox = await Hive.openBox(boxName);

    setState(() {
      _initialBalance = _financeBox?.get('initialBalance', defaultValue: 0.0) ?? 0.0;
      _income = _financeBox?.get('income', defaultValue: 0.0) ?? 0.0;
      _totalExpenses = _financeBox?.get('totalExpenses', defaultValue: 0.0) ?? 0.0;
      _entries = List<Map<String, dynamic>>.from(
        _financeBox?.get('entries', defaultValue: []) ?? [],
      );
      _expenses = List<Map<String, dynamic>>.from(
        _financeBox?.get('expenses', defaultValue: []) ?? [],
      );
    });
  }

  void _saveToHive() {
    _financeBox?.put('initialBalance', _initialBalance);
    _financeBox?.put('income', _income);
    _financeBox?.put('totalExpenses', _totalExpenses);
    _financeBox?.put('entries', _entries);
    _financeBox?.put('expenses', _expenses);
  }

  void _addInitialBalance() {
    double amount = 0.0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Saldo Inicial"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Valor"),
            onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            TextButton(
              onPressed: () {
                setState(() {
                  _initialBalance = amount;
                  _saveToHive();
                });
                Navigator.pop(context);
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  void _addIncome() {
    String source = "Salário";
    double amount = 0.0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Entrada"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Valor"),
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              DropdownButtonFormField<String>(
                value: source,
                decoration: const InputDecoration(labelText: "Origem"),
                items: ["Salário", "Investimentos", "Outros"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) source = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            TextButton(
              onPressed: () {
                if (amount > 0) {
                  setState(() {
                    _entries.add({"amount": amount, "source": source});
                    _income += amount;
                    _saveToHive();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  void _addExpense() {
    String description = "";
    double amount = 0.0;
    String category = "Necessário";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Despesa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Descrição"),
                onChanged: (value) => description = value,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Valor"),
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: "Categoria"),
                items: ["Fixo", "Necessário", "Supérfluo"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) category = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            TextButton(
              onPressed: () {
                if (description.isNotEmpty && amount > 0) {
                  setState(() {
                    _expenses.add({"desc": description, "amount": amount, "category": category});
                    _totalExpenses += amount;
                    _saveToHive();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text("Adicionar Saldo Inicial"),
            onTap: () {
              Navigator.pop(context);
              _addInitialBalance();
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text("Adicionar Entrada"),
            onTap: () {
              Navigator.pop(context);
              _addIncome();
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Adicionar Despesa"),
            onTap: () {
              Navigator.pop(context);
              _addExpense();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, double value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("R\$ ${value.toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Row(
      children: headers
          .map((h) => Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTableRow(List<String> values) {
    return Row(
      children: values
          .map((v) => Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text(v),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestão Financeira - ${widget.monthYear}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildInfoCard("Saldo Inicial", _initialBalance),
            _buildInfoCard("Valor de Entrada", _income, onTap: () {
              setState(() => _showEntries = !_showEntries);
            }),
            if (_showEntries) ...[
              _buildTableHeader(["Origem", "Valor"]),
              ..._entries.map((e) => _buildTableRow([
                    e["source"],
                    "R\$ ${e["amount"].toStringAsFixed(2)}"
                  ])),
            ],
            _buildInfoCard("Total de Saída", _totalExpenses, onTap: () {
              setState(() => _showExpenses = !_showExpenses);
            }),
            if (_showExpenses) ...[
              _buildTableHeader(["Descrição", "Categoria", "Valor"]),
              ..._expenses.map((e) => _buildTableRow([
                    e["desc"],
                    e["category"],
                    "R\$ ${e["amount"].toStringAsFixed(2)}"
                  ])),
            ],
            _buildInfoCard("Valor Líquido", _netBalance),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
    );
  }
}
