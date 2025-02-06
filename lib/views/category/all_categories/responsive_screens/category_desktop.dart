import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/table/brand_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/category/category_model.dart';
import '../../../../Models/category/category_model.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../routes/routes.dart';
import '../table/category_table.dart';

class AllCategoryDesktopScreen extends StatelessWidget {
  const AllCategoryDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find<CategoryController>();


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
                              categoryController.cleanCategoryDetail();
                              Get.toNamed(TRoutes.categoryDetails,arguments: CategoryModel.empty(),);
                            }, child:  Text('Add New Category',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white) ,),),),
                          SizedBox(width: 500 ,
                            child: TextFormField(
                              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
                            ) ,
                          )
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),

                      //Table body
                      const CategoryTable()


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
