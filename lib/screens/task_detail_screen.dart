import 'package:flutter/material.dart';
import '../models/todo.dart';

class TaskDetailScreen extends StatelessWidget {

  final Todo todo;

  const TaskDetailScreen({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("タスク詳細"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "タイトル",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              todo.title,
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            const Text(
              "詳細",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              todo.detail.isEmpty ? "詳細なし" : todo.detail,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            const Text(
              "期限",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "${todo.dueDate.year}/${todo.dueDate.month}/${todo.dueDate.day}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                if (todo.isImportant)
                  const Chip(
                    label: Text("重要"),
                    backgroundColor: Colors.orange,
                  ),

                const SizedBox(width: 10),

                if (todo.isInProgress)
                  const Chip(
                    label: Text("着手中"),
                    backgroundColor: Colors.blue,
                  ),

                const SizedBox(width: 10),

                if (todo.isCompleted)
                  const Chip(
                    label: Text("完了"),
                    backgroundColor: Colors.green,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}