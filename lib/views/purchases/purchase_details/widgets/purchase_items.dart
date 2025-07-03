import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/purchase/purchase_model.dart';
import '../../../../Models/products/product_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../repositories/products/product_variants_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';

class PurchaseItems extends StatelessWidget {
  const PurchaseItems({super.key, required this.purchase});
  final PurchaseModel purchase;

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final MediaController mediaController = Get.find<MediaController>();
    final ProductVariantsRepository variantsRepository =
        Get.put(ProductVariantsRepository());

    final subTotal = purchase.purchaseItems?.fold(
          0.0,
          (previousValue, element) => previousValue + element.price,
        ) ??
        0.0; // Ensure it's never null

    // Calculate the discount amount based on the percentage
    final discountAmount = subTotal * (purchase.discount / 100);

    // Calculate the total before any additional charges
    final totalBeforeCharges =
        subTotal + (purchase.tax) + (purchase.shippingFee) - discountAmount;

    // Calculate the actual grand total
    double grandTotal = _calculateGrandTotal(
      subTotal: subTotal,
      discount: discountAmount, // Pass the calculated discount amount
      tax: purchase.tax,
      shippingFee: purchase.shippingFee,
    );

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Flutter Table
          Table(
            border: TableBorder.all(color: Colors.grey),
            columnWidths: const {
              0: FixedColumnWidth(65), // Image
              1: FlexColumnWidth(), // Name
              2: FixedColumnWidth(80), // Price
              3: FixedColumnWidth(80), // Quantity
              4: FixedColumnWidth(100), // Total
            },
            children: [
              // Table Header
              TableRow(
                decoration:
                    const BoxDecoration(color: TColors.primaryBackground),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Image',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Item',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Price',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Qty',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),

              // Table Data Rows
              ...purchase.purchaseItems?.map((item) {
                    final product = productController.allProducts.firstWhere(
                        (product) => product.productId == item.productId,
                        orElse: () => ProductModel(name: 'Not Found'));

                    // Create a widget to display product info with or without serial number
                    Widget productInfoWidget = FutureBuilder<String>(
                      future: _getProductDisplayName(
                          product, item, variantsRepository),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TShimmerEffect(
                              width: double.infinity, height: 20);
                        } else {
                          return Text(
                            snapshot.data ?? product.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        }
                      },
                    );

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<String?>(
                            future: mediaController.fetchMainImage(
                              item.productId,
                              MediaCategory.products.toString().split('.').last,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const TShimmerEffect(
                                    width: 60,
                                    height: 60); // Show shimmer while loading
                              } else if (snapshot.hasError) {
                                return const Text(
                                    'Error loading image'); // Handle error case
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return TRoundedImage(
                                  isNetworkImage: true,
                                  width: 60,
                                  height: 60,
                                  imageurl: snapshot.data!,
                                );
                              } else {
                                return const TCircularIcon(
                                  icon: Iconsax.image,
                                  width: 60,
                                  height: 60,
                                  backgroundColor: TColors.primaryBackground,
                                ); // Handle case where no image is available
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: productInfoWidget,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              (item.price / item.quantity).toStringAsFixed(2),
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.quantity.toString(),
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text((item.price).toStringAsFixed(2),
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    );
                  }) ??
                  [],
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Summary Section
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                _buildSummaryRow(context, 'SubTotal',
                    Text('Rs. ${subTotal.toStringAsFixed(2)}')),
                _buildSummaryRow(
                    context,
                    'Discount',
                    Text(
                        '${purchase.discount}% (Rs. ${discountAmount.toStringAsFixed(2)})')),
                _buildSummaryRow(context, 'Shipping',
                    Text('Rs. ${purchase.shippingFee.toStringAsFixed(2)}')),
                _buildSummaryRow(context, 'Tax',
                    Text('Rs. ${purchase.tax.toStringAsFixed(2)}')),
                const Divider(),
                _buildSummaryRow(
                    context,
                    'Total',
                    Text(
                      'Rs. ${grandTotal.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: TColors.primary),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get the product display name with serial number if available
  Future<String> _getProductDisplayName(ProductModel product,
      PurchaseItemModel item, ProductVariantsRepository repository) async {
    String displayName = product.name ?? 'Not Found';

    // Check if this is a serialized product and has a variant ID
    if (product.hasSerialNumbers && item.variantId != null) {
      try {
        // Fetch the variant information
        final variants =
            await repository.fetchProductVariants(product.productId ?? -1);
        final variant =
            variants.firstWhereOrNull((v) => v.variantId == item.variantId);

        if (variant != null && variant.serialNumber.isNotEmpty) {
          // Append the serial number to the product name
          displayName = '$displayName (${variant.serialNumber})';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching variant: $e');
        }
      }
    }

    return displayName;
  }

  // Calculate grand total
  double _calculateGrandTotal({
    required double subTotal,
    required double discount,
    required double tax,
    required double shippingFee,
  }) {
    // Start with the base purchase total
    double grandTotal =
        subTotal - discount + tax + shippingFee; // Apply discount first

    return grandTotal;
  }

  Widget _buildSummaryRow(BuildContext context, String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleLarge),
          value,
        ],
      ),
    );
  }
}
