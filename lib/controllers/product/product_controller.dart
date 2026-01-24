import 'package:ecommerce_dashboard/Models/orders/order_item_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/Models/products/varaint_batches_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/repositories/products/product_repository.dart';
import 'package:ecommerce_dashboard/repositories/products/product_variants_repository.dart';
import 'package:ecommerce_dashboard/repositories/products/variant_batches_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../../routes/routes.dart';
import '../../utils/constants/enums.dart';
import '../../utils/ai/gemini_service.dart';
import '../media/media_controller.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());
  final productVariantsRepository = Get.put(ProductVariantsRepository());
  final variantBatchesRepository = Get.put(VariantBatchesRepository());
  final MediaController mediaController = Get.find<MediaController>();

  // Focus nodes for tab order
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode serialNumbersFocusNode =
      FocusNode(); // Deprecated - kept for compatibility
  final FocusNode basePriceFocusNode = FocusNode();
  final FocusNode salePriceFocusNode = FocusNode();
  final FocusNode stockFocusNode = FocusNode();
  final FocusNode alertStockFocusNode = FocusNode();

  // Lists to store models
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductVariantModel> productVariants = <ProductVariantModel>[].obs;
  RxList<VariantBatchesModel> variantBatches = <VariantBatchesModel>[].obs;

  // Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  // Variables
  Rx<String> selectedProduct = ''.obs;
  RxBool isUpdating = false.obs;
  RxBool isLoadingVariants = false.obs;
  RxBool isLoadingAddProductVariant = false.obs;
  RxBool isGeneratingDescription = false.obs;

  // Deprecated properties - kept for compatibility
  RxBool hasSerialNumbers = false.obs; // Always false now, use variants instead

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

  // Variant management controllers
  final variantNameController = TextEditingController();
  final variantSkuController = TextEditingController();

  int selectedBrandId = -1;
  int selectedCategoryId = -1;
  // Track original brand and category for updates
  int originalBrandId = -1;
  int originalCategoryId = -1;

  GlobalKey<FormState> productDetail = GlobalKey<FormState>();
  GlobalKey<FormState> variantForm = GlobalKey<FormState>();

  RxInt entityId = (-1).obs;

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
    variantNameController.dispose();
    variantSkuController.dispose();

    // Dispose focus nodes
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    serialNumbersFocusNode.dispose(); // Deprecated
    basePriceFocusNode.dispose();
    salePriceFocusNode.dispose();
    stockFocusNode.dispose();
    alertStockFocusNode.dispose();

    // Clear any cached data to prevent stale state
    productVariants.clear();
    variantBatches.clear();

    super.onClose();
  }

  // Reset UI state when navigating away
  void resetState() {
    cleanProductDetail();
    productId.value = -1;
    isUpdating.value = false;
    isLoadingAddProductVariant.value = false;
  }

  // Clean all form data for a fresh start
  void cleanProductDetail() {
    try {
      productId.value = -1;
      productName.clear();
      productDescription.clear();
      basePrice.clear();
      salePrice.clear();
      stock.text = '0';
      alertStock.clear();
      brandName.clear();
      selectedBrandId = -1;
      selectedCategoryId = -1;
      originalBrandId = -1;
      originalCategoryId = -1;
      selectedCategoryNameController.clear();
      selectedBrandNameController.clear();

      // Clear variant data
      variantNameController.clear();
      variantSkuController.clear();
      productVariants.clear();
      variantBatches.clear();

      // Reset loading states
      isLoadingVariants.value = false;
      isLoadingAddProductVariant.value = false;

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

      // Create the product model
      final productModel = ProductModel(
        productId: null,
        name: productName.text.trim(),
        description: productDescription.text.trim(),
        basePrice: basePrice.text.trim(),
        salePrice: salePrice.text.trim(),
        stockQuantity: int.tryParse(stock.text.trim()) ?? 0,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
      );

      // Insert the product into the database
      final json = productModel.toJson(isUpdate: true);
      debugPrint('Inserting product with data: $json');

      // Using a Future.delayed to prevent UI freeze
      await Future.delayed(Duration.zero);
      final newProductId = await productRepository.insertProductInTable(json);
      debugPrint('Product inserted with ID: $newProductId');

      // Check for valid product ID
      if (newProductId <= 0) {
        debugPrint('Invalid product ID returned: $newProductId');
        throw Exception(
            "Failed to insert product. Invalid product ID returned.");
      }

      // Assign the product ID to the model
      productModel.productId = newProductId;
      productId.value = newProductId;
      debugPrint('Product ID set in controller: ${productId.value}');

      // Increment product count in brand and category
      final BrandController brandController = Get.find<BrandController>();
      final CategoryController categoryController =
          Get.find<CategoryController>();

      brandController.incrementProductCount(selectedBrandId);
      categoryController.incrementProductCount(selectedCategoryId);

      // Save the original values for potential future updates
      originalBrandId = selectedBrandId;
      originalCategoryId = selectedCategoryId;

      // Save the image (wrapped in try-catch to continue even if image upload fails)
      try {
        await mediaController.imageAssigner(newProductId,
            MediaCategory.products.toString().split('.').last, true);
        debugPrint('Product image uploaded successfully');
      } catch (e) {
        debugPrint('Error uploading image: $e');
        // Continue with product creation even if image upload fails
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

        // Navigator.of(Get.context!).pop();

      // Return the new product ID
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

      final productModel = ProductModel(
        productId: productId.value,
        name: productName.text.trim(),
        description: productDescription.text.trim(),
        basePrice: basePrice.text.trim(),
        salePrice: salePrice.text.trim(),
        stockQuantity: int.tryParse(stock.text.trim()) ?? 0,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
      );

      final json = productModel.toJson(isUpdate: true);
      debugPrint('Updating product with data: $json');

      await productRepository.updateProduct(json);
      debugPrint('Product update database call completed');

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
        // Continue even if image update fails
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
      productName.text = product.name ;
      productDescription.text = product.description ?? '';
      basePrice.text = product.basePrice ?? '';
      salePrice.text = product.salePrice ?? '';
      stock.text = product.stockQuantity.toString();
      alertStock.text = product.alertStock.toString();
      selectedBrandId = product.brandID ?? -1;
      selectedCategoryId = product.categoryId ?? -1;

      // Store original values for detecting changes on update
      originalBrandId = product.brandID ?? -1;
      originalCategoryId = product.categoryId ?? -1;

      selectedBrandNameController.text = brandController.allBrands
              .firstWhere((brand) => brand.brandID == product.brandID)
              .brandname ??
          '';
      selectedCategoryNameController.text = categoryController.allCategories
          .firstWhere((category) => category.categoryId == product.categoryId)
          .categoryName;

      // Load product variants if available
      if (product.productId != null) {
        fetchProductVariants(product.productId!);
      }
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
    try {
      isLoadingVariants.value = true;
      productVariants.clear();

      final variants =
          await productVariantsRepository.fetchProductVariants(productId);
      productVariants.assignAll(variants);

      debugPrint('Fetched ${variants.length} variants for product $productId');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Fetch Error',
          message: 'Failed to fetch variants: $e');
    } finally {
      isLoadingVariants.value = false;
    }
  }

  // Add a new variant to the product
  Future<void> addProductVariant() async {
    try {
      if (productId.value == -1) {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Please save the product first');
        return;
      }

      if (!variantForm.currentState!.validate()) {
        return;
      }

      isLoadingAddProductVariant.value = true;

      final newVariant = ProductVariantModel(
        productId: productId.value,
        variantName: variantNameController.text.trim(),
        sku: variantSkuController.text.trim(),
        isVisible: true,
      );

      final variantId =
          await productVariantsRepository.insertVariant(newVariant);

      // Add to local list
      productVariants.add(newVariant.copyWith(variantId: variantId));

      // Clear form
      variantNameController.clear();
      variantSkuController.clear();

      TLoaders.successSnackBar(
          title: 'Success', message: 'Variant added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to add variant: $e');
    } finally {
      isLoadingAddProductVariant.value = false;
    }
  }

  // Update an existing product variant
  Future<void> updateProductVariant(ProductVariantModel variant) async {
    try {
      await productVariantsRepository.updateVariant(variant);

      // Update local list
      final index = productVariants.indexWhere((v) => v.variantId == variant.variantId);
      if (index != -1) {
        productVariants[index] = variant;
      }

      TLoaders.successSnackBar(
          title: 'Success', message: 'Variant updated successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to update variant: $e');
    }
  }

  // Delete a product variant
  Future<void> deleteProductVariant(int variantId) async {
    try {
      await productVariantsRepository.deleteVariant(variantId);

      // Remove from local list
      productVariants.removeWhere((v) => v.variantId == variantId);

      TLoaders.successSnackBar(
          title: 'Success', message: 'Variant deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to delete variant: $e');
    }
  }

  // Get available variant batches for a product
  Future<List<VariantBatchesModel>> getAvailableVariantBatches(
      int productId) async {
    try {
      return await variantBatchesRepository
          .fetchProductVariantBatches(productId, availableOnly: true);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Fetch Variant Batches Error', message: e.toString());
      return [];
    }
  }

  // Fetch variant batches for display in UI
  Future<void> fetchVariantBatches(int productId) async {
    try {
      isLoadingVariants.value = true;
      variantBatches.clear();

      final batches =
          await variantBatchesRepository.fetchProductVariantBatches(productId);
      variantBatches.assignAll(batches);

      debugPrint(
          'Fetched ${batches.length} variant batches for product $productId');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Batch Fetch Error',
          message: 'Failed to fetch variant batches: $e');
    } finally {
      isLoadingVariants.value = false;
    }
  }

  int? findProductIdByName(String productName) {
    try {
      return allProducts
          .firstWhere((product) => product.name == productName)
          .productId;
    } catch (e) {
      return null;
    }
  }

  // Method to update stock quantity for products
  Future<void> updateStockQuantities(List<OrderItemModel>? orderItems) async {
    if (orderItems == null || orderItems.isEmpty) return;

    for (var item in orderItems) {
      // Update stock quantity
      await productRepository.updateStockQuantity(
        productId: item.productId,
        quantitySold: item.quantity,
      );

      // Update local list
      final productIndex =
          allProducts.indexWhere((p) => p.productId == item.productId);
      if (productIndex != -1) {
        final updatedProduct = allProducts[productIndex].copyWith(
          stockQuantity:
              allProducts[productIndex].stockQuantity! - item.quantity,
        );
        allProducts[productIndex] = updatedProduct;
        update();
      }
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

  Future<void> handleSave() async {
    try {
      if (isUpdating.value) return;
      isUpdating.value = true;
      
        if (productId.value == -1) {
          await insertProduct();
        } else {
          await updateProduct();
        }
      
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
    finally{
      isUpdating.value = false;
    }
  }

  void handleDiscard() {
    if (isUpdating.value) return;
    cleanProductDetail();
    Get.back();
  }

  // Deprecated methods - kept for compatibility
  void toggleHasSerialNumbers(bool value) {
    // This method is deprecated. Serial numbers are replaced with variants.
    // Always keep hasSerialNumbers as false
    hasSerialNumbers.value = false;
  }

  /// Generates a product description using Gemini AI
  /// Validates that product name is not empty before generating
  Future<void> generateDescription() async {
    if (kDebugMode) {
      print('[ProductController] generateDescription() called');
    }

    try {
      // Validate product name is not empty
      final productNameText = productName.text.trim();
      
      if (kDebugMode) {
        print('[ProductController] Validating product name: "$productNameText"');
      }

      if (productNameText.isEmpty) {
        if (kDebugMode) {
          print('[ProductController] ❌ Product name is empty - validation failed');
        }
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Please enter a product name first',
        );
        return;
      }

      if (kDebugMode) {
        print('[ProductController] ✅ Product name validation passed');
        print('[ProductController] Setting isGeneratingDescription to true');
      }

      isGeneratingDescription.value = true;

      if (kDebugMode) {
        print('[ProductController] Calling GeminiService.generateProductDescription()');
      }

      // Generate description using Gemini
      final description = await GeminiService.generateProductDescription(productNameText);
      
      if (kDebugMode) {
        print('[ProductController] ✅ Description received from GeminiService');
        print('[ProductController] Description length: ${description.length} characters');
        print('[ProductController] Setting description to text field');
      }
      
      // Set the generated description
      productDescription.text = description;

      if (kDebugMode) {
        print('[ProductController] ✅ Description successfully set in text field');
      }

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Description generated successfully',
      );
    } catch (e) {
      if (kDebugMode) {
        print('[ProductController] ❌ Error in generateDescription()');
        print('[ProductController] Error type: ${e.runtimeType}');
        print('[ProductController] Error message: ${e.toString()}');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to generate description: ${e.toString()}',
      );
    } finally {
      if (kDebugMode) {
        print('[ProductController] Setting isGeneratingDescription to false');
      }
      isGeneratingDescription.value = false;
    }
  }
}
