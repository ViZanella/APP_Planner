// Importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:planer/screens/monthly_expense_screen.dart';

// Tela principal de gestão de despesas mensais
class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // Lista que armazena os meses registrados pelo usuário
  List<String> _registeredMonths = [];

  // Mês atualmente selecionado no dropdown
  String? _selectedMonth;

  // Função para adicionar um novo mês/ano ao histórico
  void _addNewMonth() {
    showDialog(
      context: context,
      builder: (context) {
        String newMonth = "";
        String newYear = "";

        return AlertDialog(
          title: const Text("Novo Controle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo para inserir o mês
              TextField(
                decoration: const InputDecoration(hintText: "Mês"),
                onChanged: (value) => newMonth = value,
              ),
              // Campo para inserir o ano
              TextField(
                decoration: const InputDecoration(hintText: "Ano"),
                keyboardType: TextInputType.number,
                onChanged: (value) => newYear = value,
              ),
            ],
          ),
          actions: [
            // Botão para cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            // Botão para salvar o novo mês/ano
            TextButton(
              onPressed: () {
                if (newMonth.isNotEmpty && newYear.isNotEmpty) {
                  setState(() {
                    _registeredMonths.add("$newMonth $newYear");
                  });
                }
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  // Função para navegar para a tela de despesas mensais com base no mês selecionado
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
      // AppBar com título e botão para adicionar novo mês
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
            // Dropdown para o usuário selecionar um mês registrado
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
                      // Ao selecionar um mês, navega automaticamente para a tela correspondente
                      if (value != null) _navigateToMonth(value);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Lista de cartões com os meses já registrados
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
                      // Ao clicar em um dos itens, navega para a tela do mês correspondente
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
