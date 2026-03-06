import 'package:flutter/material.dart';

import '../models/todo.dart'; // 作成したTodoクラス
import '../services/todo_service.dart'; // データ保存サービス
import '../widgets/todo_card.dart'; // 作成したTodoCardウィジェット

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.todoService});

  final TodoService todoService; // getTodos/saveTodos を呼べるように受け取ろう

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = []; // 検索にヒットしたデータ（画面に表示する用）
  String _searchQuery = '';        // 入力された文字
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos(); // 起動時に端末から読み込んで表示しよう
  }

  Future<void> _loadTodos() async {
    // 端末保存から読み込んで、画面に反映しよう
    final todos = await widget.todoService.getTodos();
    setState(() {
      _todos = todos;
      _runFilter(_searchQuery); // 読み込み時にもフィルターを適用
      _isLoading = false;
    });
  }

  // ★ 検索処理のコア
  void _runFilter(String query) {
    List<Todo> results = [];
    if (query.isEmpty) {
      results = _todos;
    } else {
      // タイトルに検索ワードが含まれているかチェック（大文字小文字を区別しない）
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

  // 追加画面から呼ばれる：リストに追加して保存まで行おう
  void addTodo(Todo newTodo) async {
    setState(() => _todos.add(newTodo));
    await widget.todoService.saveTodos(_todos);
  }

  // 状態（着手・完了）を更新して保存する共通処理
  Future<void> _handleUpdate(Todo updatedTodo) async {
    // リスト内の該当データを差し替え
    final index = _todos.indexWhere((t) => t.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      // 保存 (service側のsaveTodosを呼ぶ)
      await widget.todoService.saveTodos(_todos);
      // 再読み込みしてソート順を反映
      await _loadTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // body 全体を Column にして、「検索バー」と「リスト」を並べます
    return Column(
      children: [
        // 1. 検索バーの追加
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (value) => _runFilter(value), // 文字が変わるたびにフィルタ実行
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

        // 2. リスト表示部分（Expanded で囲むのがポイント！）
        Expanded(
          child: _filteredTodos.isEmpty
              ? const Center(child: Text('タスクが見つかりません'))
              : ListView.builder(
                  // ★ポイント：表示には _filteredTodos を使う
                  itemCount: _filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = _filteredTodos[index];

                    // 3. スワイプ削除機能で包む
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
                        // 削除処理の実行
                        await widget.todoService.deleteTodo(todo.id);
                        setState(() {
                          _todos.removeWhere((t) => t.id == todo.id);
                          _runFilter(_searchQuery); // 検索結果も更新
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TodoCard(
                          todo: todo,
                          onToggle: () {
                            // 完了状態を切り替え（以前は削除してましたが更新に変更）
                            _handleUpdate(todo.copyWith(isCompleted: !todo.isCompleted));
                          },
                          onProgressTap: () {
                            _handleUpdate(todo.copyWith(isInProgress: !todo.isInProgress));
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