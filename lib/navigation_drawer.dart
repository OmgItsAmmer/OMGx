import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/views/orders/orderScreen.dart'; // Import your screen widgets
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';

import 'controllers/navigation/navigation_controller.dart'; // Your helper functions

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: dark ? TColors.black : TColors.white,
        iconTheme: IconThemeData(
          color: dark ? TColors.white : TColors.black,
        ),
      ),
      drawer: Drawer(
        backgroundColor: dark ? TColors.black : TColors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: dark ? TColors.black : TColors.primary,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.shop, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Admin Panel',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Iconsax.home),
              title: const Text('Analytics'),
              onTap: () => controller.selectScreen(0),
            ),
            ListTile(
              leading: const Icon(Iconsax.shop),
              title: const Text('Products'),
              onTap: () => controller.selectScreen(1),
            ),
            ListTile(
              leading: const Icon(Iconsax.heart),
              title: const Text('Orders'),
              onTap: () => controller.selectScreen(2),
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Profile'),
              onTap: () => controller.selectScreen(3),
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}
