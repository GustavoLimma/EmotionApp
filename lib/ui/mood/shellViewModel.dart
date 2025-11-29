// lib/ui/mood/shellviewmodel.dart

import 'package:flutter/material.dart';
import 'package:emotion_app/utils/command.dart';
import 'package:emotion_app/utils/result.dart';

class ShellViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  late Command<void, int> changeIndexCommand;

  ShellViewModel() {
    changeIndexCommand = Command<void, int>(_changeIndex);
  }

  Future<Result<void>> _changeIndex(int index) async {
    try {
      _currentIndex = index;
      notifyListeners();
      return Ok(null);
    } catch (e) {
      return Error("Erro ao trocar aba");
    }
  }
}
