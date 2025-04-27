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
import '../../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';
import '../../../../utils/constants/enums.dart';

class ProductBrandcCategory extends StatelessWidget {
  const ProductBrandcCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();
    final ProductController productController = Get.find<ProductController>();
    final CategoryController categoryController =
        Get.find<CategoryController>();

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
                  TCircularIcon(
                    icon: Icons.add,
                    backgroundColor: TColors.primary,
                    color: TColors.white,
                    onPressed: () {
                      Get.toNamed(TRoutes.categoryDetails,
                          arguments: CategoryModel.empty());
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              EnhancedAutocomplete<String>(
                labelText: 'Select Category',
                hintText: 'Choose a category',
                options: categoryController.allCategories
                    .map((e) => e.categoryName)
                    .whereType<String>()
                    .toList(),
                externalController:
                    productController.selectedCategoryNameController,
                displayStringForOption: (String option) => option,
                onSelected: (val) async {
                  productController.selectedCategoryNameController.text = val;
                  productController.selectedCategoryId =
                      await categoryController.fetchCategoryId(val);
                },
                onManualTextEntry: (String text) {
                  if (text.isEmpty) {
                    resetCategorySelection();
                  }
                },
                showOptionsOnFocus: true,
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
                  TCircularIcon(
                    icon: Icons.add,
                    backgroundColor: TColors.primary,
                    color: TColors.white,
                    onPressed: () {
                      Get.toNamed(TRoutes.brandDetails,
                          arguments: BrandModel.empty());
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              EnhancedAutocomplete<String>(
                labelText: 'Select Brand',
                hintText: 'Choose a brand',
                options: brandController.allBrands
                    .map((e) => e.bname)
                    .whereType<String>()
                    .toList(),
                externalController:
                    productController.selectedBrandNameController,
                displayStringForOption: (String option) => option,
                onSelected: (val) async {
                  productController.selectedBrandId =
                      await brandController.fetchBrandId(val);
                },
                onManualTextEntry: (String text) {
                  if (text.isEmpty) {
                    productController.selectedBrandId = -1;
                    productController.selectedBrandNameController.clear();
                  }
                },
                showOptionsOnFocus: true,
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
