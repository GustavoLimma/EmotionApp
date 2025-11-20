import 'package:flutter/material.dart';

class ShellViewModel extends ChangeNotifier {
  int _currentIndex = 0; // Deve começar em 0 (Dashboard)
  
  int get currentIndex => _currentIndex;
  
  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}