import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {

  final AppSettings settings;

  const SettingsScreen({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),

      body: SwitchListTile(
        title: const Text("ダークモード"),
        value: settings.darkMode,

        onChanged: (value) {
          settings.toggleDarkMode(value);
        },
      ),
    );
  }
}