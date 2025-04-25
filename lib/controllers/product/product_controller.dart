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

  // Lists to store models
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductVariantModel> currentProductVariants =
      <ProductVariantModel>[].obs;

  // Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  // Variables
  Rx<String> selectedProduct = ''.obs;
  RxBool isUpdating = false.obs;

  // New variables for serial-numbered products
  RxBool hasSerialNumbers = false.obs;
  RxBool isAddingVariants = false.obs;
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
  GlobalKey<FormState> productDetail = GlobalKey<FormState>();
  var variantForm = GlobalKey<FormState>();

  RxInt entityId = (-1).obs; // Form key for form validation

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
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
      selectedCategoryNameController.clear();
      selectedBrandNameController.clear();
      hasSerialNumbers.value = false;

      // Use clear method instead of clearing directly to reduce rebuilds
      if (currentProductVariants.isNotEmpty) {
        currentProductVariants.clear();
      }

      if (bulkImportVariants.isNotEmpty) {
        bulkImportVariants.clear();
      }

      csvData.clear();
      serialNumber.clear();
      purchasePrice.clear();
      variantSellingPrice.clear();
      update(); // Force UI update
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Function to insert new product
  Future<void> insertProduct() async {
    try {
      isUpdating.value = true;

      // First validate the basic product form
      if (!productDetail.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Invalid Form",
          message: 'Please fill all required fields correctly.',
        );
        return;
      }

      // Then validate the brand and category selection
      if (selectedBrandId == -1 || selectedCategoryId == -1) {
        TLoader.errorSnackBar(
          title: "Missing Selection",
          message: 'Please select both brand and category.',
        );
        return;
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

      // Using a Future.delayed to prevent UI freeze
      await Future.delayed(Duration.zero);
      final newProductId = await productRepository.insertProductInTable(json);

      // Check for valid product ID
      if (newProductId <= 0) {
        throw Exception(
            "Failed to insert product. Invalid product ID returned.");
      }

      // Assign the product ID to the model
      productModel.productId = newProductId;
      productId.value = newProductId;

      // Save the image (wrapped in try-catch to continue even if image upload fails)
      try {
        await mediaController.imageAssigner(newProductId,
            MediaCategory.products.toString().split('.').last, true);
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading image: $e');
        }
        // Continue with product creation even if image upload fails
      }

      // Add to local list
      allProducts.add(productModel);

      // For products without serial numbers, check for low stock
      if (!hasSerialNumbers.value) {
        await checkLowStock([newProductId]);
      }

      // Show success message
      TLoader.successSnackBar(
        title: "Success",
        message: 'Product added successfully!',
      );

      // Don't clear the form if it's a serialized product without variants
      if (!hasSerialNumbers.value || !currentProductVariants.isEmpty) {
        cleanProductDetail();
      }
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Function to update existing product
  Future<void> updateProduct() async {
    try {
      isUpdating.value = true;
      // Validate the form
      if (!productDetail.currentState!.validate() ||
          selectedBrandId == -1 ||
          selectedCategoryId == -1) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      final productModel = ProductModel(
        productId: productId.value,
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

      final json = productModel.toJson(isUpdate: true);
      await productRepository.updateProduct(json);

      // Update the image
      await mediaController.imageAssigner(productId.value,
          MediaCategory.products.toString().split('.').last, true);

      // Update local list
      final index =
          allProducts.indexWhere((p) => p.productId == productId.value);
      if (index != -1) {
        allProducts[index] = productModel;
      }

      // For products without serial numbers, check for low stock
      if (!hasSerialNumbers.value) {
        await checkLowStock([productId.value]);
      }

      // Show success message
      TLoader.successSnackBar(
        title: "Success",
        message: 'Product updated successfully!',
      );

      // Clear the form
      cleanProductDetail();
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
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
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> fetchProducts() async {
    try {
      final product = await productRepository.fetchProducts();
      allProducts.assignAll(product);
    } catch (e) {
      TLoader.errorSnackBar(title: 'ProductController', message: e.toString());
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
      // If already fetching variants, don't start a new fetch
      if (isAddingVariants.value) return;

      isAddingVariants.value = true;

      // Check if we already have variants for this product
      // to avoid unnecessary fetches
      if (this.productId.value == productId &&
          currentProductVariants.isNotEmpty) {
        isAddingVariants.value = false;
        return;
      }

      // Clear previous variants if productId is different
      if (this.productId.value != productId) {
        currentProductVariants.clear();
      }

      // Use a debounce mechanism to prevent multiple rapid requests
      await Future.delayed(const Duration(milliseconds: 100));

      // Limit the initial load to 100 variants
      final variants = await productVariantsRepository
          .fetchProductVariants(productId, limit: 100);

      // Update in a single batch to reduce rebuilds
      if (variants.isNotEmpty) {
        currentProductVariants.value = variants;
      } else {
        currentProductVariants.clear();
      }

      updateProductStockFromVariants();
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'Fetch Variants Error', message: e.toString());
    } finally {
      isAddingVariants.value = false;
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

      isAddingVariants.value = true;
      debugPrint(
          'Product ID: ${productId.value}, Has Form: ${variantForm.currentState != null}');

      if (productId.value <= 0) {
        // If product ID is invalid, we need to save the product first
        debugPrint(
            'Invalid product ID (${productId.value}) - attempting to save product first');
        if (productName.text.trim().isEmpty) {
          TLoader.errorSnackBar(
            title: "Product Name Required",
            message: 'Enter a product name before adding variants',
          );
          return;
        }

        // Insert the product first
        await insertProduct();

        // Check if product was inserted successfully
        if (productId.value <= 0) {
          // Product insertion failed
          debugPrint('Product insertion failed - aborting variant add');
          TLoader.errorSnackBar(
            title: "Product Save Failed",
            message: 'Cannot add variant without saving product first',
          );
          return;
        }
      }

      // Directly validate the field values instead of using form validation
      final serialNum = serialNumber.text.trim();
      final buyPrice = purchasePrice.text.trim();
      final sellPrice = variantSellingPrice.text.trim();

      debugPrint('Serial: $serialNum, Buy: $buyPrice, Sell: $sellPrice');

      if (serialNum.isEmpty || buyPrice.isEmpty || sellPrice.isEmpty) {
        debugPrint('Fields empty - returning early');
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Please fill all variant details',
        );
        return;
      }

      if (double.tryParse(buyPrice) == null) {
        TLoader.errorSnackBar(
          title: "Invalid Price",
          message: 'Buy price must be a valid number',
        );
        return;
      }

      if (double.tryParse(sellPrice) == null) {
        TLoader.errorSnackBar(
          title: "Invalid Price",
          message: 'Sell price must be a valid number',
        );
        return;
      }

      // Create the variant
      final variant = ProductVariantModel(
        productId: productId.value,
        serialNumber: serialNum,
        purchasePrice: double.tryParse(buyPrice) ?? 0.0,
        sellingPrice: double.tryParse(sellPrice) ?? 0.0,
      );

      // Check if serial number already exists
      final existingVariant = await productVariantsRepository
          .getVariantBySerialNumber(variant.serialNumber);
      if (existingVariant != null) {
        debugPrint('Duplicate serial number found');
        TLoader.errorSnackBar(
          title: "Duplicate Serial Number",
          message: 'A product with this serial number already exists',
        );
        return;
      }

      debugPrint('Inserting variant to database');
      // Insert the variant
      final variantId = await productVariantsRepository.insertVariant(variant);
      debugPrint('Variant inserted with ID: $variantId');

      // Update the UI
      final newVariant = variant.copyWith(variantId: variantId);
      currentProductVariants.add(newVariant);
      debugPrint(
          'Added variant to currentProductVariants, total count: ${currentProductVariants.length}');

      // Clear the input fields
      serialNumber.clear();
      purchasePrice.clear();
      variantSellingPrice.clear();

      // Update the in-memory product stock count for UI display
      updateProductStockFromVariants();

      TLoader.successSnackBar(
        title: "Success",
        message: 'Variant added successfully',
      );
    } catch (e) {
      debugPrint('Error adding variant: $e');
      TLoader.errorSnackBar(
        title: "Error Adding Variant",
        message: e.toString(),
      );
    } finally {
      isAddingVariants.value = false;
      debugPrint('AddVariant completed');
    }
  }

  // Parse CSV data for bulk import
  void parseCsvData() {
    try {
      bulkImportVariants.clear();

      if (productId.value == -1) {
        TLoader.errorSnackBar(
          title: "Error",
          message: 'Please save the product first before adding variants',
        );
        return;
      }

      final lines = csvData.text.trim().split('\n');

      if (lines.isEmpty) {
        TLoader.errorSnackBar(
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
          TLoader.errorSnackBar(
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
        TLoader.errorSnackBar(
          title: "No Valid Data",
          message: 'No valid variant data found in the CSV input',
        );
        return;
      }

      TLoader.successSnackBar(
        title: "CSV Parsed",
        message: '${bulkImportVariants.length} variants ready for import',
      );
    } catch (e) {
      TLoader.errorSnackBar(
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

      if (bulkImportVariants.isEmpty) {
        TLoader.errorSnackBar(
          title: "No Variants",
          message: 'No variants to import. Parse CSV data first.',
        );
        return;
      }

      // Check for duplicate serial numbers in the database
      final Set<String> serialNumbers =
          bulkImportVariants.map((v) => v.serialNumber).toSet();
      for (String serialNumber in serialNumbers) {
        final existingVariant = await productVariantsRepository
            .getVariantBySerialNumber(serialNumber);
        if (existingVariant != null) {
          TLoader.errorSnackBar(
            title: "Duplicate Serial Number",
            message:
                'Serial number "$serialNumber" already exists in the database',
          );
          return;
        }
      }

      // Import all variants
      await productVariantsRepository
          .bulkImportVariants(bulkImportVariants.toList());

      // Refresh the variants list
      await fetchProductVariants(productId.value);

      // Update the in-memory product stock count for UI display
      updateProductStockFromVariants();

      // Clear the CSV data
      csvData.clear();
      bulkImportVariants.clear();

      TLoader.successSnackBar(
        title: "Success",
        message: 'All variants imported successfully',
      );
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Import Error",
        message: e.toString(),
      );
    } finally {
      isAddingVariants.value = false;
    }
  }

  // Delete a variant
  Future<void> deleteVariant(int variantId) async {
    try {
      await productVariantsRepository.deleteVariant(variantId);

      // Remove from the local list
      currentProductVariants.removeWhere((v) => v.variantId == variantId);

      // Update the in-memory product stock count for UI display
      updateProductStockFromVariants();

      TLoader.successSnackBar(
        title: "Success",
        message: 'Variant deleted successfully',
      );
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Delete Error",
        message: e.toString(),
      );
    }
  }

  // Update the product's stock count based on available variants
  void updateProductStockFromVariants() {
    if (!hasSerialNumbers.value || productId.value == -1) return;

    final availableVariants =
        currentProductVariants.where((v) => !v.isSold).length;

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

  // Get available (unsold) variants for a product
  Future<List<ProductVariantModel>> getAvailableVariants(int productId) async {
    try {
      return await productVariantsRepository.fetchAvailableVariants(productId);
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'Fetch Variants Error', message: e.toString());
      return [];
    }
  }
}
