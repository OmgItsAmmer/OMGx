import 'package:admin_dashboard_v3/controllers/dashboard/dashboard_controoler.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
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
  bool _isDataLoaded = false;

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

    // Initialize controllers and preload data
    _preloadData();

    // Navigate to the next screen after the animation completes
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && _isDataLoaded) {
        // Always redirect to login screen, regardless of session status
        // This ensures users must log in every time they start the app
        Get.offAllNamed(TRoutes.login);
      }
    });
  }

  Future<void> _preloadData() async {
    try {
      // Pre-initialize all required controllers in the background
      // These will be used in the dashboard after login
      final dashboardController = Get.put(DashboardController());
      final orderController = Get.put(OrderController());
      final productController = Get.put(ProductController());
      final customerController = Get.put(CustomerController());

      // Start fetching data in parallel
      // This will continue in the background even after navigation
      Future.wait([
       // dashboardController.initializeDashboard(),
        orderController.fetchOrders(),
        productController.fetchProducts(),
        customerController.fetchAllCustomers(),
      ]).then((_) {
        setState(() {
          _isDataLoaded = true;
          // If animation has completed already, navigate now
          if (_controller.status == AnimationStatus.completed) {
            Get.offAllNamed(TRoutes.login);
          }
        });
      });
    } catch (e) {
      // Continue with navigation even if preloading fails
      setState(() {
        _isDataLoaded = true;
      });
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
              TImages.omgLogo, // Replace with your logo
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
