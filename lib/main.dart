import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/todo_service.dart';
import 'services/settings_service.dart';
import 'screens/home_screen.dart';

void main() async {
  // Flutter の非同期初期化
  WidgetsFlutterBinding.ensureInitialized();

  // 日付フォーマット初期化
  await initializeDateFormatting('ja');

  // SharedPreferences 初期化
  final prefs = await SharedPreferences.getInstance();

  // TodoService 作成
  final todoService = TodoService(prefs);

  // アプリ起動
  runApp(MyApp(todoService: todoService));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.todoService});

  final TodoService todoService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // アプリ設定（ダークモード・テーマカラー）
  final AppSettings settings = AppSettings();

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: settings,

      builder: (context, _) {

        return MaterialApp(

          theme: ThemeData(
            primarySwatch: settings.themeColor,
            brightness:
                settings.darkMode ? Brightness.dark : Brightness.light,
          ),

          home: HomeScreen(
            todoService: widget.todoService,
            settings: settings,
          ),
        );
      },
    );
  }
}