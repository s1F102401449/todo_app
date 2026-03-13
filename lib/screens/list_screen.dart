import 'package:flutter/material.dart';

import '../services/todo_service.dart';
import '../services/settings_service.dart';
import '../widgets/todo_list.dart';
import 'add_todo_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    super.key,
    required this.todoService,
    required this.settings,
  });

  final TodoService todoService;
  final AppSettings settings;

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  // Todo追加後に TodoList を作り直すためのキー
  Key _todoListKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TODOリスト')),

      body: TodoList(
        key: _todoListKey,
        todoService: widget.todoService,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(
                todoService: widget.todoService,
              ),
            ),
          );

          if (updated == true) {
            setState(() {
              _todoListKey = UniqueKey();
            });
          }
        },

        backgroundColor: const Color.fromARGB(255, 0, 0, 255),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}