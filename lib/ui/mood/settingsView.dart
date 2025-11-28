// lib/ui/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/mood/settingsViewModel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações de Notificação'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: vm.saveSettings.running ? null : () {
                vm.saveSettings.execute(null);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações salvas!')),
                );
              },
              tooltip: 'Salvar configurações',
            ),
          ],
        ),
        body: vm.loadSettings.running
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // --------- NOTIFICAÇÕES ---------
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notificações',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Ativar/Desativar Notificações
                            SwitchListTile(
                              title: const Text('Notificações Ativas'),
                              subtitle: const Text('Receber lembretes diários'),
                              value: vm.notificationsEnabled,
                              onChanged: (value) {
                                vm.setNotificationsEnabled(value);
                              },
                              secondary: const Icon(Icons.notifications),
                            ),

                            const SizedBox(height: 8),

                            // Horário das Notificações
                            ListTile(
                              leading: const Icon(Icons.access_time),
                              title: const Text('Horário das Notificações'),
                              subtitle: Text(
                                vm.notificationsEnabled
                                  ? 'Você receberá notificações às ${vm.notificationTime.format(context)}' // REMOVA AS ASPAS DUPLAS
                                  : 'As notificações estão desativadas',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: vm.notificationsEnabled ? () async {
                                  final TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: vm.notificationTime,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  
                                  if (pickedTime != null) {
                                    vm.setNotificationTime(pickedTime);
                                  }
                                } : null,
                              ),
                              onTap: vm.notificationsEnabled ? () async {
                                final TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: vm.notificationTime,
                                  builder: (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                        alwaysUse24HourFormat: false,
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                
                                if (pickedTime != null) {
                                  vm.setNotificationTime(pickedTime);
                                }
                              } : null,
                            ),

                            // Mensagem informativa
                            if (!vm.notificationsEnabled)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Ative as notificações para definir o horário',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --------- STATUS ---------
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Status das notificações
                            ListTile(
                              leading: Icon(
                                vm.notificationsEnabled 
                                    ? Icons.notifications_active 
                                    : Icons.notifications_off,
                                color: vm.notificationsEnabled 
                                    ? Colors.green 
                                    : Colors.grey,
                              ),
                              title: Text(
                                vm.notificationsEnabled 
                                    ? 'Notificações Ativas' 
                                    : 'Notificações Inativas',
                              ),
                              subtitle: Text(
                                vm.notificationsEnabled
                                    ? 'Você receberá notificações às ${vm.notificationTime.format(context)}'
                                    : 'As notificações estão desativadas',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}