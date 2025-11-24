// lib/ui/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/mood/settingsviewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
    final TextEditingController _nameController = TextEditingController(text: vm.userName);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: vm.saveSettings.running ? null : () {
                vm.setUserName(_nameController.text);
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
                    // --------- PERFIL ---------
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Perfil',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Seu nome',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              onChanged: (value) {
                                vm.setUserName(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --------- PREFERÊNCIAS ---------
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preferências',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Notificações
                            SwitchListTile(
                              title: const Text('Notificações'),
                              subtitle: const Text('Receber lembretes diários'),
                              value: vm.notificationsEnabled,
                              onChanged: (value) {
                                vm.setNotificationsEnabled(value);
                              },
                              secondary: const Icon(Icons.notifications),
                            ),

                            // Modo escuro
                            SwitchListTile(
                              title: const Text('Modo Escuro'),
                              subtitle: const Text('Usar tema escuro'),
                              value: vm.darkMode,
                              onChanged: (value) {
                                vm.setDarkMode(value);
                              },
                              secondary: const Icon(Icons.dark_mode),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --------- SOBRE ---------
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sobre',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.info),
                              title: const Text('Versão'),
                              subtitle: const Text('1.0.0'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.privacy_tip),
                              title: const Text('Política de Privacidade'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.help),
                              title: const Text('Ajuda'),
                              onTap: () {},
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