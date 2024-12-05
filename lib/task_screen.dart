import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddTask;

  const AddTaskScreen({super.key, required this.onAddTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String selectedPriority = "Low"; // Default value
  TimeOfDay? time;

  void pickTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        time = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Add Task",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Title cannot be empty!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        widget.onAddTask({
                          'title': titleController.text,
                          'priority': selectedPriority,
                          'notes': notesController.text,
                          'time': time != null ? time!.format(context) : 'N/A',
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildInputCard(
                          title: "Task Title",
                          child: TextField(
                            controller: titleController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Enter your task title",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        buildInputCard(
                          title: "Time",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                time != null
                                    ? "Time: ${time!.format(context)}"
                                    : "Time: Not Set",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.access_time,
                                    color: Colors.white),
                                onPressed: () => pickTime(context),
                              ),
                            ],
                          ),
                        ),
                        buildInputCard(
                          title: "Priority",
                          child: SizedBox(
                            height: 50,
                            child: DropdownButton<String>(
                              value: selectedPriority,
                              dropdownColor: const Color(0xFF5D54A4),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                              underline: const SizedBox(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedPriority = value!;
                                });
                              },
                              items: ["Low", "Medium", "High"]
                                  .map(
                                    (priority) => DropdownMenuItem<String>(
                                      value: priority,
                                      child: Text(priority),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        buildInputCard(
                          title: "Notes",
                          child: TextField(
                            controller: notesController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Add notes (optional)",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputCard({required String title, required Widget child}) {
    return Card(
      color: const Color(0xFF5D54A4),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
