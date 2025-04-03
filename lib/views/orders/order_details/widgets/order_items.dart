import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:get/get.dart';


import '../../../../Models/orders/order_item_model.dart';
import '../../../../Models/products/product_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    final subTotal = order.orderItems?.fold(
      0.0,
          (previousValue, element) => previousValue + (element.price * element.quantity),
    ) ?? 0.0; // Ensure it's never null

    final subTotalValue = subTotal + (order.discount);
    final total = subTotal + (order.tax) + (order.shippingFee) - (order.discount);


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
                decoration: const BoxDecoration(color: TColors.primaryBackground),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Image', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Item', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Price', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Qty', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total', style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),

              // Table Data Rows
              ...order.orderItems?.map((item) {
                return TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TRoundedImage(
                        height: 60,
                        width: 60,
                        imageurl: TImages.productImage1,
                        backgroundColor: TColors.primaryBackground,
                        isNetworkImage: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        productController.allProducts.firstWhere(
                                (product) => product.productId == item.productId,
                            orElse: () => ProductModel(name: 'Not Found') // Handle missing cases
                        ).name ?? 'Not Found',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text((item.price/item.quantity).toStringAsFixed(2), style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.quantity.toString(), style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text((item.price).toStringAsFixed(2), style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ],
                );
              }) ?? [],
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Summary Section
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                _buildSummaryRow(context, 'SubTotal',  Text(subTotalValue.toStringAsFixed(2))),
                _buildSummaryRow(context, 'Discount',  Text(order.discount.toStringAsFixed(2))),
                _buildSummaryRow(context, 'Shipping',  Text(order.shippingFee.toStringAsFixed(2))),
                _buildSummaryRow(context, 'Tax',  Text(order.tax.toStringAsFixed(2))),
                const Divider(),
                _buildSummaryRow(context, 'Total',  Text(total.toStringAsFixed(2))),
              ],
            ),
          ),
        ],
      ),
    );
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
