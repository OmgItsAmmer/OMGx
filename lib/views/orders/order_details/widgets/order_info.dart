import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(
                      DateFormat('dd-MM-yyyy').format(DateTime.parse(orderModel.orderDate)),
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
                    TRoundedContainer(
                      radius: TSizes.cardRadiusSm,
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: TSizes.sm,
                      ),
                      backgroundColor: THelperFunctions
                          .getOrderStatusColor(orderController.selectedStatus.value)
                          .withValues(alpha: 0.1), // FIXED: Used selectedStatus.value
                      child: Obx(
                            () => DropdownButton<OrderStatus>(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          value: orderController.selectedStatus.value,
                          items: OrderStatus.values.map((OrderStatus status) {
                            return DropdownMenuItem<OrderStatus>(
                              value: status,
                              child: Text(
                                status.name.capitalize.toString(),
                                style: TextStyle(
                                  color: THelperFunctions.getOrderStatusColor(status), // FIXED: Use correct status color
                                ),
                              ),
                            );
                          }).toList(),
                                onChanged: (OrderStatus? newValue) async {
                                  if (newValue != null) {
                                    final updatedStatus = await orderController.updateStatus(
                                      orderModel.orderId,
                                      newValue.toString().split('.').last,
                                    );

                                    final orderStatusString = 'OrderStatus.$updatedStatus';
                                    final OrderStatus? status = orderController.stringToOrderStatus(orderStatusString);

                                    if (status != null) {
                                      orderController.selectedStatus.value = status;

                                      if (orderModel.status == 'cancelled' && status != OrderStatus.cancelled) {
                                        orderController.addBackQuantity(orderModel.orderItems);
                                      } else if (status == OrderStatus.cancelled) {
                                        orderController.restoreQuantity(orderModel.orderItems);
                                      }
                                    } else {
                                      TLoader.errorSnackBar(title: 'Error', message: 'Invalid status: $updatedStatus');
                                    }
                                  }
                                },
                        ),
                      ),
                    ),
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
}
