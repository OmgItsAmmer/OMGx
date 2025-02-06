import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../table/customer_table.dart';

class CustomerDesktop extends StatelessWidget {
  const CustomerDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: SizedBox(
        //height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text('Customers',style: Theme.of(context).textTheme.headlineMedium ,),
                    const SizedBox(height: TSizes.spaceBtwSections,),
                //bread Crumbs
      
                //Table Header
      
                //Table
                 TRoundedContainer(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 200,
                          child: ElevatedButton(onPressed: (){ Get.toNamed( TRoutes.customerDetails);}, child: Text('Add New Customer',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),)),),
                          SizedBox(width: 500,
                          child: TextFormField(
                            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
                          ) ,
                          )
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),
                      const CustomerTable(),
                    ],
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
