import 'package:admin_dashboard_v3/Models/vendor/vendor_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../table/vendor_order_table.dart';
import '../widgets/entity_shipping_info.dart';
import '../widgets/entity_advance_info_card.dart';

class VendorDetailTablet extends StatelessWidget {
  const VendorDetailTablet({super.key, required this.vendorModel});
  final VendorModel vendorModel;

  @override
  Widget build(BuildContext context) {
    // Initialize the order controller and fetch orders for this vendor
    final OrderController orderController = Get.find<OrderController>();

    // Fetch orders for this vendor when the view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vendorModel.vendorId != null) {
        orderController.fetchEntityOrders(vendorModel.vendorId!, 'Vendor');
        orderController.setRecentOrderDay();
        orderController.setAverageTotalAmount();
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
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
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Add horizontal scroll for table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 2 * TSizes.md,
                      child: const VendorOrderTable(),
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
