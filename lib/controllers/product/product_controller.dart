import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_images_controller.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());
  final MediaController mediaController = Get.find<MediaController>();

//List of product Model
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  //List of names for searchbar
  // RxList<String> productNames = <String>[].obs;

//Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  //Variables
  Rx<String> selectedProduct = ''.obs;
  RxBool isUpdating = false.obs;

  //Product Detail Controllers
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

  RxInt entityId = (-1).obs; // Form key for form validation

  @override
  void onInit() {
    fetchProducts();

    super.onInit();
  }

  @override
  void onClose() {
    productName.dispose();
    productDescription.dispose();
    basePrice.dispose();
    stock.dispose();
    alertStock.dispose();
    brandName.dispose();
    selectedBrandNameController.dispose();
    selectedCategoryNameController.dispose();
    salePrice.dispose();

    super.onClose();
  } // Save or update product

  // Function to insert new product
  Future<void> insertProduct() async {
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

      final json = productModel.toJson(isUpdate: true);
      final productId = await productRepository.insertProductInTable(json);

      // Assign the product ID to the model
      productModel.productId = productId;

      // Save the image
      await mediaController.imageAssigner(
          productId, MediaCategory.products.toString().split('.').last, true);

      // Add to local list
      allProducts.add(productModel);

      // Check for low stock
      await checkLowStock([productId]);

      // Show success message
      TLoader.successSnackBar(
        title: "Success",
        message: 'Product added successfully!',
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
        stockQuantity: int.tryParse(stock.text.trim()) ?? 0,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
      );

      final json = productModel.toJson(isUpdate: false);
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

      // Check for low stock
      await checkLowStock([productId.value]);

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
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cleanProductDetail() {
    try {
      productName.clear();
      productDescription.clear();
      basePrice.clear();
      salePrice.clear();
      stock.clear();
      alertStock.clear();
      brandName.clear();
      salePrice.clear();
      selectedBrandId = -1;
      selectedCategoryId = -1;
      selectedCategoryNameController.clear();
      selectedBrandNameController.clear();
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

  int? findProductIdByName(String productName) {
    try {
      return allProducts
          .firstWhere((product) => product.name == productName)
          .productId;
    } catch (e) {
      return null; // Return null if the product is not found
    }
  }

// Method to update stock quantity
  Future<void> updateStockQuantities(List<OrderItemModel>? orderItems) async {
    if (orderItems == null || orderItems.isEmpty) return;

    for (var item in orderItems) {
      await productRepository.updateStockQuantity(
        productId: item.productId,
        quantitySold: item.quantity,
      );
    }
  }

  Future<void> checkLowStock(List<int> productIds) async {
    try {
      await productRepository.checkLowStock(productIds);
    } catch (e) {
      TLoader.errorSnackBar(title: 'Low Stock Error', message: e.toString());
    }
  }

  void onProductTap(ProductModel product) async {
    setProductDetail(product);

    Get.toNamed(TRoutes.productsDetail, arguments: product);
  }
}
