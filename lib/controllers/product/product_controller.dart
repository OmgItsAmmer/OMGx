import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());

//List of product Model
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  //List of names for searchbar
  RxList<String> productNames = <String>[].obs;

//Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  //Variables
  Rx<String> selectedProduct = ''.obs;

  //Product Detail Controllers
  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final unitPrice = TextEditingController();
  final stock = TextEditingController();
  final alertStock = TextEditingController();
  final brandName = TextEditingController();
  final TextEditingController selectedBrandNameController = TextEditingController();
  final TextEditingController selectedCategoryNameController = TextEditingController();

  int selectedBrandId = -1;
  int selectedCategoryId = -1;
  GlobalKey<FormState> productDetail =
      GlobalKey<FormState>(); // Form key for form validation

  @override
  void onInit() {
    fetchProducts();

    super.onInit();
  }

  // Save or update product
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



      final productModel = ProductModel(
        productId: await productRepository.getProductId(productName.text),
        name: productName.text.trim(),
        description: productDescription.text.trim(),
        basePrice: unitPrice.text.trim(),
        stockQuantity: int.tryParse(stock.text.trim()) ?? 0,
        alertStock: int.tryParse(alertStock.text.trim()) ?? 0,
        brandID: selectedBrandId,
        categoryId: selectedCategoryId,

      );
      final json = productModel.toJson();



      // Call the repository function to save or update the product
      await productRepository.saveOrUpdateProductRepo(json);

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
      productName.text = product.name ?? ' ';
      productDescription.text = product.description ?? ' ';
      unitPrice.text = product.basePrice ?? ' ';
      stock.text = product.stockQuantity.toString();
      alertStock.text = product.alertStock.toString() ?? '';



    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cleanProductDetail() {
    try {
      productName.clear();
      productDescription.clear();
      unitPrice.clear();
      stock.clear();
      alertStock.clear();
      brandName.clear();
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
}
