// lib/core/di/ConfigureProviders.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:emotion_app/data/services/humor_service.dart';
import 'package:emotion_app/data/repositories/humor_repository.dart';
import 'package:emotion_app/ui/humor/view_model/humor_view_model.dart';
import 'package:emotion_app/ui/humor/view_model/barra_view_model.dart';
import 'package:emotion_app/ui/humor/view_model/painel_view_model.dart';
import 'package:emotion_app/ui/humor/view_model/dicas_view_model.dart';
import 'package:emotion_app/ui/humor/view_model/notificacoes_view_model.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final service = MoodService();
    final repository = MoodRepository(service);

    final moodViewModel = MoodViewModel(repository);
    final shellViewModel = ShellViewModel();
    final dashboardViewModel = DashboardViewModel(repository: repository);
    final tipsViewModel = TipsViewModel(repository: repository);
    final notificationsViewModel = NotificationsViewModel();

    return ConfigureProviders(
      providers: [
        /// Serviços
        Provider<MoodService>.value(value: service),

        /// Repositórios
        Provider<MoodRepository>.value(value: repository),

        /// ViewModels
        ChangeNotifierProvider<MoodViewModel>.value(value: moodViewModel),
        ChangeNotifierProvider<ShellViewModel>.value(value: shellViewModel),
        ChangeNotifierProvider<DashboardViewModel>.value(value: dashboardViewModel),
        ChangeNotifierProvider<TipsViewModel>.value(value: tipsViewModel),
        ChangeNotifierProvider<NotificationsViewModel>.value(value: notificationsViewModel),
      ],
    );
  }
}