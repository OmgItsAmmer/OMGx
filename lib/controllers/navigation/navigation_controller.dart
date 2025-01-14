import 'package:admin_dashboard_v3/views/brands/brands.dart';
import 'package:admin_dashboard_v3/views/orders/orderScreen.dart';
import 'package:admin_dashboard_v3/views/products/products.dart';
import 'package:admin_dashboard_v3/views/settings/settings.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../views/Reviews/reviews.dart';
import '../../views/category/categoriy_screen.dart';

// Example of controller for Wishlist
class WishlistController extends GetxController {
  // Add your WishlistController logic here if needed.
}

// The NavigationController will handle the selected index and navigate to the correct screen.
class NavigationController extends GetxController {
  // Observable for selected index
  final Rx<int> selectedIndex = 0.obs;

  // List of screens for navigation
  final screens = [
    const Orderscreen(),
    const ProductScreen(),
    const Orderscreen(),
    const BrandScreen(),
    const CategoryScreen(),
    const ReviewScreen(),
    const SettingsScreen()
  ];

  // Update the selected index and update the body
  void selectScreen(int index) {
    selectedIndex.value = index;
  }
}
