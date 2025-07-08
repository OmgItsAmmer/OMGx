import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../Models/products/product_model.dart';
import '../../../../Models/products/product_variant_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../repositories/products/product_variants_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../repositories/installment/installment_repository.dart';
import '../../../../Models/installments/installemt_plan_model.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final MediaController mediaController = Get.find<MediaController>();
    final ProductVariantsRepository variantsRepository =
        Get.put(ProductVariantsRepository());
    final InstallmentRepository installmentRepository =
        Get.put(InstallmentRepository());

    final subTotal = order.orderItems?.fold(
          0.0,
          (previousValue, element) => previousValue + element.price,
        ) ??
        0.0; // Ensure it's never null

    // Calculate the discount amount based on the percentage
    final discountAmount = subTotal * (order.discount / 100);

    // Calculate the total before installment charges
    final totalBeforeInstallmentCharges =
        subTotal + (order.tax) + (order.shippingFee) - discountAmount;

    return FutureBuilder<InstallmentPlanModel?>(
        future: order.saletype?.toLowerCase() == 'installment'
            ? _getInstallmentPlan(installmentRepository, order.orderId)
            : Future.value(null),
        builder: (context, snapshot) {
          final installmentPlan = snapshot.data;

          // Calculate commission amount - Based on subtotal after discount
          double commissionAmount = 0.0;
          if (order.salesmanComission > 0) {
            // Base for commission is usually the net item value
            final commissionBase = subTotal - discountAmount;
            commissionAmount = commissionBase * order.salesmanComission / 100;
          }

          // Calculate the actual grand total including all components
          double grandTotal = _calculateGrandTotal(
              subTotal: subTotal,
              discount: discountAmount, // Pass the calculated discount amount
              tax: order.tax,
              shippingFee: order.shippingFee,
              commissionAmount: commissionAmount, // Pass calculated commission
              installmentPlan: installmentPlan);

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
                    ...order.orderItems?.map((item) {
                          final product = productController.allProducts
                              .firstWhere(
                                  (product) =>
                                      product.productId == item.productId,
                                  orElse: () =>
                                      ProductModel(name: 'Not Found'));

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
                                  snapshot.data ?? product.name ?? 'Not Found',
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
                                    MediaCategory.products
                                        .toString()
                                        .split('.')
                                        .last,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const TShimmerEffect(
                                          width: 60,
                                          height:
                                              60); // Show shimmer while loading
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
                                        backgroundColor:
                                            TColors.primaryBackground,
                                      ); // Handle case where no image is available
                                      // Handle case where no image is available
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
                                    (item.price / item.quantity)
                                        .toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item.quantity.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text((item.price).toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
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
                              '${order.discount}% (Rs. ${discountAmount.toStringAsFixed(2)})')),
                      _buildSummaryRow(context, 'Shipping',
                          Text('Rs. ${order.shippingFee.toStringAsFixed(2)}')),
                      _buildSummaryRow(context, 'Tax',
                          Text('Rs. ${order.tax.toStringAsFixed(2)}')),

                      // Salesman Commission (always shown)
                      if (order.salesmanComission > 0)
                        _buildSummaryRow(
                            context,
                            'Salesman Commission',
                            Text(
                                '${order.salesmanComission}% (Rs. ${commissionAmount.toStringAsFixed(2)})')),

                      // Installment-specific rows (only shown for installment sales)
                      if (order.saletype?.toLowerCase() == 'installment' &&
                          installmentPlan != null) ...[
                        const Divider(),
                        // Advance Payment
                        _buildSummaryRow(
                            context,
                            'Advance Payment (Already Added)',
                            Text(
                                'Rs. ${double.tryParse(installmentPlan.downPayment) ?? 0.0}')),
                        // Document Charges
                        if (installmentPlan.documentCharges != null &&
                            installmentPlan.documentCharges!.isNotEmpty)
                          _buildSummaryRow(
                              context,
                              'Document Charges',
                              Text(
                                  'Rs. ${double.tryParse(installmentPlan.documentCharges!) ?? 0.0}')),
                        // Other Charges
                        if (installmentPlan.otherCharges != null &&
                            installmentPlan.otherCharges!.isNotEmpty)
                          _buildSummaryRow(
                              context,
                              'Other Charges',
                              Text(
                                  'Rs. ${double.tryParse(installmentPlan.otherCharges!) ?? 0.0}')),
                        // Margin
                        if (installmentPlan.margin != null &&
                            installmentPlan.margin!.isNotEmpty)
                          _buildSummaryRow(
                              context,
                              'Margin',
                              Text(
                                  '${double.tryParse(installmentPlan.margin!) ?? 0.0}% (Rs. ${_calculateMarginAmount(subTotal - discountAmount, installmentPlan)})')),
                      ],

                      const Divider(),
                      _buildSummaryRow(
                          context,
                          'Total',
                          Text(
                            'Rs. ${grandTotal.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TColors.primary),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  // Helper method to get the product display name with serial number if available
  Future<String> _getProductDisplayName(ProductModel product,
      OrderItemModel item, ProductVariantsRepository repository) async {
    String displayName = product.name ?? 'Not Found';

    // Check if this is a serialized product and has a variant ID
    if ( item.variantId != null) {
      try {
        // Fetch the variant information
        final variants =
            await repository.fetchProductVariants(product.productId ?? -1);
        final variant =
            variants.firstWhereOrNull((v) => v.variantId == item.variantId);

        if (variant != null ) {
          // Append the serial number to the product name
          displayName = '$displayName (${variant.variantName})';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching variant: $e');
        }
      }
    }

    return displayName;
  }

  // Helper method to fetch installment plan for an order
  Future<InstallmentPlanModel?> _getInstallmentPlan(
      InstallmentRepository repository, int orderId) async {
    try {
      final planId = await repository.fetchPlanId(orderId);
      if (planId != null) {
        return await repository.fetchInstallmentPlan(planId);
      }
      return null;
    } catch (e) {
      print('Error fetching installment plan: $e');
      return null;
    }
  }

  // Calculate margin amount based on installment plan and base amount
  String _calculateMarginAmount(
      double baseAmountForMargin, InstallmentPlanModel plan) {
    double downPayment = double.tryParse(plan.downPayment) ?? 0.0;
    double marginPercentage = double.tryParse(plan.margin ?? '0.0') ?? 0.0;

    // Margin is usually calculated on the amount financed after downpayment
    double financedBase = baseAmountForMargin - downPayment;
    if (financedBase < 0) financedBase = 0; // Ensure not negative
    double marginAmount = financedBase * (marginPercentage / 100.0);

    return marginAmount.toStringAsFixed(2);
  }

  // Calculate grand total including installment-specific charges
  double _calculateGrandTotal(
      {required double subTotal,
      required double discount,
      required double tax,
      required double shippingFee,
      required double commissionAmount,
      required InstallmentPlanModel? installmentPlan}) {
    // Start with the base order total
    double grandTotal =
        subTotal - discount + tax + shippingFee; // Apply discount first

    // Add installment specific charges if applicable
    if (installmentPlan != null) {
      // Add document charges
      if (installmentPlan.documentCharges != null &&
          installmentPlan.documentCharges!.isNotEmpty) {
        grandTotal += double.tryParse(installmentPlan.documentCharges!) ?? 0.0;
      }

      // Add other charges
      if (installmentPlan.otherCharges != null &&
          installmentPlan.otherCharges!.isNotEmpty) {
        grandTotal += double.tryParse(installmentPlan.otherCharges!) ?? 0.0;
      }

      // Add margin amount
      double baseAmountForMargin = subTotal - discount;
      double downPayment = double.tryParse(installmentPlan.downPayment) ?? 0.0;
      double marginPercentage =
          double.tryParse(installmentPlan.margin ?? '0.0') ?? 0.0;

      if (marginPercentage > 0) {
        double financedBase = baseAmountForMargin - downPayment;
        if (financedBase < 0) financedBase = 0; // Ensure not negative
        double marginAmount = financedBase * (marginPercentage / 100.0);
        grandTotal += marginAmount;
      }
    }

    // Add commission amount
    grandTotal += commissionAmount;

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
