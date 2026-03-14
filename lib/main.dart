import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/todo_service.dart';
import 'services/settings_service.dart';
import 'screens/home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ja');

  final prefs = await SharedPreferences.getInstance();

  final todoService = TodoService(prefs);

  runApp(MyApp(todoService: todoService));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.todoService});

  final TodoService todoService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AppSettings settings = AppSettings();

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: settings,

      builder: (context, _) {

        return MaterialApp(

          debugShowCheckedModeBanner: false,

          theme: ThemeData(

            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: settings.themeColor,
              brightness: Brightness.light,
            ),

          ),

          darkTheme: ThemeData(

            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: settings.themeColor,
              brightness: Brightness.dark,
            ),

          ),

          themeMode: settings.darkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: HomeScreen(
            todoService: widget.todoService,
            settings: settings,
          ),
        );
      },
    );
  }
}