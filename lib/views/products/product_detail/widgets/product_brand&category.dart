import 'package:ecommerce_dashboard/Models/brand/brand_model.dart';
import 'package:ecommerce_dashboard/Models/category/category_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';
import '../../../../utils/constants/enums.dart';

class ProductBrandcCategory extends StatefulWidget {
  const ProductBrandcCategory({super.key});

  @override
  State<ProductBrandcCategory> createState() => _ProductBrandcCategoryState();
}

class _ProductBrandcCategoryState extends State<ProductBrandcCategory> {
  // Focus nodes for category and brand fields
  final FocusNode categoryFocusNode = FocusNode();
  final FocusNode brandFocusNode = FocusNode();

  // Access controllers
  final BrandController brandController = Get.find<BrandController>();
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    // Refresh data when widget initializes
    _refreshData();

    // Set up focus node listeners to refresh data when dropdown is focused
    categoryFocusNode.addListener(_onCategoryFocusChange);
    brandFocusNode.addListener(_onBrandFocusChange);
  }

  void _refreshData() {
    // Refresh both lists to ensure we have the latest data
    brandController.fetchBrands();
    categoryController.fetchCategories();
  }

  void _onCategoryFocusChange() {
    if (categoryFocusNode.hasFocus) {
      // Refresh categories when dropdown is focused
      categoryController.fetchCategories();
    }
  }

  void _onBrandFocusChange() {
    if (brandFocusNode.hasFocus) {
      // Refresh brands when dropdown is focused
      brandController.fetchBrands();
    }
  }

  @override
  void dispose() {
    // Clean up focus node listeners
    categoryFocusNode.removeListener(_onCategoryFocusChange);
    brandFocusNode.removeListener(_onBrandFocusChange);

    // Dispose focus nodes
    categoryFocusNode.dispose();
    brandFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () async {
                      // Navigate to category creation screen
                      await Get.toNamed(TRoutes.categoryDetails,
                          arguments: CategoryModel.empty());
                      // Refresh categories after returning
                      categoryController.fetchCategories();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Focus(
                focusNode: categoryFocusNode,
                child: Obx(
                  () => EnhancedAutocomplete<String>(
                    showOptionsOnFocus: true,
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
                      productController.selectedCategoryNameController.text =
                          val;
                      productController.selectedCategoryId =
                          await categoryController.fetchCategoryId(val);
                    },
                    onManualTextEntry: (String text) {
                      if (text.isEmpty) {
                        resetCategorySelection();
                      }
                    },
                  ),
                ),
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
                    onPressed: () async {
                      // Navigate to brand creation screen
                      await Get.toNamed(TRoutes.brandDetails,
                          arguments: BrandModel.empty());
                      // Refresh brands after returning
                      brandController.fetchBrands();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Focus(
                focusNode: brandFocusNode,
                child: Obx(
                  () => EnhancedAutocomplete<String>(
                    showOptionsOnFocus: true,
                    labelText: 'Select Brand',
                    hintText: 'Choose a brand',
                    options: brandController.allBrands
                        .map((e) => e.brandName)
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
                  ),
                ),
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
