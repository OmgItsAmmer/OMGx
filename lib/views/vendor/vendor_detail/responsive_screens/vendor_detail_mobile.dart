import 'package:admin_dashboard_v3/Models/vendor/vendor_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/purchase/purchase_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../table/vendor_order_table.dart';
import '../widgets/entity_shipping_info.dart';
import '../widgets/entity_advance_info_card.dart';

class VendorDetailMobile extends StatelessWidget {
  const VendorDetailMobile({super.key, required this.vendorModel});
  final VendorModel vendorModel;

  @override
  Widget build(BuildContext context) {
    // Initialize the order controller and fetch orders for this vendor

    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    // Fetch orders for this vendor when the view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vendorModel.vendorId != null) {
        purchaseController.fetchVendorPurchases(vendorModel.vendorId!);
        purchaseController.setRecentPurchaseDay();
        purchaseController.setAverageTotalAmount();
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vendor Detail",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Vendor Info
            EntityAdvanceInfoCard(
              model: vendorModel,
              entityType: EntityType.vendor,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Shipping Info
            EntityShippingInfo(
              model: vendorModel,
              entityType: EntityType.vendor,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Orders Section
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Add horizontal scroll for table on mobile
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 800, // Fixed width for mobile table scrolling
                      child: VendorPurchaseTable(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
