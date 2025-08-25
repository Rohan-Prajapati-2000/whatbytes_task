import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatbytes_task/animation/loading_animation.dart';
import 'package:whatbytes_task/controller/task_controller.dart';
import '../model/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskController = Get.put(TaskController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _dueDate;
  String _priority = "Low";

  final List<String> priorities = ["Low", "Medium", "High"];

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: LoadingAnimation()),
      );

      try {
        final user = FirebaseAuth.instance.currentUser ;

        if (user == null) {
          Navigator.of(context).pop(); // Close the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User  not logged in")),
          );
          return;
        }

        Task newTask = Task(
          id: DateTime.now().toString(),
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          dueDate: _dueDate!,
          priority: _priority,
          isCompleted: false,
          userId: user.uid,
        );

        await taskController.addNewTask(newTask);

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task added successfully")),
        );
        Navigator.pop(context, true);
      } catch (e) {
        // Close the loading dialog
        Navigator.of(context).pop();

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
        title: Text("Add Task"),
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
                  validator: (value) => value == null || value.isEmpty ? "Enter task title" : null,
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
                  validator: (value) => value == null || value.isEmpty ? "Enter task description" : null,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dueDate == null
                            ? "No date chosen"
                            : "Due Date: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}",
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF),
                      ),
                      onPressed: () => _pickDueDate(context),
                      child: Text("Pick Date",  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: priorities.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
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
                    onPressed: _saveTask,
                    child: Text("Save Task", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}