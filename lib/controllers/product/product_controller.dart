import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/Models/products/product_variant_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_images_controller.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:admin_dashboard_v3/repositories/products/product_variants_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../routes/routes.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());
  final productVariantsRepository = Get.put(ProductVariantsRepository());
  final MediaController mediaController = Get.find<MediaController>();

  // Focus nodes for tab order
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode serialNumbersFocusNode = FocusNode();
  final FocusNode basePriceFocusNode = FocusNode();
  final FocusNode salePriceFocusNode = FocusNode();
  final FocusNode stockFocusNode = FocusNode();
  final FocusNode alertStockFocusNode = FocusNode();

  // Lists to store models
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductVariantModel> currentProductVariants =
      <ProductVariantModel>[].obs;
  RxList<ProductVariantModel> availableVariants =
      <ProductVariantModel>[].obs; // Store available variants only
  RxList<ProductVariantModel> soldVariants =
      <ProductVariantModel>[].obs; // Store sold variants separately

  // Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  // Variables
  Rx<String> selectedProduct = ''.obs;
  RxBool isUpdating = false.obs;

  // New variables for serial-numbered products
  RxBool hasSerialNumbers = false.obs;
  RxBool isAddingVariants = false.obs;
  RxBool showSoldVariants = false.obs; // Toggle for showing sold variants
  RxBool isLoadingSoldVariants = false.obs; // Loading state for sold variants
  RxBool soldVariantsFetched =
      false.obs; // Track if sold variants have been fetched
  final serialNumber = TextEditingController();
  final purchasePrice = TextEditingController();
  final variantSellingPrice = TextEditingController();

  // For bulk import
  RxList<ProductVariantModel> bulkImportVariants = <ProductVariantModel>[].obs;
  final csvData = TextEditingController();

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

  RxList<ProductVariantModel> unsavedProductVariants =
      <ProductVariantModel>[].obs;

  // Track if we're in the middle of a variant fetch to prevent loops
  bool _isInVariantFetch = false;

  // Computed property to get filtered variants based on toggle
  List<ProductVariantModel> get filteredVariants {
    if (showSoldVariants.value) {
      // Show all variants (available + sold + unsaved)
      return [...availableVariants, ...soldVariants, ...unsavedProductVariants];
    } else {
      // Show only available and unsaved variants
      return [...availableVariants, ...unsavedProductVariants];
    }
  }

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
    serialNumber.dispose();
    purchasePrice.dispose();
    variantSellingPrice.dispose();
    csvData.dispose();

    // Dispose focus nodes
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    serialNumbersFocusNode.dispose();
    basePriceFocusNode.dispose();
    salePriceFocusNode.dispose();
    stockFocusNode.dispose();
    alertStockFocusNode.dispose();

    // Clear any cached data to prevent stale state
    currentProductVariants.clear();
    bulkImportVariants.clear();

    super.onClose();
  }

  // Reset UI state when navigating away
  void resetState() {
    // Don't clear product details if we're still seeing the same product
    // to avoid re-fetching variants unnecessarily
    final currentProductId = productId.value;
    cleanProductDetail();

    // Reset main variables
    productId.value = -1;
    hasSerialNumbers.value = false;
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
      hasSerialNumbers.value = false;

      // Use clear method instead of clearing directly to reduce rebuilds
      if (currentProductVariants.isNotEmpty) {
        currentProductVariants.clear();
      }

      if (availableVariants.isNotEmpty) {
        availableVariants.clear();
      }

      if (soldVariants.isNotEmpty) {
        soldVariants.clear();
      }

      // Reset sold variants state
      isLoadingSoldVariants.value = false;
      soldVariantsFetched.value = false;

      if (bulkImportVariants.isNotEmpty) {
        bulkImportVariants.clear();
      }

      // Reset the sold variants toggle
      showSoldVariants.value = false;

      csvData.clear();
      serialNumber.clear();
      purchasePrice.clear();
      variantSellingPrice.clear();
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
        stockQuantity:
            hasSerialNumbers.value ? 0 : (int.tryParse(stock.text.trim()) ?? 0),
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
        hasSerialNumbers: hasSerialNumbers.value,
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

      // For products without serial numbers, check for low stock
      if (!hasSerialNumbers.value) {
        await checkLowStock([newProductId]);
      }

      // Show success message
      TLoaders.successSnackBar(
        title: "Success",
        message: 'Product added successfully!',
      );

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
        stockQuantity: (int.tryParse(stock.text.trim()) ??
            0), //not added if serial number is true
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
        hasSerialNumbers: hasSerialNumbers.value,
      );

      final json =
          productModel.toJson(isUpdate: true, isSerial: hasSerialNumbers.value);
      debugPrint('Updating product with data: $json');

      await productRepository.updateProduct(json);
      debugPrint('Product update database call completed');

      // Handle brand and category count updates if they changed
      final BrandController brandController = Get.find<BrandController>();
      final CategoryController categoryController =
          Get.find<CategoryController>();

      // Update brand count if brand changed
      if (selectedBrandId != originalBrandId && originalBrandId > 0) {
        // Decrement old brand count
        brandController.decrementProductCount(originalBrandId);
        // Increment new brand count
        brandController.incrementProductCount(selectedBrandId);
      }

      // Update category count if category changed
      if (selectedCategoryId != originalCategoryId && originalCategoryId > 0) {
        // Decrement old category count
        categoryController.decrementProductCount(originalCategoryId);
        // Increment new category count
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

      // For products without serial numbers, check for low stock
      if (!hasSerialNumbers.value) {
        await checkLowStock([productId.value]);
      }

      // Show success message
      TLoaders.successSnackBar(
        title: "Success",
        message: 'Product updated successfully!',
      );

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

      print(product.productId);
      productId.value = product.productId ?? -1;
      productName.text = product.name ?? ' ';
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
              .bname ??
          '';
      selectedCategoryNameController.text = categoryController.allCategories
          .firstWhere((category) => category.categoryId == product.categoryId)
          .categoryName;

      // Set the hasSerialNumbers flag
      hasSerialNumbers.value = product.hasSerialNumbers;

      // Fetch product variants if it's a serialized product
      if (product.hasSerialNumbers && product.productId != null) {
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
      // TLoaders.successSnackBar(
      //   title: 'Refreshed!',
      //   message: 'Product list has been updated.',
      // );
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing products: $e');
      }
    }
  }

  // Fetch variants for a specific product
  Future<void> fetchProductVariants(int productId) async {
    // Print stack trace to identify caller
    debugPrint('CALL STACK: fetchProductVariants called from:');
    try {
      throw Exception('Stack trace check');
    } catch (e, stackTrace) {
      debugPrint(stackTrace.toString().split('\n').take(10).join('\n'));
    }

    // Prevent infinite recursive calls
    if (_isInVariantFetch) {
      debugPrint('Already in fetchProductVariants - preventing loop');
      return;
    }

    try {
      _isInVariantFetch = true;
      isAddingVariants.value = true;

      // Use update to notify UI of loading state
      update(['variants_list']);

      // Clear variants lists before fetching
      currentProductVariants.clear();
      availableVariants.clear();

      // Fetch only available variants initially
      debugPrint('Starting available variant fetch for product $productId');
      final variants =
          await productVariantsRepository.fetchAvailableVariants(productId);
      debugPrint(
          'Fetch completed, found ${variants.length} available variants');

      // Store available variants
      availableVariants.assignAll(variants);

      // Update currentProductVariants based on filter
      updateFilteredVariantsList();
      debugPrint(
          'Assigned ${currentProductVariants.length} filtered variants to UI list');

      // Update the product stock count if needed
      debugPrint('About to update product stock from variants');
      updateProductStockFromVariants();
      debugPrint('Stock updated');

      // Use GetBuilder update to refresh the UI with new data
      update(['variants_list']);
    } catch (e) {
      debugPrint('Error fetching variants: $e');
      // Don't show error to user, just log it
    } finally {
      // Always reset loading state
      isAddingVariants.value = false;
      _isInVariantFetch = false;

      // Final update to ensure UI is refreshed with correct loading state
      update(['variants_list']);

      debugPrint('Exiting fetchProductVariants');
    }
  }

  // Add a variant to a product
  Future<void> addVariant() async {
    try {
      debugPrint('AddVariant called - starting process');
      // Prevent multiple simultaneous add operations
      if (isAddingVariants.value) {
        debugPrint('Already adding variant - skipping');
        return;
      }

      // Validate the form field values
      final serialNum = serialNumber.text.trim();
      final buyPrice = purchasePrice.text.trim();
      final sellPrice = variantSellingPrice.text.trim();

      debugPrint('Serial: $serialNum, Buy: $buyPrice, Sell: $sellPrice');

      if (serialNum.isEmpty || buyPrice.isEmpty || sellPrice.isEmpty) {
        debugPrint('Fields empty - returning early');
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Please fill all variant details',
        );
        return;
      }

      if (double.tryParse(buyPrice) == null) {
        TLoaders.errorSnackBar(
          title: "Invalid Price",
          message: 'Buy price must be a valid number',
        );
        return;
      }

      if (double.tryParse(sellPrice) == null) {
        TLoaders.errorSnackBar(
          title: "Invalid Price",
          message: 'Sell price must be a valid number',
        );
        return;
      }

      // Check if serial number already exists in current list
      if (currentProductVariants.any((v) => v.serialNumber == serialNum)) {
        TLoaders.errorSnackBar(
          title: "Duplicate Serial",
          message: 'This serial number already exists in the list',
        );
        return;
      }

      // Set loading state briefly to show feedback
      isAddingVariants.value = true;
      update(['variants_list']);

      // Small delay for visual feedback
      await Future.delayed(const Duration(milliseconds: 300));

      // Create the variant
      final variant = ProductVariantModel(
        productId: productId.value,
        serialNumber: serialNum,
        purchasePrice: double.tryParse(buyPrice) ?? 0.0,
        sellingPrice: double.tryParse(sellPrice) ?? 0.0,
      );

      // Add to unsaved list instead of database
      addVariantToUnsaved(variant);

      // Show success message
      TLoaders.successSnackBar(
        title: "Variant Added",
        message: 'Remember to save changes to store in database',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error Adding Variant",
        message: e.toString(),
      );
    } finally {
      // Reset loading state
      isAddingVariants.value = false;
      update(['variants_list']);
    }
  }

  // Add this method to handle temporary variant storage
  void addVariantToUnsaved(ProductVariantModel variant) {
    // Add new variant to unsaved list
    unsavedProductVariants.add(variant);

    // Update the filtered variants list
    updateFilteredVariantsList();

    // Clear the form fields after adding
    serialNumber.clear();
    purchasePrice.clear();
    variantSellingPrice.clear();
  }

  // Add this method to save unsaved variants to database
  Future<void> saveUnsavedVariants() async {
    if (unsavedProductVariants.isEmpty) return;

    isAddingVariants.value = true;
    try {
      debugPrint('Starting to save ${unsavedProductVariants.length} variants');

      // Keep track of the count to show in the success message
      final int variantCount = unsavedProductVariants.length;

      for (final variant in unsavedProductVariants) {
        // Add to database - use the current productId
        debugPrint(
            'Saving variant with serial: ${variant.serialNumber} for product: ${productId.value}');

        final result = await productVariantsRepository
            .insertVariant(variant.copyWith(productId: productId.value));

        if (result > 0) {
          debugPrint(
              '✓ Saved variant with ID: $result and serial: ${variant.serialNumber}');
        } else {
          debugPrint(
              '✗ Failed to save variant with serial: ${variant.serialNumber}');
        }
      }

      // Clear the unsaved list after successful save
      unsavedProductVariants.clear();

      // Refresh variants from database to get proper IDs
      await fetchProductVariants(productId.value);

      // Show a more accurate success message
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

  // Parse CSV data for bulk import
  void parseCsvData() {
    try {
      bulkImportVariants.clear();

      if (productId.value == -1) {
        TLoaders.errorSnackBar(
          title: "Error",
          message: 'Please save the product first before adding variants',
        );
        return;
      }

      final lines = csvData.text.trim().split('\n');

      if (lines.isEmpty) {
        TLoaders.errorSnackBar(
          title: "Empty CSV",
          message: 'No data found in the CSV input',
        );
        return;
      }

      // Process each line
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length < 3) {
          TLoaders.errorSnackBar(
            title: "Invalid CSV Format",
            message:
                'Line ${i + 1} has invalid format. Expected: SerialNumber,PurchasePrice,SellingPrice',
          );
          bulkImportVariants.clear();
          return;
        }

        // Parse the data
        final serialNumber = parts[0].trim();
        final purchasePrice = double.tryParse(parts[1].trim()) ?? 0.0;
        final sellingPrice = double.tryParse(parts[2].trim()) ?? 0.0;

        // Create a variant
        final variant = ProductVariantModel(
          productId: productId.value,
          serialNumber: serialNumber,
          purchasePrice: purchasePrice,
          sellingPrice: sellingPrice,
        );

        bulkImportVariants.add(variant);
      }

      if (bulkImportVariants.isEmpty) {
        TLoaders.errorSnackBar(
          title: "No Valid Data",
          message: 'No valid variant data found in the CSV input',
        );
        return;
      }

      TLoaders.successSnackBar(
        title: "CSV Parsed",
        message: '${bulkImportVariants.length} variants ready for import',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "CSV Parse Error",
        message: e.toString(),
      );
      bulkImportVariants.clear();
    }
  }

  // Bulk import variants
  Future<void> bulkImportVariantsToProduct() async {
    try {
      isAddingVariants.value = true;
      update(['variants_list']);

      if (bulkImportVariants.isEmpty) {
        TLoaders.errorSnackBar(
          title: "No Variants",
          message: 'No variants to import. Parse CSV data first.',
        );
        return;
      }

      // Use a brief delay for UI feedback
      await Future.delayed(const Duration(milliseconds: 300));

      // Check for duplicate serial numbers in existing list
      for (final importVariant in bulkImportVariants) {
        if (currentProductVariants
            .any((v) => v.serialNumber == importVariant.serialNumber)) {
          TLoaders.errorSnackBar(
            title: "Duplicate Serial Number",
            message:
                'Serial number "${importVariant.serialNumber}" already exists in the list',
          );
          return;
        }
      }

      // Add all variants to the unsaved list
      for (final importVariant in bulkImportVariants) {
        addVariantToUnsaved(importVariant);
        // Brief delay between additions to allow UI to update
        await Future.delayed(const Duration(milliseconds: 50));
      }

      final importCount = bulkImportVariants.length;

      // Clear the CSV data and import list
      csvData.clear();
      bulkImportVariants.clear();

      TLoaders.successSnackBar(
        title: "Success",
        message:
            '$importCount variants added to list. Remember to save changes.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Import Error",
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

      // Remove from both the availableVariants and soldVariants lists
      availableVariants.removeWhere((v) => v.variantId == variantId);
      soldVariants.removeWhere((v) => v.variantId == variantId);

      // Update the filtered variants list
      updateFilteredVariantsList();

      // Update the in-memory product stock count for UI display
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

  // Update the product's stock count based on available variants
  void updateProductStockFromVariants() {
    debugPrint(
        'STOCK UPDATE: hasSerialNumbers=${hasSerialNumbers.value}, productId=${productId.value}');
    if (!hasSerialNumbers.value || productId.value == -1) return;

    final availableVariants =
        currentProductVariants.where((v) => !v.isSold).length;
    debugPrint('Available variants count: $availableVariants');

    // Find the product in the allProducts list
    final index = allProducts.indexWhere((p) => p.productId == productId.value);
    if (index != -1) {
      // Update the stock quantity
      final updatedProduct = allProducts[index].copyWith(
        stockQuantity: availableVariants,
      );

      // Replace the product in the list
      allProducts[index] = updatedProduct;

      // Update the stock field in the UI
      stock.text = availableVariants.toString();
      debugPrint('Updated stock UI to: $availableVariants');
    } else {
      debugPrint('Product not found in allProducts list');
    }
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

  // Method to update stock quantity for non-serialized products
  Future<void> updateStockQuantities(List<OrderItemModel>? orderItems) async {
    if (orderItems == null || orderItems.isEmpty) return;

    for (var item in orderItems) {
      // Check if this is a serialized product
      final product = allProducts.firstWhere(
        (p) => p.productId == item.productId,
        orElse: () => ProductModel.empty(),
      );

      if (product.hasSerialNumbers) {
        // For serialized products, mark variants as sold
        if (item.variantId != null) {
          await productVariantsRepository.markVariantAsSold(item.variantId!);
        }
      } else {
        // For non-serialized products, update stock quantity
        await productRepository.updateStockQuantity(
          productId: item.productId,
          quantitySold: item.quantity,
        );
      }

      // Update local list
      final productIndex =
          allProducts.indexWhere((p) => p.productId == item.productId);
      if (productIndex != -1) {
        if (product.hasSerialNumbers) {
          // For serialized products, we'll fetch the exact count from variants
          final availableCount = await productVariantsRepository
              .countAvailableVariants(item.productId);
          final updatedProduct = allProducts[productIndex].copyWith(
            stockQuantity: availableCount,
          );
          allProducts[productIndex] = updatedProduct;
        } else {
          // For non-serialized products, just decrement the count
          final updatedProduct = allProducts[productIndex].copyWith(
            stockQuantity:
                allProducts[productIndex].stockQuantity! - item.quantity,
          );
          allProducts[productIndex] = updatedProduct;
        }
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
      // Don't show error to user since this is just a notification feature
      // and shouldn't block regular operations
    }
  }

  void onProductTap(ProductModel product) async {
    setProductDetail(product);
    Get.toNamed(TRoutes.productsDetail, arguments: product);
  }

  /// Toggles the has serial numbers flag and updates the UI
  void toggleHasSerialNumbers(bool value) {
    hasSerialNumbers.value = value;

    if (value) {
      // Clear the stock field since it will be auto-calculated
      stock.text = '0';
      basePrice.text = '0';
      salePrice.text = '0';

      // Force immediate UI update
      update();

      // Schedule another update to ensure form visibility after state changes
      Future.delayed(Duration.zero, () {
        currentProductVariants.refresh();
        update();
      });
    } else {
      // Clear variants if serial numbers are disabled
      currentProductVariants.clear();
      csvData.clear();
      update();
    }
  }

  /// Toggles the visibility of sold variants
  void toggleSoldVariants(bool value) {
    showSoldVariants.value = value;

    // If enabling and sold variants haven't been fetched yet, fetch them
    if (value && !soldVariantsFetched.value && productId.value > 0) {
      fetchSoldVariants(productId.value);
    } else {
      // Update the current variants list based on the filter
      updateFilteredVariantsList();
    }
  }

  /// Fetches sold variants from the database
  Future<void> fetchSoldVariants(int productId) async {
    try {
      isLoadingSoldVariants.value = true;

      debugPrint('Fetching sold variants for product $productId');

      // Fetch all variants then filter for sold ones
      final allVariants = await productVariantsRepository
          .fetchProductVariants(productId, limit: 100);

      final soldVariantsList = allVariants.where((v) => v.isSold).toList();
      debugPrint('Found ${soldVariantsList.length} sold variants');

      // Store sold variants
      soldVariants.assignAll(soldVariantsList);
      soldVariantsFetched.value = true;

      // Update the filtered variants list
      updateFilteredVariantsList();
    } catch (e) {
      debugPrint('Error fetching sold variants: $e');
      TLoaders.errorSnackBar(
          title: "Error", message: "Failed to load sold variants: $e");
    } finally {
      isLoadingSoldVariants.value = false;
    }
  }

  /// Updates the currentProductVariants list based on the filter
  void updateFilteredVariantsList() {
    currentProductVariants.assignAll(filteredVariants);
    update(['variants_list']);
  }

  // Get available (unsold) variants for a product
  Future<List<ProductVariantModel>> getAvailableVariants(int productId) async {
    try {
      return await productVariantsRepository.fetchAvailableVariants(productId);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Fetch Variants Error', message: e.toString());
      return [];
    }
  }

  // Add a method to delete unsaved variants
  void deleteUnsavedVariant(String serialNumber) {
    // Remove from unsaved list
    unsavedProductVariants.removeWhere((v) => v.serialNumber == serialNumber);

    // Update the filtered variants list
    updateFilteredVariantsList();
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
      Navigator.of(Get.context!).pop();
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
}
