import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/views/collections/all_collections/responsive_screens/all_collections_desktop.dart';
import 'package:ecommerce_dashboard/views/collections/all_collections/responsive_screens/all_collections_tablet.dart';
import 'package:ecommerce_dashboard/views/collections/all_collections/responsive_screens/all_collections_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCollections extends StatelessWidget {
  const AllCollections({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure CollectionController is initialized properly
    final controller = Get.put(CollectionController());

    // Reset controller state when navigating to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearForm();
      controller.fetchCollections();
    });

    return const TSiteTemplate(
      desktop: AllCollectionsDesktopScreen(),
      tablet: AllCollectionsTabletScreen(),
      mobile: AllCollectionsMobileScreen(),
    );
  }
}
