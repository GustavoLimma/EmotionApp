// notifications_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/humor/view_model/notificacoes_view_model.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsViewModel viewModel = 
        Provider.of<NotificationsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes de Saúde'),
        backgroundColor: Colors.blue[50],
        elevation: 0,
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildHeader(context, viewModel),
        Expanded(
          child: ListView.builder(
            itemCount: viewModel.reminders.length,
            itemBuilder: (context, index) => _buildReminderCard(
              context,
              viewModel,
              viewModel.reminders[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, NotificationsViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lembretes ${viewModel.notificationsEnabled ? 'Ativados' : 'Desativados'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: viewModel.notificationsEnabled 
                          ? Colors.green 
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Receba notificações para manter sua rotina saudável',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Switch(
              value: viewModel.notificationsEnabled,
              onChanged: (value) => viewModel.toggleAllNotifications(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(
    BuildContext context,
    NotificationsViewModel viewModel,
    Map<String, dynamic> reminder,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              viewModel.formatTime(
                reminder['hour'] as int,
                reminder['minute'] as int,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          reminder['title'] as String,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: (reminder['enabled'] as bool) 
                ? TextDecoration.none 
                : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(reminder['body'] as String),
        trailing: Switch(
          value: reminder['enabled'] as bool,
          onChanged: (value) => viewModel.toggleNotification(
            reminder['id'] as int,
            value,
          ),
        ),
      ),
    );
  }
}