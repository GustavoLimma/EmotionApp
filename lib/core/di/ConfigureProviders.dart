// lib/core/di/ConfigureProviders.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:emotion_app/data/services/mood_service.dart';
import 'package:emotion_app/data/repositories/mood_repository.dart';
import 'package:emotion_app/ui/mood/mood_viewmodel.dart';
import 'package:emotion_app/ui/mood/shellviewmodel.dart';
import '../../ui/mood/Dashboard_viewModel.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final service = MoodService();
    final repository = MoodRepository(service);

    final moodViewModel = MoodViewModel(repository);
    final shellViewModel = ShellViewModel();
    final dashboardViewModel = DashboardViewModel(); // <-- corrigido

    return ConfigureProviders(
      providers: [
        /// Serviços
        Provider<MoodService>.value(value: service),

        /// Repositórios
        Provider<MoodRepository>.value(value: repository),

        /// ViewModels
        ChangeNotifierProvider<MoodViewModel>.value(value: moodViewModel),
        ChangeNotifierProvider<ShellViewModel>.value(value: shellViewModel),
        ChangeNotifierProvider<DashboardViewModel>.value(value: dashboardViewModel), // <-- corrigido
      ],
    );
  }
}
