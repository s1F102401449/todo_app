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

      body: ListView(
        children: [

          /// ダークモード
          SwitchListTile(
            title: const Text("ダークモード"),
            value: settings.darkMode,
            onChanged: (value) {
              settings.toggleDarkMode(value);
            },
          ),

          const Divider(),

          /// カレンダー説明
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "カレンダーのマーク説明",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 8,
            ),
            title: const Text("重要タスク"),
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 8,
            ),
            title: const Text("着手中タスク"),
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              radius: 8,
            ),
            title: const Text("完了タスク"),
          ),

          const Divider(),

          /// テーマカラー変更
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "テーマカラー",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.blue),
            title: const Text("ブルー"),
            onTap: () {
              settings.changeThemeColor(Colors.blue);
            },
          ),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.green),
            title: const Text("グリーン"),
            onTap: () {
              settings.changeThemeColor(Colors.green);
            },
          ),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.orange),
            title: const Text("オレンジ"),
            onTap: () {
              settings.changeThemeColor(Colors.orange);
            },
          ),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.purple),
            title: const Text("パープル"),
            onTap: () {
              settings.changeThemeColor(Colors.purple);
            },
          ),

        ],
      ),
    );
  }
}