import 'package:ecommerce_dashboard/Models/orders/order_item_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/installments/installments_controller.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:ecommerce_dashboard/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/loaders/tloaders.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    // Check if this is an installment order and is cancelled
    SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
      (e) => e.name == orderModel.saletype,
      orElse: () => SaleType.cash,
    );

    // Initialize the OrderController status based on order status
    OrderStatus orderStatus = OrderStatus.values.firstWhere(
      (status) => status.toString().split('.').last == orderModel.status,
      orElse: () => OrderStatus.pending,
    );
    orderController.selectedStatus.value = orderStatus;

    // If this is a cancelled installment order, initialize refund data
    if (orderStatus == OrderStatus.cancelled &&
        saleTypeFromOrder == SaleType.installment) {
      // Initialize refund data on page load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<InstallmentController>()) {
          final InstallmentController installmentController =
              Get.find<InstallmentController>();
          installmentController.initializeRefundData(orderModel);
        }
      });
    }

    // Check if we're on a small screen (mobile or small tablet)
    final bool isSmallScreen = TDeviceUtils.isMobileScreen(context) ||
        MediaQuery.of(context).size.width < 600;

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // For small screens, use a column layout instead of row to prevent overflow
          isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text('Order Id #'),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              orderModel.orderId.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Items
                    Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text('Items'),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              orderModel.orderItems?.length.toString() ?? '0',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status
                    Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text('Status'),
                          ),
                          Expanded(
                            flex: 3,
                            child:
                                _buildStatusDropdown(context, orderController),
                          ),
                        ],
                      ),
                    ),

                    // Commission
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text('Salesman Commission'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${orderModel.salesmanComission}%',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date'),
                          Text(
                            DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(orderModel.orderDate)),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Items'),
                          Text(
                            orderModel.orderItems?.length.toString() ?? '0',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status'),
                          _buildStatusDropdown(context, orderController),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                      child: Column(
                        children: [
                          const Text('Salesman Commission'),
                          Text(
                            '${orderModel.salesmanComission}%',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // Extracted dropdown into a separate method for reuse
  Widget _buildStatusDropdown(
      BuildContext context, OrderController orderController) {
    // Constrain dropdown width based on screen size
    final double dropdownWidth = TDeviceUtils.isMobileScreen(context)
        ? 120 // For mobile
        : MediaQuery.of(context).size.width < 1200
            ? 150 // For tablets
            : 200; // For desktops

    return SizedBox(
      width: dropdownWidth,
      child: TRoundedContainer(
        radius: TSizes.cardRadiusSm,
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: TSizes.sm,
        ),
        backgroundColor: THelperFunctions.getOrderStatusColor(
                orderController.selectedStatus.value)
            .withValues(alpha: 0.1),
        child: Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton<OrderStatus>(
              isDense: true,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(vertical: 0),
              value: orderController.selectedStatus.value,
              items: OrderStatus.values.map((OrderStatus status) {
                return DropdownMenuItem<OrderStatus>(
                  value: status,
                  child: Text(
                    status.name.capitalize.toString(),
                    style: TextStyle(
                      fontSize: TDeviceUtils.isMobileScreen(context) ? 12 : 14,
                      color: THelperFunctions.getOrderStatusColor(status),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (OrderStatus? newValue) async {
                if (newValue != null) {
                  try {
                    // Get the new status string (e.g., "pending", "cancelled")
                    final newStatusString = newValue.toString().split('.').last;

                    // Update the status in the database and get confirmation back
                    final updatedStatus = await orderController.updateStatus(
                      orderModel.orderId,
                      newStatusString,
                    );

                    // If we got a valid status back, update the UI
                    if (updatedStatus.isNotEmpty) {
                      // Convert string to enum and update UI dropdown
                      final updatedOrderStatus = OrderStatus.values.firstWhere(
                        (status) =>
                            status.toString().split('.').last == updatedStatus,
                        orElse: () => orderController.selectedStatus.value,
                      );

                      // Update the controller status
                      orderController.selectedStatus.value = updatedOrderStatus;
                    }
                  } catch (e) {
                    TLoaders.errorSnackBar(
                        title: 'Status Update Failed',
                        message:
                            'Could not update order status: ${e.toString()}');

                    // Revert dropdown to previous value if there was an error
                    final revertStatus = OrderStatus.values.firstWhere(
                      (status) =>
                          status.toString().split('.').last ==
                          orderModel.status,
                      orElse: () => orderController.selectedStatus.value,
                    );
                    orderController.selectedStatus.value = revertStatus;
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
