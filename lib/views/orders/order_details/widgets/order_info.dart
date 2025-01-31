import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(
                      orderModel.orderDate,
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
                          .getOrderStatusColor(OrderStatus.pending)
                          .withOpacity(0.1),
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
                                  color: THelperFunctions.getOrderStatusColor(
                                    OrderStatus.pending,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (OrderStatus? newValue) {
                            orderController.selectedStatus.value = newValue ?? OrderStatus.pending;

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
                    const Text('Total'),
                    Text(
                      orderModel.totalPrice.toString(),
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
