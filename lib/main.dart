// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/mood/shellviewmodel.dart';
import 'ui/mood/dashboard_viewmodel.dart';
import 'ui/mood/mood_viewmodel.dart';
import 'ui/mood/dashboard_view.dart';
import 'ui/mood/MoodView.dart';
import 'ui/mood/tips_view.dart';
import 'data/services/mood_service.dart';
import 'data/repositories/mood_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Serviços compartilhados
        Provider(create: (_) => MoodService()),
        Provider(create: (_) => MoodRepository(MoodService())),
        
        // ViewModels
        ChangeNotifierProvider(create: (_) => ShellViewModel()),
        ChangeNotifierProvider(
          create: (context) => MoodViewModel(
            context.read<MoodRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardViewModel(
            repository: context.read<MoodRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário de Humor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const AppShell(),
    );
  }
}

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
          body: screens[shellVM.currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: shellVM.currentIndex,
            onDestinationSelected: shellVM.changeIndex,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              NavigationDestination(icon: Icon(Icons.mood), label: 'Humor'),
              NavigationDestination(icon: Icon(Icons.lightbulb), label: 'Dicas'),
            ],
          ),
        );
      },
    );
  }
}