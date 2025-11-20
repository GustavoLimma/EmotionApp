import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard de Humor"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Tela de Dashboard (vazia)",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
