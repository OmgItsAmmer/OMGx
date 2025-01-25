import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../table/product_table.dart';

class AllProductDesktopScreen extends StatelessWidget {
  const AllProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Expanded(
      child: SizedBox(
        // height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Products',style: Theme.of(context).textTheme.headlineMedium ,),
                const SizedBox(height: TSizes.spaceBtwSections,),

                //Bread Crumbs

                //Table Body
                 TRoundedContainer(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 200,
                      child: ElevatedButton(onPressed: (){}, child:  Text('Add Products',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white) ,),),),
                      SizedBox(width: 500 ,
                        child: TextFormField(
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
                        ) ,
                      )
                    ],
                  ),
                    const SizedBox(height: TSizes.spaceBtwSections,),

                    //Table body
                    const ProductTable()


                  ],
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
