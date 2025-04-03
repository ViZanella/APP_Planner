import 'package:flutter/material.dart';
import 'package:planer/screens/monthly_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<String> _registeredMonths = [];
  String? _selectedMonth;

  void _addNewMonth() {
    showDialog(
      context: context,
      builder: (context) {
        String newMonth = "";
        String newYear = "";
        return AlertDialog(
          title: const Text("Adicionar Novo Mês"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "Mês (Ex: Março)"),
                onChanged: (value) => newMonth = value,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Ano (Ex: 2025)"),
                keyboardType: TextInputType.number,
                onChanged: (value) => newYear = value,
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
                if (newMonth.isNotEmpty && newYear.isNotEmpty) {
                  setState(() {
                    _registeredMonths.add("$newMonth $newYear");
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

void _navigateToMonth(String month) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MonthlyExpenseScreen(monthYear: month),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestão de Despesas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewMonth,
            tooltip: "Adicionar Novo Mês",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu de Seleção de Meses
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedMonth,
                    hint: const Text("Selecione um mês"),
                    isExpanded: true,
                    items: _registeredMonths.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value;
                      });
                      if (value != null) _navigateToMonth(value);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Lista de meses já registrados (Histórico)
            Expanded(
              child: ListView.builder(
                itemCount: _registeredMonths.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(_registeredMonths[index]),
                      leading: const Icon(Icons.calendar_month),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _navigateToMonth(_registeredMonths[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
