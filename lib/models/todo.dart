import 'package:uuid/uuid.dart'; // idを自動生成するために使う

class Todo {
  final String id; // タスクを識別するためのID（同じタイトルでも区別できる）
  final String title;
  final String detail;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isImportant; //★追加：重要度
  final bool isInProgress; // ★追加：着手しているかどうか

  Todo({
    String? id, // 指定がなければ自動生成
    required this.title,
    required this.detail,
    required this.dueDate,
    this.isCompleted = false,
    this.isImportant = false,
    this.isInProgress = false,
  }) : id = id ?? const Uuid().v4(); // idがnullならUuidで生成（?? を使う）

  // 一部だけ差し替えたTodoを作る（元のTodoは変更しない）
  Todo copyWith({
    String? title,
    String? detail,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isImportant,
    bool? isInProgress,
  }) {
    return Todo(
      id: id, // idは引き継いで同一タスクとして扱う
      // 引数がnullなら元の値を使う（??）→ 必要なものだけ更新できる
      title: title ?? this.title,
      detail: detail ?? this.detail,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
      isInProgress: isInProgress ?? this.isInProgress,
    );
  }
}