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

class PurchaseDetailMobileScreen extends StatelessWidget {
  const PurchaseDetailMobileScreen({super.key, required this.purchaseModel});

  final PurchaseModel purchaseModel;

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    final VendorController vendorController = Get.find<VendorController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purchase Info with a custom wrapper for mobile
            Theme(
              // Override theme for the purchase info section to fix status dropdown
              data: Theme.of(context).copyWith(
                dropdownMenuTheme: DropdownMenuThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    constraints: const BoxConstraints(
                      maxWidth: 120, // Constrain width for mobile
                    ),
                  ),
                ),
              ),
              child: PurchaseInfo(purchaseModel: purchaseModel),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Purchase Items with custom scaling for mobile
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  // Use a fixed width container for horizontal scrolling
                  width: MediaQuery.of(context).size.width * 1.2,
                  child: PurchaseItems(purchase: purchaseModel),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Transaction Info
            PurchaseTransaction(purchaseModel: purchaseModel),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Vendor Info
            VendorInfo(
              mediaCategory: MediaCategory.vendors,
              title: 'Vendor',
              showAddress: true,
              fullName: vendorController.selectedVendor.value.fullName,
              email: vendorController.selectedVendor.value.email,
              phoneNumber: vendorController.selectedVendor.value.phoneNumber,
              isLoading: vendorController.isLoading.value,
            ),
          ],
        ),
      ),
    );
  }
}
