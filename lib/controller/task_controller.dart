import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/task_model.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var tasks = <Task>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTask();
  }

  void fetchTask() async{
    isLoading.value = true;
    final currentUser  = FirebaseAuth.instance.currentUser ;
    if (currentUser  == null) {
      Get.snackbar("Error", "No user logged in");
      isLoading.value = false;
      return;
    }

    firebaseFirestore
        .collection("users")
        .doc(currentUser .uid)
        .collection("tasks")
        .orderBy("dueDate")
        .snapshots()
        .listen((snapshot) {
      tasks.value = snapshot.docs.map((e) => Task.fromMap(e.data())).toList();
      isLoading.value = false;
    });
  }

  Future<void> addNewTask(Task task) async {
    try {
      final currentUser  = FirebaseAuth.instance.currentUser ;
      await firebaseFirestore
          .collection("users")
          .doc(currentUser !.uid)
          .collection("tasks")
          .doc(task.id)
          .set(task.toMap());

      Get.snackbar("Success", "Task added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add task: $e");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final currentUser  = FirebaseAuth.instance.currentUser ;
      await firebaseFirestore
          .collection("users")
          .doc(currentUser !.uid)
          .collection("tasks")
          .doc(task.id)
          .update(task.toMap());

      Get.snackbar("Success", "Task updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update task: $e");
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final currentUser  = FirebaseAuth.instance.currentUser ;
      await firebaseFirestore
          .collection("users")
          .doc(currentUser !.uid)
          .collection("tasks")
          .doc(id)
          .delete();

      Get.snackbar("Deleted", "Task removed");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete task: $e");
    }
  }
}