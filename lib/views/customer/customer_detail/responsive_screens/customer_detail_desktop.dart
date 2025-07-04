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

class CustomerDetailDesktop extends StatelessWidget {
  const CustomerDetailDesktop({super.key, required this.customerModel});
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

    return Expanded(
      child: SizedBox(
        // height: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //user Info
                          UserInfo(
                            customerModel: customerModel,
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),

                          //shipping info
                          CustomerShippingInfo(
                            customerModel: customerModel,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: TSizes.spaceBtwSections/2,
                    // ),
                    Expanded(
                        flex: 2,
                        child: TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.defaultSpace),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orders',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: TSizes.spaceBtwSections,
                                ),
                                const CustomerOrderTable(),
                              ],
                            )))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
