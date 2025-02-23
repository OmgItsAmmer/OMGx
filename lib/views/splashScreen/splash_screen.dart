import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For navigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Initialize animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start animation
    _controller.forward();

    // Navigate to the next screen after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offAllNamed('/dashboard'); // Replace with your desired route
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your background color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              TImages.darkAppLogo, // Replace with your logo
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}