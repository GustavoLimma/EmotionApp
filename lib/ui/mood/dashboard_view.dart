// ALTERNATIVA - lib/ui/mood/Dashboard_View.dart (com Scroll)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_viewmodel.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard de Humor"),
        centerTitle: true,
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ------------------- FILTRO -------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Semanal"),
                      selected: vm.period == DashboardPeriod.weekly,
                      onSelected: (_) => vm.changePeriod(DashboardPeriod.weekly),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Mensal"),
                      selected: vm.period == DashboardPeriod.monthly,
                      onSelected: (_) => vm.changePeriod(DashboardPeriod.monthly),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ------------------- GRÁFICO DE LINHA -------------------
                SizedBox(
                  height: 250, // Altura fixa
                  child: Card(
                    child: Center(
                      child: vm.lineChartData == null
                          ? const Text(
                              "Nenhum dado disponível",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          : vm.lineChartWidget,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------- GRÁFICO DE PIZZA (MAIOR) -------------------
                Card(
                  child: Container(
                    height: 500, // Altura maior para o gráfico de pizza
                    padding: const EdgeInsets.all(16),
                    child: vm.pieChartData == null
                        ? const Center(
                            child: Text(
                              "Nenhum dado disponível",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : vm.pieChartWidget,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}