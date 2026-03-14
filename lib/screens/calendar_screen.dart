import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/todo_service.dart';
import '../models/todo.dart';
import 'task_detail_screen.dart';

class CalendarScreen extends StatefulWidget {

  final TodoService todoService;
  final VoidCallback onOpenTaskTab;

  const CalendarScreen({
    super.key,
    required this.todoService,
    required this.onOpenTaskTab,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Todo> _todos = [];
  List<Todo> _selectedTodos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {

    final todos = await widget.todoService.getTodos();

    setState(() {
      _todos = todos;
      _selectedDay = DateTime.now();
      _selectedTodos = getEventsForDay(_selectedDay!);
    });
  }

  List<Todo> getEventsForDay(DateTime day) {

    return _todos.where((todo) {

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("カレンダー"),
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            TableCalendar(

              locale: 'ja_JP',

              firstDay: DateTime.utc(2010,1,1),
              lastDay: DateTime.utc(2030,1,1),

              focusedDay: _focusedDay,

              eventLoader: getEventsForDay,

              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {

                  if (events.isEmpty) return null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.map((event) {

                      final todo = event as Todo;

                      Color color = Colors.black;

                      if (todo.isCompleted) {
                      color = Colors.green;
                      } else if (todo.isImportant) {
                      color = Colors.orange;
                      } else if (todo.isInProgress) {
                      color = Colors.blue;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      );

                    }).toList(),
                  );
                },
              ),

              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              onDaySelected: (selectedDay, focusedDay) {

                setState(() {

                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;

                  _selectedTodos = getEventsForDay(selectedDay);

                });
              },
            ),

            const SizedBox(height: 10),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${_selectedDay?.month}/${_selectedDay?.day} のタスク",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _selectedTodos.isEmpty

                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("タスクはありません"),
                  )

                : ListView.builder(

                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: _selectedTodos.length,

                    itemBuilder: (context, index) {

                      final todo = _selectedTodos[index];

                      return ListTile(

                        leading: const Icon(Icons.task),

                        title: Text(todo.title),

                        subtitle: Text(
                          "${todo.dueDate.year}/${todo.dueDate.month}/${todo.dueDate.day}",
                        ),

                        trailing: todo.isImportant
                            ? const Icon(Icons.star, color: Colors.orange)
                            : null,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(todo: todo),
                            ),
                          );
                        },
                      );
                    },
                  ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}