import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/todo_service.dart';
import '../widgets/todo_card.dart';
import '../screens/add_todo_screen.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.todoService});

  final TodoService todoService;

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await widget.todoService.getTodos();

    setState(() {
      _todos = todos;
      _runFilter(_searchQuery);
      _isLoading = false;
    });
  }

  void _runFilter(String query) {
    List<Todo> results = [];

    if (query.isEmpty) {
      results = _todos;
    } else {
      results = _todos
          .where((todo) =>
              todo.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      _searchQuery = query;
      _filteredTodos = results;
    });
  }

  void addTodo(Todo newTodo) async {
    setState(() => _todos.add(newTodo));
    await widget.todoService.saveTodos(_todos);
  }

  Future<void> _handleUpdate(Todo updatedTodo) async {
    final index = _todos.indexWhere((t) => t.id == updatedTodo.id);

    if (index != -1) {
      _todos[index] = updatedTodo;
      await widget.todoService.saveTodos(_todos);
      await _loadTodos();
    }
  }

  /// ✏ 編集画面を開く
  Future<void> _openEditScreen(Todo todo) async {

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoScreen(
          todoService: widget.todoService,
          todo: todo,
        ),
      ),
    );

    if (updated == true) {
      _loadTodos();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [

        /// 🔍 検索バー
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              hintText: 'タスクのタイトルで検索...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),

        /// 📋 タスクリスト
        Expanded(
          child: _filteredTodos.isEmpty
              ? const Center(child: Text('タスクが見つかりません'))
              : ListView.builder(
                  itemCount: _filteredTodos.length,
                  itemBuilder: (context, index) {

                    final todo = _filteredTodos[index];

                    return Dismissible(

                      key: Key(todo.id),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      onDismissed: (direction) async {

                        await widget.todoService.deleteTodo(todo.id);

                        setState(() {
                          _todos.removeWhere((t) => t.id == todo.id);
                          _runFilter(_searchQuery);
                        });
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: TodoCard(

                          todo: todo,

                          onToggle: () {
                            _handleUpdate(
                              todo.copyWith(
                                isCompleted: !todo.isCompleted,
                              ),
                            );
                          },

                          onProgressTap: () {
                            _handleUpdate(
                              todo.copyWith(
                                isInProgress: !todo.isInProgress,
                              ),
                            );
                          },

                          /// ✏ 編集ボタン
                          onEdit: () {
                            _openEditScreen(todo);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}