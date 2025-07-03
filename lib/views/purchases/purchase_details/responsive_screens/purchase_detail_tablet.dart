import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/purchase/purchase_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/widgets/vendor_info.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/widgets/purchase_transaction.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/widgets/purchase_info.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/widgets/purchase_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/purchase/purchase_model.dart';
import '../../../../controllers/vendor/vendor_controller.dart';
import '../../../../utils/constants/enums.dart';

class PurchaseDetailTabletScreen extends StatelessWidget {
  const PurchaseDetailTabletScreen({super.key, required this.purchaseModel});

  final PurchaseModel purchaseModel;

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    final VendorController vendorController = Get.find<VendorController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Purchase info and items
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      PurchaseInfo(purchaseModel: purchaseModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      PurchaseItems(purchase: purchaseModel),
                    ],
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                // Right column - Vendor info
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      VendorInfo(
                        mediaCategory: MediaCategory.vendors,
                        title: 'Vendor',
                        showAddress: true,
                        fullName:
                            vendorController.selectedVendor.value.fullName,
                        email: vendorController.selectedVendor.value.email,
                        phoneNumber:
                            vendorController.selectedVendor.value.phoneNumber,
                        isLoading: vendorController.isLoading.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Transaction Section
            PurchaseTransaction(purchaseModel: purchaseModel),
          ],
        ),
      ),
    );
  }
}
