import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
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
                      'Formatted Order date',
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
                      'Order length',
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
                      child: DropdownButton<OrderStatus>(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        value: OrderStatus.pending,
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
                        onChanged: (OrderStatus? newValue) {},
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
                      'Order total amount',
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
