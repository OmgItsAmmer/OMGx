import 'package:admin_dashboard_v3/common/widgets/texts/section_heading.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../table/order_table.dart';

class OrdersDesktopScreen extends StatelessWidget {
  const OrdersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        // height: 760, //flexible can be used
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Bread crumbs
                Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                //Table Body
                const TRoundedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [OrderTable()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
