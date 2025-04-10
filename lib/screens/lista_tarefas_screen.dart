// Importa os componentes principais do Flutter para construção da UI
import 'package:flutter/material.dart';

// Widget principal da tela que recebe uma lista (com nome, categoria e tarefas)
class ListaTarefasScreen extends StatefulWidget {
  final Map<String, dynamic> lista;

  // Construtor que exige o parâmetro "lista"
  const ListaTarefasScreen({super.key, required this.lista});

  @override
  State<ListaTarefasScreen> createState() => _ListaTarefasScreenState();
}

// Classe de estado que gerencia as tarefas da lista
class _ListaTarefasScreenState extends State<ListaTarefasScreen> {
  // Lista local de tarefas (cada tarefa é um Map com descrição e status)
  late List<Map<String, dynamic>> _tarefas;

  // Método chamado ao iniciar a tela
  @override
  void initState() {
    super.initState();
    // Copia a lista de tarefas recebida como parâmetro para a variável local
    _tarefas = List<Map<String, dynamic>>.from(widget.lista["tarefas"] ?? []);
  }

  // Método para adicionar uma nova tarefa à lista
  void _adicionarTarefa() {
    TextEditingController controller = TextEditingController();

    // Mostra um diálogo com um campo de texto para adicionar a nova tarefa
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Tarefa"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Descrição da tarefa"),
        ),
        actions: [
          // Botão para cancelar a adição
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          // Botão para confirmar e adicionar a nova tarefa
          ElevatedButton(
            onPressed: () {
              final descricao = controller.text.trim();
              if (descricao.isNotEmpty) {
                setState(() {
                  // Adiciona uma nova tarefa com status "não feita"
                  _tarefas.add({"descricao": descricao, "feito": false});
                });
              }
              Navigator.pop(context); // Fecha o diálogo
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Intercepta o botão de voltar para retornar os dados atualizados
      onWillPop: () async {
        // Retorna os dados atualizados para a tela anterior
        Navigator.pop(context, {
          "nome": widget.lista["nome"],
          "categoria": widget.lista["categoria"],
          "tarefas": _tarefas,
        });
        return false; // Impede o pop automático (já foi feito manualmente)
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lista["nome"]), // Nome da lista
          actions: [
            // Botão de "+" para adicionar nova tarefa
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _adicionarTarefa,
            ),
          ],
        ),

        // Corpo da tela
        body: _tarefas.isEmpty
            // Se não há tarefas, mostra mensagem central
            ? const Center(child: Text("Nenhuma tarefa nesta lista"))
            : ListView.builder(
                itemCount: _tarefas.length, // Número de tarefas
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];

                  // Para cada tarefa, exibe uma CheckboxListTile
                  return CheckboxListTile(
                    title: Text(tarefa["descricao"]), // Descrição da tarefa
                    value: tarefa["feito"], // Status (feito ou não)
                    onChanged: (value) {
                      setState(() {
                        tarefa["feito"] = value; // Atualiza o status
                      });
                    },
                    secondary: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _tarefas.removeAt(index); // Remove a tarefa
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
