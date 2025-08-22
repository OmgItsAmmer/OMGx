import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../table/customer_order_table.dart';
import '../widgets/customer_shipping_info.dart';
import '../widgets/user_info.dart';

class CustomerDetailTablet extends StatelessWidget {
  const CustomerDetailTablet({super.key, required this.customerModel});
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
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Detail",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              // Row layout for tablet - customer info side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: UserInfo(customerModel: customerModel),
                  ),

                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Orders in full width
                  Expanded(
                    child: TRoundedContainer(
                        padding: const EdgeInsets.only(
                            top: TSizes.sm,
                            bottom: TSizes.sm,
                            left: TSizes.sm,
                            right: TSizes.sm),
                          
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Orders',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            const CustomerOrderTable(),
                          ],
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
