import 'package:flutter/material.dart';
import 'package:todo_app/services/settings_service.dart';
import '../services/todo_service.dart';
import 'list_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final TodoService todoService;
  final AppSettings settings;

  const HomeScreen({
    super.key,
    required this.todoService,
    required this.settings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 1;

  late final List<Widget> _screens = [
    const ProfileScreen(),
    ListScreen(
      todoService: widget.todoService,
      settings: widget.settings,
    ),
    SettingsScreen(
      settings: widget.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "マイページ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "ホーム",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "設定",
          ),
        ],
      ),
    );
  }
}