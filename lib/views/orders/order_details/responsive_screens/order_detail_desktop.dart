import 'package:admin_dashboard_v3/Models/orders/order_model.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/customer_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/oorder_transaction.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_items.dart';
import 'package:flutter/material.dart';

class OrderDetailDesktopScreen extends StatelessWidget {
  const OrderDetailDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderModel order = OrderModel.empty();
    return  Flexible(
      child: SizedBox(
        //height: 1000,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Bread Crumbs
                //Sizedbox
                //Body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            //Order Info
                              const OrderInfo(),
                            const SizedBox(
                              height: TSizes.spaceBtwSections,
                            ),
      
                            //Items
                            OrderItems(order: order),
                            const SizedBox(
                              height: TSizes.spaceBtwSections,
                            ),
      
                            //Transactions
                            const OrderTransaction(),
                          ],
                        )),
                    const SizedBox(
                      width: TSizes.spaceBtwSections,
                    ),
                    // Right Side Order Orders
                    const Expanded(
                        child: Column(
                      children: [
                        //Customer Info
                        CustomerInfo(),
                        SizedBox(
                          height: TSizes.spaceBtwSections,
                        )
                      ],
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
