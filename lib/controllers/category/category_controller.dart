import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/repositories/brand/brand_repository.dart';
import 'package:admin_dashboard_v3/repositories/category/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();
  final CategoryRepository categoryRepository = Get.put(CategoryRepository());

// List of brands (observable)
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<String> categoriesNames = <String>[].obs;

  // Currently selected brand (observable)
  var selectedCategory = ''.obs;

  // Controller for the text field to add a new brand //Product Detail

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // Add a new brand
  // void addBrand(String newBrand) {
  //   if (newBrand.trim().isNotEmpty && !brands.contains(newBrand.trim())) {
  //     brands.add(newBrand.trim()); // Add the new brand
  //     selectedBrand.value = newBrand.trim(); // Select the new brand
  //   }
  // }


  Future<void> fetchCategories() async {
    try {
      final categories = await categoryRepository.fetchCategories();
      allCategories.assignAll(categories);

      //Brand names
      final names = allCategories
          .map((brand) => brand.categoryName ?? '') // Replace null with empty string
          .toList();

      categoriesNames.assignAll(names);


    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<int> fetchCategoryId(String categoryName) async {
    try {
      print(categoryName);
      final categoryidId = await categoryRepository.getCategoryId(categoryName);
      return categoryidId;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());

      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }
}
