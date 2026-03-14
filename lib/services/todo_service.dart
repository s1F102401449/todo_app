import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoService {
  static const String _storageKey = 'todos';
  final SharedPreferences _prefs;

  TodoService(this._prefs);

  // 1. 読み込み
  Future<List<Todo>> getTodos() async {
    final String? todosJson = _prefs.getString(_storageKey);
    if (todosJson == null) return [];

    final List<dynamic> decoded = jsonDecode(todosJson);

    final List<Todo> todos = decoded.map((json) => Todo(
      id: json['id'],
      title: json['title'],
      detail: json['detail'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'] ?? false,
      isImportant: json['isImportant'] ?? false,
      isInProgress: json['isInProgress'] ?? false,
    )).toList();

    // ソート
    todos.sort((a, b) {

      // 完了済みを一番下
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // 着手中を上
      if (a.isInProgress != b.isInProgress) {
        return a.isInProgress ? -1 : 1;
      }

      // 重要
      if (a.isImportant != b.isImportant) {
        return a.isImportant ? -1 : 1;
      }

      // 日付順
      return a.dueDate.compareTo(b.dueDate);
    });

    return todos;
  }

  // 2. 保存
  Future<void> saveTodos(List<Todo> todos) async {

    final List<Map<String, dynamic>> jsonData = todos
        .map((todo) => {
              'id': todo.id,
              'title': todo.title,
              'detail': todo.detail,
              'dueDate': todo.dueDate.toIso8601String(),
              'isCompleted': todo.isCompleted,
              'isImportant': todo.isImportant,
              'isInProgress': todo.isInProgress,
            })
        .toList();

    final String encoded = jsonEncode(jsonData);
    await _prefs.setString(_storageKey, encoded);
  }

  // 3. 削除
  Future<void> deleteTodo(String id) async {
    final List<Todo> currentTodos = await getTodos();
    currentTodos.removeWhere((todo) => todo.id == id);
    await saveTodos(currentTodos);
  }

  // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
  // 4. カレンダー用：指定日のTodo取得
  // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

  Future<List<Todo>> getTodosForDay(DateTime day) async {

    final todos = await getTodos();

    return todos.where((todo) {

      final todoDate = DateTime(
        todo.dueDate.year,
        todo.dueDate.month,
        todo.dueDate.day,
      );

      final targetDate = DateTime(
        day.year,
        day.month,
        day.day,
      );

      return todoDate == targetDate;

    }).toList();
  }
}