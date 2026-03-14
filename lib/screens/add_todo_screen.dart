import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({
    super.key,
    required this.todoService,
    this.todo,
  });

  final TodoService todoService;
  final Todo? todo;

  @override
  AddTodoScreenState createState() => AddTodoScreenState();
}

class AddTodoScreenState extends State<AddTodoScreen> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  bool _isImportant = false;
  bool _isFormValid = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    _titleController.addListener(_updateFormValid);
    _detailController.addListener(_updateFormValid);
    _dateController.addListener(_updateFormValid);

    // 編集モード
    if (widget.todo != null) {

      final todo = widget.todo!;

      _titleController.text = todo.title;
      _detailController.text = todo.detail;

      _selectedDate = todo.dueDate;

      _dateController.text =
          '${todo.dueDate.year}/${todo.dueDate.month}/${todo.dueDate.day}';

      _isImportant = todo.isImportant;
    }
  }

  void _updateFormValid() {
    setState(() {
      _isFormValid =
          _titleController.text.isNotEmpty &&
          _detailController.text.isNotEmpty &&
          _selectedDate != null;
    });
  }

  @override
  Widget build(BuildContext context) {

    final bool isEdit = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'タスクを編集' : '新しいタスクを追加'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              /// タイトル
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'タスクのタイトル',
                  hintText: '20文字以内で入力してください',
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// 詳細
              TextFormField(
                controller: _detailController,

                decoration: const InputDecoration(
                  labelText: 'タスクの詳細',
                  hintText: '入力してください',
                  border: OutlineInputBorder(),
                ),

                maxLines: 3,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '詳細を入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// 期日
              TextFormField(
                controller: _dateController,
                readOnly: true,

                decoration: const InputDecoration(
                  labelText: '期日',
                  hintText: '年/月/日',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),

                onTap: () async {

                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {

                    setState(() {

                      _selectedDate = picked;

                      _dateController.text =
                          '${picked.year}/${picked.month}/${picked.day}';
                    });
                  }
                },

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '期日を選択してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// 重要スイッチ
              Container(
                decoration: BoxDecoration(
                  color: _isImportant
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(10),

                  border: Border.all(
                    color: _isImportant
                        ? Colors.orange
                        : Colors.grey.shade300,
                  ),
                ),

                child: SwitchListTile(

                  title: const Text(
                    '重要なタスクとしてマーク',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  secondary: Icon(
                    Icons.priority_high,
                    color: _isImportant
                        ? Colors.orange
                        : Colors.grey,
                  ),

                  value: _isImportant,

                  activeColor: Colors.orange,

                  onChanged: (bool value) {

                    setState(() {
                      _isImportant = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// 保存ボタン
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: _isFormValid ? _saveTodo : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? Colors.blue
                        : Colors.grey.shade400,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: Text(

                    isEdit ? 'タスクを更新' : 'タスクを追加',

                    style: TextStyle(
                      color: _isFormValid
                          ? Colors.white
                          : Colors.grey,

                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 保存処理
  void _saveTodo() async {

    if (_formKey.currentState!.validate()) {

      final todos = await widget.todoService.getTodos();

      if (widget.todo == null) {

        /// 新規作成
        Todo newTodo = Todo(
          title: _titleController.text,
          detail: _detailController.text,
          dueDate: _selectedDate!,
          isImportant: _isImportant,
        );

        todos.add(newTodo);

      } else {

        /// 編集
        final index =
            todos.indexWhere((t) => t.id == widget.todo!.id);

        if (index != -1) {

          todos[index] = Todo(
            id: widget.todo!.id,
            title: _titleController.text,
            detail: _detailController.text,
            dueDate: _selectedDate!,
            isImportant: _isImportant,
            isCompleted: widget.todo!.isCompleted,
            isInProgress: widget.todo!.isInProgress,
          );
        }
      }

      await widget.todoService.saveTodos(todos);

      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {

    _titleController.dispose();
    _detailController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFormValid();
  }
}