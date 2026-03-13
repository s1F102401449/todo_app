import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {

  bool _darkMode = false;
  MaterialColor _themeColor = Colors.blue;

  bool get darkMode => _darkMode;
  MaterialColor get themeColor => _themeColor;

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void changeColor(MaterialColor color) {
    _themeColor = color;
    notifyListeners();
  }
}