import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final String route;

  const MenuButton({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(title),
      ),
    );
  }
}
