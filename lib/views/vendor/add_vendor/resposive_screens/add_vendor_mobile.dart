import 'package:ecommerce_dashboard/views/vendor/add_vendor/widget/entity_thumbnail_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/vendor/vendor_controller.dart';
import '../../../../controllers/address/address_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../widget/add_discard_bottom_bar.dart';
import '../widget/entity_basic_info.dart';
import '../widget/entity_address_info.dart';

class AddVendorMobile extends StatelessWidget {
  const AddVendorMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorController vendorController = Get.put(VendorController());
    final AddressController addressController = Get.put(AddressController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vendor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: vendorController.addVendorKey,
          child: Column(
            children: [
              EntityThumbnailInfo(
                  controller: vendorController, entityType: EntityType.vendor),
              const SizedBox(height: 20),
              EntityBasicInfo(
                  controller: vendorController, entityType: EntityType.vendor),
              const SizedBox(height: 20),
              EntityAddressInfo(
                  controller: addressController, entityType: EntityType.vendor),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddDiscardBottomBar(
        model: vendorController,
        controller: vendorController,
        entityType: EntityType.vendor,
      ),
    );
  }
}
