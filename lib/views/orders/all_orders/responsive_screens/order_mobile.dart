import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class OrdersMobileScreen extends StatelessWidget {
  const OrdersMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for orders
    if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
      Get.put(TableSearchController(), tag: 'orders');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');
    final orderController = Get.find<OrderController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            // Controls section
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add search bar with full width for mobile
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.search_normal,
                                color: TColors.white),
                            hintText: 'Search by order ID, date, or status',
                          ),
                          onChanged: (value) {
                            // Update the search term
                            tableSearchController.searchTerm.value = value;
                          },
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      TCircularIcon(
                        icon: Iconsax.refresh,
                        backgroundColor: TColors.primary,
                        color: TColors.white,
                        onPressed: () {
                          orderController.fetchOrders();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Order Cards
            Obx(() {
              // Get the search term from the controller
              String searchTerm =
                  tableSearchController.searchTerm.value.toLowerCase();

              // Create a filtered orders list based on search term
              var filteredOrders = [
                ...orderController.allOrders
              ]; // Create a copy
              if (searchTerm.isNotEmpty) {
                filteredOrders = orderController.allOrders.where((order) {
                  // Add search criteria based on OrderModel properties
                  return order.orderId
                          .toString()
                          .toLowerCase()
                          .contains(searchTerm) ||
                      order.orderDate.toLowerCase().contains(searchTerm) ||
                      order.status.toLowerCase().contains(searchTerm) ||
                      order.totalPrice
                          .toString()
                          .toLowerCase()
                          .contains(searchTerm);
                }).toList();
              }

              // Sort orders by date (latest first) by default
              filteredOrders.sort((a, b) => DateTime.parse(b.orderDate)
                  .compareTo(DateTime.parse(a.orderDate)));

              if (filteredOrders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      'No orders found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return OrderCard(
                    order: order,
                    onView: () async {
                      await orderController.setUpOrderDetails(order);
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onView;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date
    DateTime orderDate = DateTime.parse(order.orderDate);
    String formattedDate = DateFormat('MMM dd, yyyy').format(orderDate);

    // Determine status color
    Color statusColor;
    IconData statusIcon;

    switch (order.status.toLowerCase()) {
      case 'completed':
        statusColor = TColors.success;
        statusIcon = Iconsax.tick_circle;
        break;
      case 'pending':
        statusColor = TColors.warning;
        statusIcon = Iconsax.timer;
        break;
      case 'cancelled':
        statusColor = TColors.error;
        statusIcon = Iconsax.close_circle;
        break;
      case 'processing':
        statusColor = TColors.info;
        statusIcon = Iconsax.refresh;
        break;
      default:
        statusColor = TColors.grey;
        statusIcon = Iconsax.info_circle;
    }

    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header with ID and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.document, size: 20, color: TColors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Order #${order.orderId}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: TSizes.sm),
          const Divider(),
          const SizedBox(height: TSizes.xs),

          // Order amount
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(Iconsax.money, size: 18, color: TColors.white),
                const SizedBox(width: 8),
                Text(
                  'Amount: Rs. ${order.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Payment status
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(Iconsax.wallet, size: 18, color: TColors.white),
                const SizedBox(width: 8),
                Text(
                  'Paid: Rs. ${order.paidAmount?.toStringAsFixed(2) ?? '0.00'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                if ((order.paidAmount ?? 0) < order.totalPrice)
                  Chip(
                    backgroundColor: TColors.warning.withOpacity(0.2),
                    label: Text(
                      'Due: Rs. ${(order.totalPrice - (order.paidAmount ?? 0)).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: TColors.warning,
                        fontSize: 12,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ),

          // Customer info if available
          if (order.customerId != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
              child: Row(
                children: [
                  const Icon(Iconsax.user, size: 18, color: TColors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Customer ID: ${order.customerId}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

          // Sale type
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(Iconsax.shopping_cart,
                    size: 18, color: TColors.white),
                const SizedBox(width: 8),
                Text(
                  'Sale Type: ${order.saletype?.toUpperCase() ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.sm),

          // Status chip
          Chip(
            backgroundColor: statusColor.withOpacity(0.2),
            avatar: Icon(statusIcon, size: 16, color: statusColor),
            label: Text(
              order.status.toUpperCase(),
              style: TextStyle(color: statusColor),
            ),
          ),

          const SizedBox(height: TSizes.sm),

          // View details button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onView,
              icon: const Icon(Iconsax.eye, color: TColors.white),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
