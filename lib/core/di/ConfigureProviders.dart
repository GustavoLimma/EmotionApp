import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_app_arch/data/repositories/TodoRepository.dart';
import 'package:todo_app_arch/data/services/TodoService.dart';
import 'package:todo_app_arch/ui/todo/TodoViewModel.dart';

class ConfigureProviders {

  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {

    final todoService = TodoService();
    final todoRepository = TodoRepository(todoService);
    final todoViewModel = TodoViewModel(todoRepository);

    return ConfigureProviders(providers: [
      Provider<TodoService>.value(value: todoService),
      Provider<TodoRepository>.value(value: todoRepository),
      ChangeNotifierProvider<TodoViewModel>.value(value: todoViewModel)
    ]);
  }
}