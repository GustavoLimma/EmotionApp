// lib/ui/settings/settings_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:emotion_app/utils/command.dart';
import 'package:emotion_app/utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel() {
    loadSettings = Command<void, void>(_loadSettings);
    saveSettings = Command<void, void>(_saveSettings);
    
    // Executa o carregamento inicial
    loadSettings.execute(null);
  }

  late Command<void, void> loadSettings;
  late Command<void, void> saveSettings;

  // Configurações do usuário
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;
  
  String _userName = '';
  String get userName => _userName;
  
  bool _darkMode = false;
  bool get darkMode => _darkMode;

  // --------- LOAD SETTINGS ---------
  Future<Result<void>> _loadSettings(void _) async {
    try {
      // Aqui você pode carregar do SharedPreferences ou outro storage
      // Por enquanto, valores padrão
      _notificationsEnabled = true;
      _userName = '';
      _darkMode = false;
      
      return Ok(null);
    } catch (e) {
      return Error("Erro ao carregar configurações");
    } finally {
      notifyListeners();
    }
  }

  // --------- SAVE SETTINGS ---------
  Future<Result<void>> _saveSettings(void _) async {
    try {
      // Aqui você pode salvar no SharedPreferences ou outro storage
      // Implemente a lógica de persistência conforme necessário
      
      return Ok(null);
    } catch (e) {
      return Error("Erro ao salvar configurações");
    } finally {
      notifyListeners();
    }
  }

  // Métodos para atualizar as configurações
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}