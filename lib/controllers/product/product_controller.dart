import 'package:ecommerce_dashboard/Models/orders/order_item_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/Models/image/image_entity_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_images_controller.dart';
import 'package:ecommerce_dashboard/repositories/products/product_repository.dart';
import 'package:ecommerce_dashboard/repositories/products/product_variants_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../routes/routes.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';
import '../../main.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());
  final productVariantsRepository = Get.put(ProductVariantsRepository());
  final MediaController mediaController = Get.find<MediaController>();

  // Focus nodes for tab order
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode basePriceFocusNode = FocusNode();
  final FocusNode salePriceFocusNode = FocusNode();
  final FocusNode stockFocusNode = FocusNode();
  final FocusNode alertStockFocusNode = FocusNode();

  // Lists to store models
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductVariantModel> currentProductVariants =
      <ProductVariantModel>[].obs;
  RxList<ProductVariantModel> unsavedProductVariants =
      <ProductVariantModel>[].obs;

  // Product Images - Reactive list for current product images
  RxList<ImageEntityModel> productImages = <ImageEntityModel>[].obs;
  RxBool isLoadingImages = false.obs;

  // Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  // Variables
  Rx<String> selectedProduct = ''.obs;
  RxBool isUpdating = false.obs;
  RxBool isAddingVariants = false.obs;

  // Product Detail Controllers
  RxInt productId = (-1).obs;
  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final basePrice = TextEditingController();
  final salePrice = TextEditingController();
  final stock = TextEditingController();
  final alertStock = TextEditingController();
  final brandName = TextEditingController();
  final TextEditingController selectedBrandNameController =
      TextEditingController();
  final TextEditingController selectedCategoryNameController =
      TextEditingController();

  int selectedBrandId = -1;
  int selectedCategoryId = -1;
  // Track original brand and category for updates
  int originalBrandId = -1;
  int originalCategoryId = -1;

  GlobalKey<FormState> productDetail = GlobalKey<FormState>();
  var variantForm = GlobalKey<FormState>();

  RxInt entityId = (-1).obs; // Form key for form validation

  // Track if we're in the middle of a variant fetch to prevent loops
  bool _isInVariantFetch = false;

  Rx<ProductTag?> productTag = null.obs;

  RxBool isPopular = false.obs;

  RxBool isVisible = false.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose all text controllers and focus nodes to prevent memory leaks
    productName.dispose();
    productDescription.dispose();
    basePrice.dispose();
    stock.dispose();
    alertStock.dispose();
    brandName.dispose();
    selectedBrandNameController.dispose();
    selectedCategoryNameController.dispose();
    salePrice.dispose();

    // Dispose focus nodes
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    basePriceFocusNode.dispose();
    salePriceFocusNode.dispose();
    stockFocusNode.dispose();
    alertStockFocusNode.dispose();

    // Clear any cached data to prevent stale state
    currentProductVariants.clear();
    unsavedProductVariants.clear();

    super.onClose();
  }

  // Reset UI state when navigating away
  void resetState() {
    cleanProductDetail();
    productId.value = -1;
    isUpdating.value = false;
    isAddingVariants.value = false;
  }

  // Clean all form data for a fresh start
  void cleanProductDetail() {
    try {
      productId.value = -1;
      productName.clear();
      productDescription.clear();
      basePrice.clear();
      salePrice.clear();
      stock.clear();
      alertStock.clear();
      brandName.clear();
      selectedBrandId = -1;
      selectedCategoryId = -1;
      originalBrandId = -1;
      originalCategoryId = -1;
      selectedCategoryNameController.clear();
      selectedBrandNameController.clear();

      // Clear variants
      if (currentProductVariants.isNotEmpty) {
        currentProductVariants.clear();
      }
      if (unsavedProductVariants.isNotEmpty) {
        unsavedProductVariants.clear();
      }
      productTag.value = null;
      isPopular.value = false;
      isVisible.value = false;

      // Clear product images
      clearProductImages();

      update(); // Force UI update
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Function to insert new product
  Future<int> insertProduct() async {
    try {
      isUpdating.value = true;
      debugPrint('Starting product insert...');

      // First validate the basic product form
      if (!productDetail.currentState!.validate()) {
        debugPrint('Product form validation failed');
        TLoaders.errorSnackBar(
          title: "Invalid Form",
          message: 'Please fill all required fields correctly.',
        );
        return -1;
      }

      // Then validate the brand and category selection
      if (selectedBrandId == -1 || selectedCategoryId == -1) {
        debugPrint('Brand or category not selected');
        TLoaders.errorSnackBar(
          title: "Missing Selection",
          message: 'Please select both brand and category.',
        );
        return -1;
      }

      // Ensure at least one variant exists
      if (currentProductVariants.isEmpty && unsavedProductVariants.isEmpty) {
        TLoaders.errorSnackBar(
          title: "No Variants",
          message: 'Please add at least one variant to the product.',
        );
        return -1;
      }

      // Create the product model with calculated stock from variants
      final totalStock = _calculateTotalStock();

      final productModel = ProductModel(
        productId: null,
        name: productName.text.trim(),
        description: productDescription.text.trim(),
        basePrice: basePrice.text.trim(),
        salePrice: salePrice.text.trim(),
        stockQuantity: totalStock,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
        productTag: productTag.value,
        isPopular: isPopular.value,
        isVisible: isVisible.value,
      );

      // Insert the product into the database
      final json = productModel.toJson(isUpdate: true);
      debugPrint('Inserting product with data: $json');

      await Future.delayed(Duration.zero);
      final newProductId = await productRepository.insertProductInTable(json);
      debugPrint('Product inserted with ID: $newProductId');

      // Check for valid product ID
      if (newProductId <= 0) {
        debugPrint('Invalid product ID returned: $newProductId');
        throw Exception(
            "Failed to insert product. Invalid product ID returned.");
      }

      // Assign the product ID to the model and controller
      productModel.productId = newProductId;
      productId.value = newProductId;

      // Save variants to database
      await saveUnsavedVariants();

      // Increment product count in brand and category
      final BrandController brandController = Get.find<BrandController>();
      final CategoryController categoryController =
          Get.find<CategoryController>();

      brandController.incrementProductCount(selectedBrandId);
      categoryController.incrementProductCount(selectedCategoryId);

      // Store original values for potential future updates
      originalBrandId = selectedBrandId;
      originalCategoryId = selectedCategoryId;

      // Save the image
      try {
        await mediaController.imageAssigner(newProductId,
            MediaCategory.products.toString().split('.').last, true);
        debugPrint('Product image uploaded successfully');
      } catch (e) {
        debugPrint('Error uploading image: $e');
      }

      // Add to local list
      allProducts.add(productModel);
      debugPrint('Product added to local list');

      // Check for low stock
      await checkLowStock([newProductId]);

      // Show success message
      TLoaders.successSnackBar(
        title: "Success",
        message: 'Product added successfully!',
      );
      Navigator.of(Get.context!).pop();
      return newProductId;
    } catch (e) {
      debugPrint('Error inserting product: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
      return -1;
    } finally {
      isUpdating.value = false;
    }
  }

  // Function to update existing product
  Future<bool> updateProduct() async {
    try {
      isUpdating.value = true;
      debugPrint('Starting product update for ID: ${productId.value}...');

      // Validate the form
      if (!productDetail.currentState!.validate() ||
          selectedBrandId == -1 ||
          selectedCategoryId == -1) {
        debugPrint('Product form validation failed or missing brand/category');
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return false;
      }

      // Ensure at least one variant exists
      if (currentProductVariants.isEmpty && unsavedProductVariants.isEmpty) {
        TLoaders.errorSnackBar(
          title: "No Variants",
          message: 'Please add at least one variant to the product.',
        );
        return false;
      }

      // Calculate total stock from variants
      final totalStock = _calculateTotalStock();

      final productModel = ProductModel(
        productId: productId.value,
        name: productName.text.trim(),
        description: productDescription.text.trim(),
        basePrice: basePrice.text.trim(),
        salePrice: salePrice.text.trim(),
        stockQuantity: totalStock,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
        productTag: productTag.value,
        isPopular: isPopular.value,
        isVisible: isVisible.value,
      );

      final json = productModel.toJson(isUpdate: true);
      debugPrint('Updating product with data: $json');

      await productRepository.updateProduct(json);
      debugPrint('Product update database call completed');

      // Save any unsaved variants
      await saveUnsavedVariants();

      // Handle brand and category count updates if they changed
      final BrandController brandController = Get.find<BrandController>();
      final CategoryController categoryController =
          Get.find<CategoryController>();

      // Update brand count if brand changed
      if (selectedBrandId != originalBrandId && originalBrandId > 0) {
        brandController.decrementProductCount(originalBrandId);
        brandController.incrementProductCount(selectedBrandId);
      }

      // Update category count if category changed
      if (selectedCategoryId != originalCategoryId && originalCategoryId > 0) {
        categoryController.decrementProductCount(originalCategoryId);
        categoryController.incrementProductCount(selectedCategoryId);
      }

      // Update original values for future updates
      originalBrandId = selectedBrandId;
      originalCategoryId = selectedCategoryId;

      // Update the image
      try {
        await mediaController.imageAssigner(productId.value,
            MediaCategory.products.toString().split('.').last, true);
        debugPrint('Product image updated successfully');
      } catch (e) {
        debugPrint('Error updating product image: $e');
      }

      // Update local list
      final index =
          allProducts.indexWhere((p) => p.productId == productId.value);
      if (index != -1) {
        allProducts[index] = productModel;
        debugPrint('Updated product in local list at index: $index');
      } else {
        debugPrint('Product not found in local list, adding it');
        allProducts.add(productModel);
      }

      // Check for low stock
      await checkLowStock([productId.value]);

      // Show success message
      TLoaders.successSnackBar(
        title: "Success",
        message: 'Product updated successfully!',
      );
      Navigator.of(Get.context!).pop();
      return true;
    } catch (e) {
      debugPrint('Error updating product: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void setProductDetail(ProductModel product) {
    try {
      final BrandController brandController = Get.find<BrandController>();
      final CategoryController categoryController =
          Get.find<CategoryController>();

      productId.value = product.productId ?? -1;
      productName.text = product.name;
      productDescription.text = product.description ?? ' ';
      basePrice.text = product.basePrice ?? ' ';
      salePrice.text = product.salePrice ?? ' ';
      stock.text = product.stockQuantity.toString();
      alertStock.text = product.alertStock.toString();
      selectedBrandId = product.brandID ?? -1;
      selectedCategoryId = product.categoryId ?? -1;

      // Store original values for detecting changes on update
      originalBrandId = product.brandID ?? -1;
      originalCategoryId = product.categoryId ?? -1;

      selectedBrandNameController.text = brandController.allBrands
              .firstWhere((brand) => brand.brandID == product.brandID)
              .brandName ??
          '';
      selectedCategoryNameController.text = categoryController.allCategories
          .firstWhere((category) => category.categoryId == product.categoryId)
          .categoryName;

      productTag.value = product.productTag;
      isPopular.value = product.isPopular ?? false;
      isVisible.value = product.isVisible ?? false;

      // Fetch product variants
      if (product.productId != null) {
        fetchProductVariants(product.productId!);
      }

      // Fetch product images when product is selected
      fetchProductImages();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> fetchProducts() async {
    try {
      final product = await productRepository.fetchProducts();
      allProducts.assignAll(product);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'ProductController', message: e.toString());
    }
  }

  // Method to refresh products data from database
  Future<void> refreshProducts() async {
    try {
      await fetchProducts();
      update();
      if (kDebugMode) {
        print('Product list refreshed from database');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing products: $e');
      }
    }
  }

  // Fetch variants for a specific product
  Future<void> fetchProductVariants(int productId) async {
    if (_isInVariantFetch) {
      debugPrint('Already in fetchProductVariants - preventing loop');
      return;
    }

    try {
      _isInVariantFetch = true;
      isAddingVariants.value = true;

      // Clear variants lists before fetching
      currentProductVariants.clear();

      debugPrint('Starting variant fetch for product $productId');
      final variants =
          await productVariantsRepository.fetchProductVariants(productId);
      debugPrint('Fetch completed, found ${variants.length} variants');

      // Store variants
      currentProductVariants.assignAll(variants);

      // Update the product stock display
      updateProductStockFromVariants();

      update(['variants_list']);
    } catch (e) {
      debugPrint('Error fetching variants: $e');
    } finally {
      isAddingVariants.value = false;
      _isInVariantFetch = false;
      update(['variants_list']);
      debugPrint('Exiting fetchProductVariants');
    }
  }

  // Add variant to unsaved list
  void addVariantToUnsaved(ProductVariantModel variant) {
    // Check if variant already exists (for editing)
    if (variant.variantId != null) {
      // For existing variants, update in currentProductVariants
      final index = currentProductVariants
          .indexWhere((v) => v.variantId == variant.variantId);
      if (index != -1) {
        currentProductVariants[index] = variant;
      }
    } else {
      // For new variants, add to unsaved list
      unsavedProductVariants.add(variant);
    }

    // Update total stock display
    updateProductStockFromVariants();

    TLoaders.successSnackBar(
      title: "Variant Added",
      message: 'Variant added successfully. Remember to save changes.',
    );
  }

  // Save unsaved variants to database
  Future<void> saveUnsavedVariants() async {
    if (unsavedProductVariants.isEmpty) return;

    isAddingVariants.value = true;
    try {
      debugPrint('Starting to save ${unsavedProductVariants.length} variants');

      final int variantCount = unsavedProductVariants.length;

      for (final variant in unsavedProductVariants) {
        debugPrint(
            'Saving variant: ${variant.variantName} for product: ${productId.value}');

        final result = await productVariantsRepository
            .insertVariant(variant.copyWith(productId: productId.value));

        if (result > 0) {
          debugPrint(
              '✓ Saved variant with ID: $result and name: ${variant.variantName}');
          // Add to current variants with the new ID
          currentProductVariants.add(
              variant.copyWith(variantId: result, productId: productId.value));
        } else {
          debugPrint('✗ Failed to save variant: ${variant.variantName}');
        }
      }

      // Clear the unsaved list after successful save
      unsavedProductVariants.clear();

      // Update stock display
      updateProductStockFromVariants();

      TLoaders.successSnackBar(
        title: "Variants Saved",
        message: "$variantCount variants saved to database",
      );
    } catch (e) {
      debugPrint('Error saving variants: $e');
      TLoaders.errorSnackBar(
        title: "Error Saving Variants",
        message: e.toString(),
      );
    } finally {
      isAddingVariants.value = false;
      update(['variants_list']);
    }
  }

  // Delete a variant
  Future<void> deleteVariant(int variantId) async {
    try {
      await productVariantsRepository.deleteVariant(variantId);

      // Remove from current variants list
      currentProductVariants.removeWhere((v) => v.variantId == variantId);

      // Update stock display
      updateProductStockFromVariants();

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Variant deleted successfully',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Delete Error",
        message: e.toString(),
      );
    }
  }

  // Delete unsaved variant
  void deleteUnsavedVariant(String variantName) {
    unsavedProductVariants.removeWhere((v) => v.variantName == variantName);
    updateProductStockFromVariants();
  }

  // Update the product's stock count based on variants
  void updateProductStockFromVariants() {
    if (productId.value == -1) return;

    final totalStock = _calculateTotalStock();

    // Update the stock field in the UI
    stock.text = totalStock.toString();

    // Update in allProducts list if product exists
    final index = allProducts.indexWhere((p) => p.productId == productId.value);
    if (index != -1) {
      final updatedProduct =
          allProducts[index].copyWith(stockQuantity: totalStock);
      allProducts[index] = updatedProduct;
    }

    debugPrint('Updated stock to: $totalStock');
  }

  // Calculate total stock from all variants
  int _calculateTotalStock() {
    final currentStock = currentProductVariants.fold<int>(
        0, (sum, variant) => sum + variant.stock);
    final unsavedStock = unsavedProductVariants.fold<int>(
        0, (sum, variant) => sum + variant.stock);
    return currentStock + unsavedStock;
  }

  int? findProductIdByName(String productName) {
    try {
      return allProducts
          .firstWhere((product) => product.name == productName)
          .productId;
    } catch (e) {
      return null; // Return null if the product is not found
    }
  }

  // Method to update stock quantity for products
  Future<void> updateStockQuantities(List<OrderItemModel>? orderItems) async {
    if (orderItems == null || orderItems.isEmpty) return;

    for (var item in orderItems) {
      if (item.variantId != null) {
        // For variant-based orders, update the specific variant stock
        final variant = currentProductVariants
            .firstWhereOrNull((v) => v.variantId == item.variantId);
        if (variant != null) {
          final newStock = variant.stock - item.quantity;
          await productVariantsRepository.updateVariantStock(
              item.variantId!, newStock.clamp(0, 999999));
        }
      } else {
        // For non-variant orders, update overall product stock
        await productRepository.updateStockQuantity(
          productId: item.productId,
          quantitySold: item.quantity,
        );
      }

      // Update local list
      final productIndex =
          allProducts.indexWhere((p) => p.productId == item.productId);
      if (productIndex != -1) {
        // Recalculate stock from variants
        final totalStock = await productVariantsRepository
            .calculateProductStock(item.productId);
        final updatedProduct =
            allProducts[productIndex].copyWith(stockQuantity: totalStock);
        allProducts[productIndex] = updatedProduct;
        update();
      }
    }
  }

  // Method to add stock quantity for product variants
  Future<void> addVariantStock(int variantId, int quantityToAdd) async {
    try {
      if (currentProductVariants.isEmpty) {
        print('currentProductVariants is empty');
      }
      final variant = currentProductVariants
          .firstWhereOrNull((v) => v.variantId == variantId);

      if (variant != null) {
        final newStock = variant.stock + quantityToAdd;
        await productVariantsRepository.updateVariantStock(variantId, newStock);

        // Update local list
        final index =
            currentProductVariants.indexWhere((v) => v.variantId == variantId);
        if (index != -1) {
          currentProductVariants[index] = variant.copyWith(stock: newStock);
          update(); // Update UI if necessary
        }
        // Also update the overall product stock display
        updateProductStockFromVariants();
      } else {
        // Handle case where variant is not found locally (e.g., fetch from repo if needed)
        // For now, just log a warning or error
        if (kDebugMode) {
          print('Warning: Variant $variantId not found in local list.');
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Stock Update Error', message: e.toString());
    }
  }

  Future<void> checkLowStock(List<int> productIds) async {
    try {
      await productRepository.checkLowStock(productIds);
    } catch (e) {
      if (kDebugMode) {
        print('Low Stock Check Error: $e');
      }
    }
  }

  void onProductTap(ProductModel product) async {
    setProductDetail(product);
    Get.toNamed(TRoutes.productsDetail, arguments: product);
  }

  // Get visible variants for a product
  Future<List<ProductVariantModel>> getVisibleVariants(int productId) async {
    try {
      return await productVariantsRepository.fetchVisibleVariants(productId);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Fetch Variants Error', message: e.toString());
      return [];
    }
  }

  Future<void> handleSave() async {
    try {
      if (isUpdating.value) return;
      isUpdating.value = true;
      try {
        if (productId.value == -1) {
          await insertProduct();
        } else {
          await updateProduct();
        }
      } finally {
        isUpdating.value = false;
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void handleDiscard() {
    if (isUpdating.value) return;
    cleanProductDetail();
    Get.back();
  }

  //==========================================================================
  // PRODUCT IMAGES MANAGEMENT
  //==========================================================================

  /// Fetch all images for the current product
  Future<void> fetchProductImages() async {
    if (productId.value <= 0) {
      productImages.clear();
      return;
    }

    try {
      isLoadingImages.value = true;
      final response = await supabase
          .from('image_entity')
          .select('*')
          .eq('entity_id', productId.value)
          .eq('entity_category',
              MediaCategory.products.toString().split('.').last);

      final images = response
          .map<ImageEntityModel>((json) => ImageEntityModel.fromJson(json))
          .toList();

      productImages.assignAll(images);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching product images: $e');
      }
    } finally {
      isLoadingImages.value = false;
    }
  }

  /// Add a new image to the product
  void addProductImage(ImageEntityModel imageEntity) {
    if (!productImages
        .any((img) => img.imageEntityId == imageEntity.imageEntityId)) {
      productImages.add(imageEntity);
    }
  }

  /// Remove an image from the product
  void removeProductImage(int imageEntityId) {
    productImages.removeWhere((img) => img.imageEntityId == imageEntityId);
  }

  /// Update an existing image (e.g., set as featured)
  void updateProductImage(ImageEntityModel updatedImage) {
    final index = productImages
        .indexWhere((img) => img.imageEntityId == updatedImage.imageEntityId);
    if (index != -1) {
      productImages[index] = updatedImage;
    }
  }

  /// Set an image as featured and unset others
  void setImageAsFeatured(int imageEntityId) {
    for (int i = 0; i < productImages.length; i++) {
      if (productImages[i].imageEntityId == imageEntityId) {
        productImages[i] = productImages[i].copyWith(isFeatured: true);
      } else if (productImages[i].isFeatured == true) {
        productImages[i] = productImages[i].copyWith(isFeatured: false);
      }
    }
  }

  /// Get the featured image
  ImageEntityModel? getFeaturedImage() {
    try {
      return productImages.firstWhere((img) => img.isFeatured == true);
    } catch (e) {
      return null;
    }
  }

  /// Clear product images
  void clearProductImages() {
    productImages.clear();
  }
}
