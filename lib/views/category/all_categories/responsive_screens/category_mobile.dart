import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/category/category_model.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../routes/routes.dart';

class CategoryMobile extends StatelessWidget {
  const CategoryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();
    final MediaController mediaController = Get.find<MediaController>();

    // Initialize the table search controller if not already initialized
    if (!Get.isRegistered<TableSearchController>(tag: 'categories')) {
      Get.put(TableSearchController(), tag: 'categories');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'categories');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Controls section
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        categoryController.cleanCategoryDetail();
                        Get.toNamed(
                          TRoutes.categoryDetails,
                          arguments: CategoryModel.empty(),
                        );
                      },
                      child: Text(
                        'Add New Category',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Search Field with Refresh Icon
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Iconsax.search_normal,
                              ),
                              hintText: 'Search by category name'),
                          onChanged: (value) {
                            tableSearchController.searchTerm.value = value;
                          },
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      TCircularIcon(
                        icon: Iconsax.refresh,
                        backgroundColor: TColors.primary,
                        color: TColors.white,
                        onPressed: () {
                          categoryController.refreshCategories();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Category Cards
            Obx(() {
              // Get the search term from the controller
              String searchTerm =
                  tableSearchController.searchTerm.value.toLowerCase();

              // Create a filtered categories list based on search term
              var filteredCategories = [
                ...categoryController.allCategories
              ]; // Create a copy
              if (searchTerm.isNotEmpty) {
                filteredCategories =
                    categoryController.allCategories.where((category) {
                  return category.categoryName
                      .toLowerCase()
                      .contains(searchTerm);
                }).toList();
              }

              if (filteredCategories.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      'No categories found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return CategoryCard(
                    category: category,
                    mediaController: mediaController,
                    onEdit: () {
                      categoryController.setCategoryDetail(category);
                      categoryController.selectedCategory.value =
                          category.categoryId.toString();
                      Get.toNamed(TRoutes.categoryDetails, arguments: category);
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete ${category.categoryName}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && category.categoryId != null) {
                        await categoryController
                            .deleteCategory(category.categoryId!);
                      }
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final MediaController mediaController;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.mediaController,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Category icon
              const CircleAvatar(
                radius: 24,
                backgroundColor: TColors.accent,
                child: Icon(
                  Iconsax.category,
                  color: TColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Category name and product count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.categoryName,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (category.isFeatured == true)
                          const Icon(
                            Icons.star,
                            color: TColors.warning,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      '${category.productCount ?? 0} Products',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.md),
          const Divider(),
          const SizedBox(height: TSizes.xs),

          // Status indicator
          Chip(
            backgroundColor: category.isFeatured == true
                ? TColors.warning.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            label: Text(
              category.isFeatured == true ? 'Featured' : 'Not Featured',
              style: TextStyle(
                color:
                    category.isFeatured == true ? TColors.warning : Colors.grey,
              ),
            ),
            avatar: Icon(
              category.isFeatured == true ? Iconsax.star : Iconsax.star1,
              size: 16,
              color:
                  category.isFeatured == true ? TColors.warning : Colors.grey,
            ),
          ),

          const SizedBox(height: TSizes.md),

          // Action buttons
          Row(
            children: [
              // Edit button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(
                    Iconsax.edit,
                    color: TColors.white,
                  ),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.white,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Delete button
              Expanded(
                child: TCircularIcon(
                  onPressed: onDelete,
                  icon: Iconsax.trash,
                  color: TColors.white,
                  backgroundColor: TColors.error,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
