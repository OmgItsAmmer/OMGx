import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/Navigation/widgets/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/navigation/navigation_controller.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final RxBool isMinimized = false.obs; // Sidebar state
    Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Row(
        children: [
          Obx(() => MouseRegion(
                onEnter: (_) => isMinimized.value = false, // Maximize on hover
                onExit: (_) =>
                    isMinimized.value = true, // Minimize when not hovered
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 300), // Smooth transition
                  curve: Curves.easeInOut,
                  width: isMinimized.value ? 70 : 230, // Adjust width
                  color: Colors.black,
                  child: Column(
                    children: [
                      // Side Menu Items with smooth visibility transition
                      Expanded(
                        child: Column(
                          children: [
                            SideMenuItem(
                              icon: const Icon(Iconsax.home),
                              title: 'Analytics',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(0),
                              isSelected: controller.selectedIndex.value == 0,
                            ),
                            SideMenuItem(
                              icon: const Icon(Iconsax.shop),
                              title: 'Products',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(1),
                              isSelected: controller.selectedIndex.value == 1,
                            ),
                            SideMenuItem(
                              icon: const Icon(Iconsax.heart),
                              title: 'Orders',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(2),
                              isSelected: controller.selectedIndex.value == 2,
                            ),
                            SideMenuItem(
                              icon: const Icon(Iconsax.heart_slash),
                              title: 'Brands',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(3),
                              isSelected: controller.selectedIndex.value == 3,
                            ),
                            SideMenuItem(
                              icon: const Icon(Iconsax.heart_slash),
                              title: 'Category',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(4),
                              isSelected: controller.selectedIndex.value == 4,
                            ),
                            SideMenuItem(
                              icon: const Icon(Iconsax.message),
                              title: 'Reviews',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(5),
                              isSelected: controller.selectedIndex.value == 5,
                            ),
                            const Spacer(),
                            SideMenuItem(
                              icon: const Icon(Iconsax.user),
                              title: 'Profile',
                              isMinimized: isMinimized.value,
                              onTap: () => controller.selectScreen(6),
                              isSelected: controller.selectedIndex.value == 6,
                            ),

                            const SizedBox(height: TSizes.spaceBtwInputFields,),

                            const Column(
                              children: [
                                Divider(height: 2,thickness: 2,),
                                 SizedBox(height: TSizes.spaceBtwInputFields,),
                                Text('Version 0.1'),

                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields,),
                            


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
            child:
                Obx(() => controller.screens[controller.selectedIndex.value]),
          ),
        ],
      ),
    );
  }
}
