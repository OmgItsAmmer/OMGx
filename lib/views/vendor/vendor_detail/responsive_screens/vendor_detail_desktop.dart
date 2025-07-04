import 'package:ecommerce_dashboard/Models/vendor/vendor_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../table/vendor_order_table.dart';
import '../widgets/entity_shipping_info.dart';
import '../widgets/entity_advance_info_card.dart';

class VendorDetailDesktop extends StatelessWidget {
  const VendorDetailDesktop({super.key, required this.vendorModel});
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

    return Expanded(
      child: SizedBox(
        // height: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vendor Detail",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //vendor Info
                          EntityAdvanceInfoCard(
                            model: vendorModel,
                            entityType: EntityType.vendor,
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),

                          //shipping info
                          EntityShippingInfo(
                            model: vendorModel,
                            entityType: EntityType.vendor,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: TSizes.spaceBtwSections/2,
                    // ),
                    Expanded(
                        flex: 2,
                        child: TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.defaultSpace),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Purchases',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: TSizes.spaceBtwSections,
                                ),
                                const VendorPurchaseTable(),
                              ],
                            )))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
