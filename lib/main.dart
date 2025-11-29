// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ ADICIONE
import 'package:emotion_app/core/di/ConfigureProviders.dart';
import 'package:emotion_app/ui/mood/shellviewmodel.dart';
import 'package:emotion_app/ui/mood/dashboard_view.dart';
import 'package:emotion_app/ui/mood/MoodView.dart';
import 'package:emotion_app/ui/mood/tipsView.dart';
import 'package:emotion_app/ui/mood/settingsView.dart';
import 'package:emotion_app/utils/command.dart';
// import 'firebase_options.dart'; // ✅ MANTENHA (será gerado)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(
    MultiProvider(
      providers: data.providers,
      child: const MyApp(),
    ),
  );
}

// ✅ O RESTO DO SEU CÓDIGO PERMANECE EXATAMENTE IGUAL
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

// AppShell permanece igual

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
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                tooltip: 'Configurações',
              ),
            ],
          ),

          body: screens[shellVM.currentIndex],

          bottomNavigationBar: NavigationBar(
            selectedIndex: shellVM.currentIndex,
            onDestinationSelected: (i) =>
                shellVM.changeIndexCommand.execute(i),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.dashboard), label: 'Dashboard'),
              NavigationDestination(icon: Icon(Icons.mood), label: 'Humor'),
              NavigationDestination(icon: Icon(Icons.lightbulb), label: 'Dicas'),
            ],
          ),
        );
      },
    );
  }
}
