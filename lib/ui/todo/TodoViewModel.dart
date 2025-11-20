import 'package:flutter/foundation.dart';
import 'package:todo_app_arch/data/repositories/TodoRepository.dart';
import 'package:todo_app_arch/utils/command.dart';
import 'package:todo_app_arch/utils/result.dart';

/*
O ViewModel diz PARA a tela: "Ei, os dados principais mudaram, atualize a lista!"
 */
class TodoViewModel extends ChangeNotifier {
  TodoViewModel(this._repository) {
    loadTodos = Command<List<String>, void>(_loadTodos)..executeNoArgs();
    addTodo = Command<void, String>(_addTodo);
  }

  final TodoRepository _repository;

  late Command<List<String>, void> loadTodos;
  late Command<void, String> addTodo;

  List<String> _todos = [];
  List<String> get todos => _todos;

  Future<Result<List<String>>> _loadTodos(void _) async {
    try {
      final list = await _repository.getTodos();
      _todos = list;
      return Ok(list);
    } catch (e) {
      return Error("Falha ao carregar");
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addTodo(String text) async {
    try {
      await _repository.addTodo(text);
      return Ok(text);
    } catch (e) {
      return Error("Falha ao adicionar");
    } finally {
      notifyListeners();
    }
  }
}
