import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../../utils/constants/enums.dart';

class ProductBrandcCategory extends StatelessWidget {
  const ProductBrandcCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();
    final ProductController productController = Get.find<ProductController>();
    final CategoryController categoryController = Get.find<CategoryController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                   TCircularIcon(icon: Icons.add,backgroundColor: TColors.primary,color: TColors.white,

                    onPressed: () {
                    Get.toNamed(TRoutes.categoryDetails,arguments: CategoryModel.empty());
                  },),

                ],
              ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
              AutoCompleteTextField(
                  titleText: '',
                  optionList: categoryController.categoriesNames,
                  textController:
                  productController.selectedCategoryNameController,
                  parameterFunc: (val) async {
                    if (val.isEmpty) {
                      resetCategorySelection();
                      return;
                    }

                    productController.selectedCategoryNameController.text = val;
                    productController.selectedCategoryId =
                    await categoryController.fetchCategoryId(val);
                  }
              ),
            ],
          ),
        ),

        const SizedBox(
          height: TSizes.spaceBtwSections,
        ),

        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Brand',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                   TCircularIcon(icon: Icons.add,backgroundColor: TColors.primary,color: TColors.white,

                    onPressed: () {
                      Get.toNamed(TRoutes.brandDetails,arguments: BrandModel.empty());

                    },
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              AutoCompleteTextField(
                  titleText: '',
                  optionList: brandController.brandNames,
                  textController:
                      productController.selectedBrandNameController,
                parameterFunc: (val) async {
                  if (val.isEmpty) {
                    productController.selectedBrandId = -1;
                    productController.selectedBrandNameController.clear();
                    return;
                  }

                  productController.selectedBrandId =
                  await brandController.fetchBrandId(val);
                },
              ),
            ],
          ),
        ),

        // const SizedBox(height: TSizes.spaceBtwSections,),
        // TRoundedContainer(
        //   padding: EdgeInsets.all(TSizes.defaultSpace),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       //Drop Down
        //       Expanded(
        //         flex:2,
        //         child: DropdownButton<StockLocation>(
        //           value: StockLocation.Shop,
        //           items: StockLocation.values.map((StockLocation location) {
        //             return DropdownMenuItem<StockLocation>(
        //               value: location,
        //               child: Text(
        //                 location.name.capitalize.toString(),
        //                 style: const TextStyle(),
        //               ),
        //             );
        //           }).toList(),
        //           onChanged: (value) {
        //             // Add your onChanged logic here
        //           },
        //         ),
        //       ),
        //
        //       const Expanded(child: Icon(Iconsax.add))
        //
        //       // Add Icon
        //     ],
        //
        //   ),
        // ),
      ],
    );
  }

}
void resetCategorySelection() {
  final ProductController productController = Get.find<ProductController>();

  productController.selectedCategoryId = -1;
  productController.selectedCategoryNameController.clear();
}


