import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loading_animation.json', // Update with your Lottie file path
        width: 100,
        height: 100,
        fit: BoxFit.fill,
      ),
    );
  }
}