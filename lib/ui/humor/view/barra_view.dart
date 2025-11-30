// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/humor/view_model/barra_view_model.dart';
import 'package:emotion_app/ui/humor/view/painel_view.dart';
import 'package:emotion_app/ui/humor/view/humor_view.dart';
import 'package:emotion_app/ui/humor/view/dicas_view.dart';
import 'package:emotion_app/ui/humor/view/notificacoes_view.dart';
// import 'firebase_options.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShellViewModel>(
      builder: (context, shellVM, child) {
        final List<Widget> screens = [
          const DashboardView(),
          const MoodView(),
          const TipsView(),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Diário de Humor'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings), // ✅ MUDEI PARA SETTINGS
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // ✅ USE SettingsView QUE JÁ EXISTE
                      builder: (context) => const NotificationsView(),
                    ),
                  );
                },
                tooltip: 'Configurações',
              ),
              IconButton( // ✅ ADICIONE BOTÃO PARA NOTIFICAÇÕES
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsView(),
                    ),
                  );
                },
                tooltip: 'Notificações',
              ),
            ],
          ),

          body: screens[shellVM.currentIndex],

          bottomNavigationBar: NavigationBar(
            selectedIndex: shellVM.currentIndex,
            onDestinationSelected: (i) => shellVM.changeIndexCommand.execute(i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard), 
                label: 'Dashboard'
              ),
              NavigationDestination(
                icon: Icon(Icons.mood), 
                label: 'Humor'
              ),
              NavigationDestination(
                icon: Icon(Icons.lightbulb), 
                label: 'Dicas'
              ),
            ],
          ),
        );
      },
    );
  }
}