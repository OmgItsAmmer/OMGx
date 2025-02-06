import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/table/order_table.dart';
import 'package:flutter/material.dart';

import '../table/customer_order_table.dart';
import '../widgets/customer_shipping_info.dart';
import '../widgets/user_info.dart';

class CustomerDetailDesktop extends StatelessWidget {
  const CustomerDetailDesktop({super.key, required this.customerModel});
final CustomerModel customerModel;
  @override
  Widget build(BuildContext context) {
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
                  customerModel.fullName,
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
                          UserInfo(customerModel: customerModel,),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),

                          //shipping info
                           CustomerShippingInfo(customerModel: customerModel ,),
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
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections,),
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
