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
    return const SizedBox(
      height: 760, //flexible can be used
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Bread crumbs

              //Table Body
              TRoundedContainer(
                child: Column(
                  children: [
                    OrderTable()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
