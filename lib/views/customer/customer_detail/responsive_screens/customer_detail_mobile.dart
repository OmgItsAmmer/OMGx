import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/enums.dart';
import '../table/customer_order_table.dart';
import '../widgets/customer_shipping_info.dart';
import '../widgets/user_info.dart';

class CustomerDetailMobile extends StatelessWidget {
  const CustomerDetailMobile({super.key, required this.customerModel});
  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    // Initialize the order controller and fetch orders for this customer
    final OrderController orderController = Get.find<OrderController>();

    // Fetch orders for this customer when the view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (customerModel.customerId != null) {
        orderController.fetchEntityOrders(
            customerModel.customerId!, EntityType.customer);
        orderController.setRecentOrderDay();
        orderController.setAverageTotalAmount();
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Detail",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              // Stacked vertically for mobile
              UserInfo(customerModel: customerModel),

              const SizedBox(height: TSizes.spaceBtwItems),

              CustomerShippingInfo(customerModel: customerModel),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Orders
              TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const CustomerOrderTable(),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
