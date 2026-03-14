import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {

  bool darkMode = false;

  Color themeColor = Colors.blue;

  void toggleDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void changeThemeColor(Color color) {
    themeColor = color;
    notifyListeners();
  }
}