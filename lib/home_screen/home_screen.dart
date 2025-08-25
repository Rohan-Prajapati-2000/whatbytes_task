import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatbytes_task/add_task_screen/add_task_screen.dart';
import 'package:whatbytes_task/animation/loading_animation.dart';
import 'package:whatbytes_task/controller/auth_controller.dart';
import 'package:whatbytes_task/controller/task_controller.dart';
import '../edit_task_screen/edit_task_screen.dart';
import '../model/task_model.dart';

class HomeScreen extends StatelessWidget {
  final taskController = Get.put(TaskController());
  final authController = Get.put(AuthController());
  final RxString selectedFilter = 'dueDate'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6C63FF),
        onPressed: _navigateToAddTask,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Stack(
            children: [
              // Purple Header Background
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFF6C63FF)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 16,
                    right: 16,
                    bottom: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.tableCells,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  hintText: "Search",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              authController.logout();
                            },
                            child: Obx(() {
                              if (authController.isLoading.value) {
                                return LoadingAnimation();
                              }
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(Icons.logout, color: Colors.white, size: 18),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today, ${DateFormat('d, MMM').format(DateTime.now())}",
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "My tasks",
                                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Due Date Filter
                                Row(
                                  children: [
                                    Obx(() => Radio<String>(
                                      value: 'dueDate',
                                      groupValue: selectedFilter.value,
                                      activeColor: Colors.white,
                                      onChanged: (value) {
                                        selectedFilter.value = value!;
                                      },
                                    )),
                                    const Text("Due Date", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),

                                // Priority Filter
                                Row(
                                  children: [
                                    Obx(() => Radio<String>(
                                      value: 'priority',
                                      groupValue: selectedFilter.value,
                                      activeColor: Colors.white,
                                      onChanged: (value) {
                                        selectedFilter.value = value!;
                                      },
                                    )),
                                    const Text("Priority", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),

                                // Status Filter
                                Row(
                                  children: [
                                    Obx(() => Radio<String>(
                                      value: 'status',
                                      groupValue: selectedFilter.value,
                                      activeColor: Colors.white,
                                      onChanged: (value) {
                                        selectedFilter.value = value!;
                                      },
                                    )),
                                    const Text("Status", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -40,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (taskController.isLoading.value) {
                return Center(
                  child: LoadingAnimation(),
                );
              }

              List<Task> filteredTasks = taskController.tasks.toList();

              // Apply filtering based on selected option
              if (selectedFilter.value == 'dueDate') {
                // Sort by due date (ascending)
                filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
              } else if (selectedFilter.value == 'priority') {
                // Sort by priority (high -> medium -> low)
                filteredTasks.sort((a, b) {
                  final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
                  return priorityOrder[a.priority.toLowerCase()]!.compareTo(
                      priorityOrder[b.priority.toLowerCase()]!
                  );
                });
              } else if (selectedFilter.value == 'status') {
                // Show incomplete tasks first, then completed tasks
                List<Task> incompleteTasks = filteredTasks.where((task) => !task.isCompleted).toList();
                List<Task> completedTasks = filteredTasks.where((task) => task.isCompleted).toList();
                filteredTasks = [...incompleteTasks, ...completedTasks];
              }

              if (filteredTasks.isEmpty) {
                return const Center(
                  child: Text(
                    "No tasks available",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  Task task = filteredTasks[index];
                  return _taskItem(task);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // New function to navigate to AddTaskScreen
  void _navigateToAddTask() async {
    final result = await Get.to(() => AddTaskScreen());

    if (result == true) {
      // Refresh the task list
      taskController.fetchTask();
    }
  }

  Widget _taskItem(Task task) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        taskController.deleteTask(task.id);
        Get.snackbar("Success", "Task deleted successfully");
      },
      child: GestureDetector(
        onLongPress: () {
          Get.to(() => EditTaskScreen(task: task));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  task.isCompleted = value ?? false;
                  taskController.updateTask(task);
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      task.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    // Due Date
                    Text(
                      DateFormat('d MMM yyyy').format(task.dueDate),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              tag(task.priority),
            ],
          ),
        ),
      ),
    );
  }

  Widget tag(String text) {
    Color color;
    switch (text.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}