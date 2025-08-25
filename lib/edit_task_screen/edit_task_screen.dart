import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatbytes_task/controller/task_controller.dart';
import '../model/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final taskController = Get.put(TaskController());
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _dueDate;
  late String _priority;

  final List<String> priorities = ["Low", "Medium", "High"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not logged in")),
          );
          return;
        }

        Task updatedTask = Task(
          id: widget.task.id,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
          isCompleted: widget.task.isCompleted,
          userId: user.uid,
        );

        await taskController.updateTask(updatedTask);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task updated successfully")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
        backgroundColor: Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter task title" : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter task description" : null,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Due Date: ${DateFormat('d MMM yyyy').format(_dueDate)}",
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF),
                      ),
                      onPressed: () => _pickDueDate(context),
                      child: Text("Change Date", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: priorities
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _priority = val!;
                    });
                  },
                  decoration: InputDecoration(labelText: "Priority"),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C63FF),
                    ),
                    onPressed: _updateTask,
                    child: Text("Update Task", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}