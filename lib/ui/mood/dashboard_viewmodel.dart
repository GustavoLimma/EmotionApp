import 'package:flutter/material.dart';

enum DashboardPeriod { weekly, monthly }

class DashboardViewModel extends ChangeNotifier {
  DashboardPeriod period = DashboardPeriod.weekly;

  // Dados dos gráficos
  List<double>? lineChartData;
  Map<String, double>? pieChartData;

  // Widgets dos gráficos (você vai trocar depois pelo charts_flutter / fl_chart)
  Widget? get lineChartWidget {
    if (lineChartData == null) return null;
    return const Text("Gráfico de Linha (placeholder)");
  }

  Widget? get pieChartWidget {
    if (pieChartData == null) return null;
    return const Text("Gráfico de Pizza (placeholder)");
  }

  // Texto dos padrões
  String get patternText => "Nenhum padrão identificado ainda.";

  // Trocar semanal <-> mensal
  void changePeriod(DashboardPeriod newPeriod) {
    period = newPeriod;
    notifyListeners();
  }
}
