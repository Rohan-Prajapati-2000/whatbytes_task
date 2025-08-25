import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatbytes_task/animation/loading_animation.dart';
import 'package:whatbytes_task/signup_screen/signup_screen.dart';

import '../controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final authController = Get.put(AuthController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx((){
          if(authController.isLoading.value){
            return const LoadingAnimation();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Icon with decoration
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 30),

                // Email TextField
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "EMAIL ADDRESS",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(height: 3),
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: authController.emailController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password TextField
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PASSWORD",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: authController.passwordController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Sign Up Button
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      authController.loginAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Or sign up with
                const Text(
                  "or log in with",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(FontAwesomeIcons.facebookF, Color(0xff2110b3)),
                    const SizedBox(width: 20),
                    _socialButton(FontAwesomeIcons.google, Colors.red),
                    const SizedBox(width: 20),
                    _socialButton(FontAwesomeIcons.apple, Colors.black),
                  ],
                ),
                const SizedBox(height: 30),

                // Already an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(()=> SignUpScreen());
                      },
                      child: const Text(
                        "Get Started!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        })
      ),
    );
  }

  // Social Button Widget
  Widget _socialButton(IconData icon, Color color) {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 15,
      ),
    );
  }
}
