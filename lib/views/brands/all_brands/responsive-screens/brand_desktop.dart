import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/table/brand_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/product/product_controller.dart';
import '../../../../routes/routes.dart';

class AllBrandsDesktopScreen extends StatelessWidget {
  const AllBrandsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();

    return   Expanded(
      child: SizedBox(
        // height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Brands',style: Theme.of(context).textTheme.headlineMedium ,),
                const SizedBox(height: TSizes.spaceBtwSections,),

                //Bread Crumbs

                //Table Body
                TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 200,
                            child: ElevatedButton(onPressed: (){
                              brandController.cleanBrandDetail();
                              Get.toNamed(TRoutes.brandDetails);
                            }, child:  Text('Add New Brand',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white) ,),),),
                          SizedBox(width: 500 ,
                            child: TextFormField(
                              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
                            ) ,
                          )
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),

                      //Table body
                      const BrandTable()


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
