// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/ConfigureProviders.dart';
import 'ui/mood/shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(
    MultiProvider(
      providers: data.providers,
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
      home: AppShell(),   // <-- AGORA É O SHELL QUE CONTÉM AS TELAS E A BOTTOM BAR
    );
  }
}
