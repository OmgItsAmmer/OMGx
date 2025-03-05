import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../table/salesman_order_table.dart';
import '../widgets/SalesmanInfo.dart';
import '../widgets/salesman_shipping_info.dart';




class SalesmanDetailDesktop extends StatelessWidget {
  const SalesmanDetailDesktop({super.key, required this.salesmanModel});
  final SalesmanModel salesmanModel;
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
                  "Salesman Detail",
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
                          //UserInfo(customerModel: salesmanModel,),
                         SalesmanInfo(salesmanModel: salesmanModel,),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),

                          //shipping info
                         SalesmanShippingInfo(salesmanModel: salesmanModel,),
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
                               const SalesmanOrderTable(),
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
