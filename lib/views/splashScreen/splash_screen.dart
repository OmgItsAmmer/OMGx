import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

import '../../main.dart';
import '../../routes/routes.dart'; // For navigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
 // final SupabaseClient _supabase = Supabase.instance.client; // Supabase instance

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
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Check if the user is logged in using Supabase
        bool isLoggedIn = await checkIfUserIsLoggedIn();

        // Navigate to the appropriate screen
        if (isLoggedIn) {
          Get.offAllNamed(TRoutes.dashboard); // Navigate to Dashboard
        } else {
          Get.offAllNamed(TRoutes.login); // Navigate to Login
        }
      }
    });
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    try {
      // Check if there's an active session
      final Session? session = supabase.auth.currentSession;
      return session != null; // Return true if the session exists
    } catch (e) {
      // Handle any errors (e.g., network issues)
      print("Error checking authentication: $e");
      return false; // Assume the user is not logged in if there's an error
    }
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