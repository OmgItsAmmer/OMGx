import 'package:ecommerce_dashboard/Models/products/product_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../routes/routes.dart';

class AllProductMobileScreen extends GetView<ProductController> {
  const AllProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the table search controller if not already initialized
    if (!Get.isRegistered<TableSearchController>(tag: 'products')) {
      Get.put(TableSearchController(), tag: 'products');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'products');
    final mediaController = Get.find<MediaController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Controls
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
                        controller.cleanProductDetail();
                        Get.toNamed(TRoutes.productsDetail);
                      },
                      child: Text(
                        'Add Products',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Search Field and Refresh Icon
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.search_normal),
                            hintText: 'Search Anything',
                          ),
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
                          controller.refreshProducts();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Products Grid
            Obx(() {
              // Get the search term from the controller
              String searchTerm =
                  tableSearchController.searchTerm.value.toLowerCase();

              // Create a filtered product list based on search term
              var filteredProducts = [
                ...controller.allProducts
              ]; // Create a copy
              if (searchTerm.isNotEmpty) {
                filteredProducts = controller.allProducts
                    .where((product) =>
                        (product.name?.toString().toLowerCase() ?? '')
                            .contains(searchTerm) ||
                        (product.salePrice?.toString().toLowerCase() ?? '')
                            .contains(searchTerm) ||
                        (product.stockQuantity?.toString().toLowerCase() ?? '')
                            .contains(searchTerm))
                    .toList();
              }

              if (filteredProducts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      'No products found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    product: product,
                    mediaController: mediaController,
                    onEdit: () {
                      // Ensure we have a valid product ID as an int
                      final productIdStr =
                          product.productId?.toString() ?? '-1';
                      controller.productId.value =
                          int.tryParse(productIdStr) ?? -1;

                      // Set the selectedProduct string value
                      controller.selectedProduct.value = productIdStr;
                      controller.onProductTap(product);
                      // Navigate to product details
                      Get.toNamed(TRoutes.productsDetail);
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

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final MediaController mediaController;
  final VoidCallback onEdit;

  const ProductCard({
    Key? key,
    required this.product,
    required this.mediaController,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle numeric values for display
    final double? basePriceNum = double.tryParse(product.basePrice ?? '');
    final double? salePriceNum = double.tryParse(product.salePrice ?? '');

    // Safely convert stock quantity to int
    final int stockQuantity = product.stockQuantity is int
        ? product.stockQuantity as int
        : int.tryParse(product.stockQuantity?.toString() ?? '0') ?? 0;

    // Parse productId to int for the image fetch
    final int productIdInt = product.productId is int
        ? product.productId as int
        : int.tryParse(product.productId?.toString() ?? '-1') ?? -1;

    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image and name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              FutureBuilder<String?>(
                future: mediaController.fetchMainImage(
                  productIdInt,
                  MediaCategory.products.toString().split('.').last,
                ),
                builder: (context, snapshot) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TSizes.sm),
                    ),
                    child: snapshot.hasData && snapshot.data != null
                        ? TRoundedImage(
                            width: 60,
                            height: 60,
                            isNetworkImage: true,
                            imageurl: snapshot.data!,
                          )
                        : const Icon(Iconsax.image, size: 30),
                  );
                },
              ),
              const SizedBox(width: TSizes.sm),

              // Product name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unknown Product',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Brand: ${product.brandID ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.sm),
          const Divider(),

          // Product details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Buy Price:'),
                Text(
                  basePriceNum != null
                      ? 'Rs. ${basePriceNum.toStringAsFixed(2)}'
                      : 'Rs. N/A',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sale Price:'),
                Text(
                  salePriceNum != null
                      ? 'Rs. ${salePriceNum.toStringAsFixed(2)}'
                      : 'Rs. N/A',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Stock:'),
                Text(
                  '$stockQuantity units',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            stockQuantity > 0 ? TColors.success : TColors.error,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.sm),

          // Edit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Iconsax.edit,
                color: TColors.white,
              ),
              label: const Text('Edit Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
