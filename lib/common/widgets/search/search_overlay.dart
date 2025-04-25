import 'package:admin_dashboard_v3/controllers/search/search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSearchOverlay extends StatelessWidget {
  const TSearchOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TSearchController searchController = TSearchController.instance;

    return Obx(() {
      if (!searchController.isSearchOverlayVisible.value) {
        return const SizedBox.shrink();
      }

      final isDesktop = TDeviceUtils.isDesktopScreen(context);
      final double topPadding = isDesktop ? 0 : kToolbarHeight;

      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Semi-transparent backdrop
            GestureDetector(
              onTap: searchController.toggleSearchOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

            // Search results container
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: topPadding,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: 1.0,
                child: Column(
                  children: [
                    // Search results container
                    Container(
                      color: TColors.white,
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search field (only visible in tablet/mobile)
                          if (!isDesktop)
                            TextFormField(
                              controller: searchController.searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search Anything',
                                prefixIcon: const Icon(Iconsax.search_normal),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: searchController.clearSearch,
                                ),
                              ),
                              onChanged: (value) {
                                searchController.filterSearchResults(value);
                              },
                            ),

                          if (!isDesktop)
                            const SizedBox(height: TSizes.spaceBtwItems),

                          // Search results
                          Obx(() {
                            final filteredItems =
                                searchController.filteredItems;

                            if (filteredItems.isEmpty &&
                                searchController
                                    .searchController.text.isNotEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(TSizes.md),
                                child: Text('No results found'),
                              );
                            }

                            return Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                                minWidth: isDesktop ? 400 : double.infinity,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = filteredItems[index];
                                  return ListTile(
                                    title: Text(item.title),
                                    onTap: () =>
                                        searchController.navigateToRoute(item),
                                    leading: _getIconForRoute(item.title),
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper method to get an appropriate icon for each route
  Widget _getIconForRoute(String title) {
    switch (title.toLowerCase()) {
      case 'dashboard':
        return const Icon(Iconsax.home);
      case 'orders':
      case 'order details':
        return const Icon(Iconsax.shopping_bag);
      case 'products':
      case 'product details':
        return const Icon(Iconsax.box);
      case 'sales':
        return const Icon(Iconsax.money);
      case 'customers':
      case 'customer details':
      case 'add customer':
        return const Icon(Iconsax.user);
      case 'salesmen':
      case 'salesman details':
      case 'add salesman':
        return const Icon(Iconsax.user_tick);
      case 'installments':
        return const Icon(Iconsax.calendar);
      case 'brands':
      case 'brand details':
        return const Icon(Iconsax.crown);
      case 'categories':
      case 'category details':
        return const Icon(Iconsax.category);
      case 'profile':
        return const Icon(Iconsax.user_octagon);
      case 'store':
        return const Icon(Iconsax.shop);
      case 'media':
        return const Icon(Iconsax.gallery);
      case 'reports':
        return const Icon(Iconsax.document);
      case 'expenses':
        return const Icon(Iconsax.wallet);
      default:
        return const Icon(Iconsax.document);
    }
  }
}
