import 'package:flutter/material.dart';

class MonthlyExpenseScreen extends StatefulWidget {
  final String monthYear;

  const MonthlyExpenseScreen({super.key, required this.monthYear});

  @override
  State<MonthlyExpenseScreen> createState() => _MonthlyExpenseScreenState();
}

class _MonthlyExpenseScreenState extends State<MonthlyExpenseScreen> {
  // Variáveis principais
  double _initialBalance = 0.0;
  double _income = 0.0;
  double _totalExpenses = 0.0;

  // Listas para armazenar entradas e despesas
  final List<Map<String, dynamic>> _entries = [];
  final List<Map<String, dynamic>> _expenses = [];

  // Flags para mostrar/ocultar detalhes
  bool _showEntries = false;
  bool _showExpenses = false;

  // Cálculo do valor líquido
  double get _netBalance => _initialBalance + _income - _totalExpenses;

  // Exibe opções de adição no botão flutuante
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

  // Função para adicionar saldo inicial
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

  // Função para adicionar entrada
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
                items: ["Salário", "Investimentos", "Outros"]
                    .map((String type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
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

  // Função para adicionar despesa
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
                items: ["Fixo", "Necessário", "Supérfluo"]
                    .map((String type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
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
                    _expenses.add({
                      "desc": description,
                      "amount": amount,
                      "category": category,
                    });
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

  // Widget para construir cards com informações financeiras
  Widget _buildInfoCard(String label, double value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("R\$ ${value.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  // Cabeçalho da tabela (Entradas ou Despesas)
  Widget _buildTableHeader(List<String> columns) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        children: columns
            .map((col) => Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(col, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Linha da tabela
  Widget _buildTableRow(List<String> values) {
    return Row(
      children: values
          .map((val) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                      right: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
                  child: Text(val),
                ),
              ))
          .toList(),
    );
  }

  // Build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestão Financeira - ${widget.monthYear}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoCard("Saldo Inicial", _initialBalance),
            _buildInfoCard(
              "Valor de Entrada",
              _income,
              onTap: () => setState(() => _showEntries = !_showEntries),
            ),
            if (_showEntries)
              Column(
                children: [
                  _buildTableHeader(["Origem", "Valor"]),
                  ..._entries.map((entry) => _buildTableRow([
                        entry["source"],
                        "R\$ ${entry["amount"].toStringAsFixed(2)}"
                      ])),
                ],
              ),
            _buildInfoCard(
              "Total de Saída",
              _totalExpenses,
              onTap: () => setState(() => _showExpenses = !_showExpenses),
            ),
            if (_showExpenses)
              Column(
                children: [
                  _buildTableHeader(["Descrição", "Categoria", "Valor"]),
                  ..._expenses.map((expense) => _buildTableRow([
                        expense["desc"],
                        expense["category"],
                        "R\$ ${expense["amount"].toStringAsFixed(2)}"
                      ])),
                ],
              ),
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
