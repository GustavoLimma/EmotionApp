// lib/main.dart
import 'package:flutter/material.dart';
import 'package:todo_app_arch/core/di/ConfigureProviders.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_arch/ui/todo/TodoView.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(
      MultiProvider(
          providers: data.providers,
          child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arquitetura Flutter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: TodoView(),
    );
  }
}
