import 'package:ecommerce_dashboard/Models/vendor/vendor_model.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/vendor/vendor_controller.dart';
import '../widget/add_discard_bottom_bar.dart';
import '../widget/entity_basic_info.dart';
import '../widget/entity_thumbnail_info.dart';

class AddVendorDesktop extends StatelessWidget {
  const AddVendorDesktop({super.key, required this.vendorModel});

  final VendorModel vendorModel;

  @override
  Widget build(BuildContext context) {
    final VendorController vendorController = Get.find<VendorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vendor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: EntityBasicInfo(
                      controller: vendorController,
                      entityType: EntityType.vendor),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: EntityThumbnailInfo(
                      controller: vendorController,
                      entityType: EntityType.vendor),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AddDiscardBottomBar(
        model: vendorModel,
        controller: vendorController,
        entityType: EntityType.vendor,
      ),
    );
  }
}
