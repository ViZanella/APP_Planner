// Importa os widgets básicos do Flutter
import 'package:flutter/material.dart';

/// Widget customizado que representa um botão de menu com título e rota de navegação
class MenuButton extends StatelessWidget {
  // Título exibido no botão
  final String title;

  // Nome da rota que será navegada ao clicar no botão
  final String route;

  // Construtor do MenuButton com parâmetros obrigatórios
  const MenuButton({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaçamento vertical entre os botões
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        // Quando o botão for pressionado, navega para a rota especificada
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        // Exibe o título passado no botão
        child: Text(title),
      ),
    );
  }
}
