import 'package:flutter/material.dart';
import 'package:on_time/task_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database database;
  List<Map<String, dynamic>> tasks = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  void initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, priority TEXT, notes TEXT, date TEXT)');
      },
    );

    loadTasks();
  }

  void loadTasks() async {
    final result = await database.query(
      'tasks',
      where: 'date = ?',
      whereArgs: [selectedDate.toIso8601String().split('T')[0]],
    );
    setState(() {
      tasks = result;
    });
  }

  void addTask(Map<String, dynamic> task) async {
    await database.insert('tasks', task);
    loadTasks();
  }

  void deleteTask(int id) async {
    await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    loadTasks();
  }

  void updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFA9DF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAA0A0),
        elevation: 0,
        title: const Text(
          "ON TIME",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: selectedDate,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              updateSelectedDate(selectedDay);
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Color(0xFF67035D),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF3B5102),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red[900]),
              defaultTextStyle: const TextStyle(color: Colors.black),
              outsideTextStyle: const TextStyle(color: Colors.black54),
            ),
          ),
          const Divider(color: Colors.white),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text(
                "No tasks scheduled for this date!",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    deleteTask(task['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${task['title']} deleted")),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF9C5F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          task['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        subtitle: Text(
                          "Time: ${task['time']}\nPriority: ${task['priority']}\nNotes: ${task['notes']}",
                          style:
                          const TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedDate.isBefore(
          DateTime.now().subtract(const Duration(days: 1))) // Allow same-day selection
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onAddTask: (task) {
                  task['date'] = selectedDate
                      .toIso8601String()
                      .split('T')[0]; // Format date
                  addTask(task);
                },
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF2B0027),
        child: const Icon(
          Icons.add,
          color: Color(0xFFF4E8F2),
        ),
      ),
    );
  }
}
