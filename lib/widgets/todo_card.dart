import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onToggle;
  final VoidCallback? onProgressTap;
  final VoidCallback? onEdit;

  const TodoCard({
    super.key,
    required this.todo,
    this.onToggle,
    this.onProgressTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo.isImportant ? Colors.deepOrangeAccent : Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: SizedBox(
        height: 150,
        child: Row(
          children: [

            /// 完了チェック
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// タイトル + 編集ボタン
                    Row(
                      children: [

                        if (todo.isImportant)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.priority_high,
                              color: Colors.white,
                            ),
                          ),

                        Expanded(
                          child: Text(
                            todo.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// ✏ 編集ボタン
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: onEdit,
                        ),
                      ],
                    ),

                    /// 着手中バッジ
                    if (todo.isInProgress)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '着手中',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    /// 着手ボタン
                    OutlinedButton(
                      onPressed: onProgressTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        todo.isInProgress ? '止める' : '着手する',
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// 詳細
                    Text(
                      todo.detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    /// 期日
                    Text(
                      DateFormat('M月d日(E)', 'ja').format(todo.dueDate),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}