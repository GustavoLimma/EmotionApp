import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/mood/settingsViewModel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ATIVAR/DESATIVAR
            SwitchListTile(
              title: const Text('Notificações Ativas'),
              value: vm.notificationsEnabled,
              onChanged: vm.setNotificationsEnabled,
            ),

            const SizedBox(height: 20),

            // HORÁRIO
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Horário'),
              subtitle: Text(vm.notificationsEnabled 
                  ? 'Notificações às ${vm.notificationTime.format(context)}'
                  : 'Notificações desativadas'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: vm.notificationsEnabled ? () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: vm.notificationTime,
                  );
                  if (time != null) vm.setNotificationTime(time);
                } : null,
              ),
            ),

            const SizedBox(height: 20),

            // TESTAR
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications),
              label: const Text('Testar Notificação'),
              onPressed: vm.testNotification,
            ),
          ],
        ),
      ),
    );
  }
}