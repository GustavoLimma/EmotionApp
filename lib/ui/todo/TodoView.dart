import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_arch/ui/todo/TodoViewModel.dart';
import 'package:todo_app_arch/utils/command.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TodoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
            tooltip: "Recarregar lista",
            onPressed: () => vm.loadTodos.executeNoArgs(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// LOADING GLOBAL
              if (vm.loadTodos.running)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),

              /// LISTA
              if (!vm.loadTodos.running && vm.todos.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    itemCount: vm.todos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(
                          vm.todos[i],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),

              /// ESTADO VAZIO
              if (!vm.loadTodos.running && vm.todos.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 60, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          "Nenhuma tarefa encontrada",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

              /// ERRO AO ADICIONAR
              if (vm.addTodo.error)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Erro ao adicionar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 20),

              /// CAMPO DE INPUT
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                        labelText: "Novo TODO",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          vm.addTodo.execute(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}