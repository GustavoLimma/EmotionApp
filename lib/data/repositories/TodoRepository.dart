import 'package:todo_app_arch/data/services/TodoService.dart';

class TodoRepository {
  final TodoService _service;

  TodoRepository(this._service);

  Future<List<String>> getTodos() async {
    // Aqui poderíamos aplicar cache, parsing, filtragem, etc.
    return _service.fetchTodos();
  }

  Future<void> addTodo(String todo) async {
    return _service.addTodo(todo);
  }
}