import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whatbytes_task/home_screen/home_screen.dart';
import 'package:whatbytes_task/signin_screen/signin_screen.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  void createAccount() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if (userCredential.user != null) {
        Get.to(() => SignInScreen());
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void loginAccount() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Kindly fill all the fields");
      return;
    }

    isLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Get.offAll(() => HomeScreen());
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        Get.snackbar("Error", "The email address is not valid.");
        break;
      case 'user-disabled':
        Get.snackbar("Error", "The user corresponding to the given email has been disabled.");
        break;
      case 'user-not-found':
        Get.snackbar("Error", "No user found for that email.");
        break;
      case 'wrong-password':
        Get.snackbar("Error", "Incorrect password. Please try again.");
        break;
      case 'email-already-in-use':
        Get.snackbar("Error", "The email address is already in use by another account.");
        break;
      case 'operation-not-allowed':
        Get.snackbar("Error", "Email/password accounts are not enabled.");
        break;
      case 'weak-password':
        Get.snackbar("Error", "The password must be at least 6 characters long.");
        break;
      default:
        Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    }
  }
}