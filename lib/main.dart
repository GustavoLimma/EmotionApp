import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:emotion_app/core/di/ConfigureProviders.dart';
import 'package:emotion_app/ui/humor/view_model/barra_view_model.dart';
import 'package:emotion_app/data/services/notificacao_service.dart';
import 'package:emotion_app/ui/humor/view/barra_view.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService().initialize();

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
      home: ChangeNotifierProvider( // ✅ ADICIONE ESTE WRAPPER
        create: (context) => ShellViewModel(),
        child: const AppShell(),
      ),
    );
  }
}

