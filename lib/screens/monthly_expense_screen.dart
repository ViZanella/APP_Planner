import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> _entries = [];
  final List<Map<String, dynamic>> _expenses = [];

  double get _netBalance => _initialBalance + _income - _totalExpenses;

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
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
        );
      },
    );
  }

  void _addInitialBalance() {
    double amount = 0.0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Saldo Inicial"),
          content: TextField(
            decoration: const InputDecoration(labelText: "Valor"),
            keyboardType: TextInputType.number,
            onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _initialBalance = amount;
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
                decoration: const InputDecoration(labelText: "Valor"),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              DropdownButtonFormField<String>(
                value: source,
                items: ["Salário", "Investimentos", "Outros"].map((String type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  if (value != null) source = value;
                },
                decoration: const InputDecoration(labelText: "Origem"),
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
                if (amount > 0) {
                  setState(() {
                    _entries.add({"amount": amount, "source": source});
                    _income += amount;
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
                decoration: const InputDecoration(labelText: "Valor"),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              DropdownButtonFormField<String>(
                value: category,
                items: ["Fixo", "Necessário", "Supérfluo"].map((String type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  if (value != null) category = value;
                },
                decoration: const InputDecoration(labelText: "Categoria"),
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
                if (description.isNotEmpty && amount > 0) {
                  setState(() {
                    _expenses.add({"desc": description, "amount": amount, "category": category});
                    _totalExpenses += amount;
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

  Widget _buildInfoCard(String label, double value, {bool isEditable = false, Function(String)? onChanged}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            isEditable
                ? SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: const InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      onChanged: onChanged,
                    ),
                  )
                : Text(
                    "R\$ ${value.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestão Financeira - ${widget.monthYear}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard("Saldo Inicial", _initialBalance),
            _buildInfoCard("Valor de Entrada", _income),
            _buildInfoCard("Total de Saída", _totalExpenses),
            _buildInfoCard("Valor Líquido", _netBalance),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  ..._entries.map((entry) => ListTile(
                        title: Text("Entrada: ${entry["source"]}"),
                        trailing: Text("R\$ ${entry["amount"].toStringAsFixed(2)}"),
                      )),
                  ..._expenses.map((expense) => ListTile(
                        title: Text("Despesa: ${expense["desc"]}"),
                        subtitle: Text("Categoria: ${expense["category"]}"),
                        trailing: Text("R\$ ${expense["amount"].toStringAsFixed(2)}"),
                      )),
                ],
              ),
            ),
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
