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
  RxList<String> productNames = <String>[].obs;

//Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  //Variables
  Rx<String> selectedProduct = ''.obs;

  //Product Detail Controllers
  RxInt productId = (-1).obs;
  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final basePrice = TextEditingController();
  final salePrice = TextEditingController();
  final stock = TextEditingController();
  final alertStock = TextEditingController();
  final brandName = TextEditingController();
  final TextEditingController selectedBrandNameController = TextEditingController();
  final TextEditingController selectedCategoryNameController = TextEditingController();

  int selectedBrandId = -1;
  int selectedCategoryId = -1;
  GlobalKey<FormState> productDetail =
  GlobalKey<FormState>();

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

  // Function to save or update product
  Future<void> saveOrUpdateProduct() async {
    try {
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

      // Fetch product ID (if it exists)
      int productId = await productRepository.getProductId(productName.text);

      final productModel = ProductModel(
        productId: productId,
        name: productName.text.trim(),
        description: productDescription.text.trim(),
        basePrice: basePrice.text.trim(),
        salePrice: salePrice.text.trim(),
        stockQuantity: int.tryParse(stock.text.trim()) ?? 0,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,
      );

      final json = productModel.toJson();

      // Save or update the product in the repository
      await mediaController.imageAssigner(productId, MediaCategory.products.toString().split('.').last, true);
      await productRepository.saveOrUpdateProductRepo(json);

      // Update stock in the allProducts list
      bool productFound = false;
      for (int i = 0; i < allProducts.length; i++) {
        if (allProducts[i].productId == productId) {
          // Update the stock and other relevant fields
          allProducts[i].stockQuantity = productModel.stockQuantity;
          allProducts[i].alertStock = productModel.alertStock;
          allProducts[i].basePrice = productModel.basePrice;
          allProducts[i].salePrice = productModel.salePrice;
          allProducts[i].name = productModel.name;
          allProducts[i].description = productModel.description;
          allProducts[i].brandID = productModel.brandID;
          allProducts[i].categoryId = productModel.categoryId;

          productFound = true;
          break;
        }
      }

      // If the product wasn't found in the list, add it
      if (!productFound) {
        allProducts.add(productModel);
      }

      // Check for low stock after update
      await checkLowStock([productId]);

      // Show success message
      TLoader.successSnackBar(
        title: "Success",
        message: 'Product saved/updated successfully!',
      );

      // Clear the form after saving/updating
      cleanProductDetail();
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }




  // // Clear the form fields
  // void clearForm() {
  //   productName.clear();
  //   productDescription.clear();
  //   unitPrice.clear();
  //   stock.clear();
  //   alertStock.clear();
  //   brandName.clear();
  //   selectedBrandId = -1;
  //   selectedCategoryId = -1;
  //   selectedCategoryNameController.clear();
  //   selectedBrandNameController.clear();
  // }


  void setProductDetail(ProductModel product) {
    try {
      final BrandController brandController = Get.find<BrandController>();
      final CategoryController categoryController = Get.find<CategoryController>();

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
          .bname ?? '';
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

      separateProductNames();
    } catch (e) {
      TLoader.errorSnackBar(title: 'ProductController', message: e.toString());
    }
  }

  void separateProductNames() {
    try {
      // Extract names

      // Ensure productNames is a list of strings
      final names = allProducts
          .map(
              (product) => product.name ?? '') // Replace null with empty string
          .toList();
      productNames.assignAll(names);
    } catch (e) {
      // Handle errors
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

  Future<void> checkLowStock(List<int> productIds)  async {
    try{
      await productRepository.checkLowStock(productIds);

    }
    catch(e)
    {
      TLoader.errorSnackBar(title: 'Low Stock Error',message: e.toString());
    }

  }

  void onProductTap(ProductModel product) async {


    setProductDetail(product);


    Get.toNamed(TRoutes.productsDetail, arguments: product);
  }

}