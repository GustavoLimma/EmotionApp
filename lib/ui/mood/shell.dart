import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mood/Dashboard_View.dart';
import '../mood/MoodView.dart';
import '../mood/Tips_View.dart';
import 'shellviewmodel.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de telas criada dentro do build
    final List<Widget> screens = [
      DashboardView(),
      MoodView(),
      TipsView(),
    ];

    return Consumer<ShellViewModel>(
      builder: (context, shellVM, child) {
        return Scaffold(
          body: screens[shellVM.currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: shellVM.currentIndex,
            onDestinationSelected: shellVM.changeIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.mood),
                label: 'Humor',
              ),
              NavigationDestination(
                icon: Icon(Icons.lightbulb),
                label: 'Dicas',
              ),
            ],
          ),
        );
      },
    );
  }
}
