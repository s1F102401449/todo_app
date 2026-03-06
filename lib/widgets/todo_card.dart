import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // dueDateを「12月30日(月)」形式で表示するために使う
import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo; // このカードに表示するデータ（title / detail / dueDate を使って表示しよう）
  final VoidCallback? onToggle; // チェックボタンを押したときの処理（onPressedに渡して呼ばれるようにしよう）
  final VoidCallback? onProgressTap; // ★追加：着手の切り替え

  const TodoCard({
    super.key,
    required this.todo,
    this.onToggle,
    this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo.isImportant ? Colors.deepOrangeAccent : Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // チェックボタン：isCompletedでアイコンを出し分け、押したらonToggleが呼ばれるようにしよう
            IconButton(
              iconSize: 32,
              icon: Icon(
                todo.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: Colors.white,
              ),
              onPressed: onToggle,
            ),
            const SizedBox(width: 8),
            // テキスト群：横に伸ばしたいのでExpandedで包もう
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // ★ 修正：重要タスクならタイトルの前に「！」アイコンを置く
                Row(
                  children: [
                    if (todo.isImportant)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.priority_high, color: Colors.white, size: 24),
                      ),
                    Expanded(
                      child: Text(
                        todo.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 例：タイトルの横に着手中のバッジを表示
                    if (todo.isInProgress)
                      Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('着手中', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                Padding(
              padding: const EdgeInsets.only(right: 12),
              child: OutlinedButton(
                onPressed: onProgressTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: const StadiumBorder(),
                ),
                child: Text(todo.isInProgress ? '止める' : '着手する'),
              ),
            ),
                  Text(
                    todo.detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat('M月d日(E)', 'ja').format(todo.dueDate),
                    // dueDateを日本語表記に変換して表示しよう
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}