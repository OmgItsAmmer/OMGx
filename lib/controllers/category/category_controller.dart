import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/repositories/category/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();
  final CategoryRepository categoryRepository = Get.put(CategoryRepository());
  final MediaController mediaController = Get.find<MediaController>();

// List of brands (observable)
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  // RxList<String> categoriesNames = <String>[].obs;

  // Currently selected brand (observable)
  var selectedCategory = ''.obs;

  // Controller for the text field to add a new brand //Product Detail

  final TextEditingController categoryName = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  GlobalKey<FormState> categoryDetail = GlobalKey<FormState>();

  RxBool isUpdating = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // Future<void> saveOrUpdate(int categoryId) async {
  //   final MediaController mediaController = Get.find<MediaController>();
  //
  //
  //   try {
  //     // Validate the form
  //     if (!categoryDetail.currentState!.validate()) {
  //       TLoader.errorSnackBar(
  //         title: "Empty Fields",
  //         message: 'Kindly fill all the fields before proceeding.',
  //       );
  //       return;
  //     }
  //
  //     final categoryModel = CategoryModel(
  //       categoryId: categoryId,
  //       categoryName: categoryName.text.trim(),
  //     );
  //
  //     final json = categoryModel.toJson();
  //     await mediaController.imageAssigner(
  //       categoryId,
  //       MediaCategory.categories.toString().split('.').last,
  //       true,
  //     );
  //
  //     await categoryRepository.saveOrUpdateCategoryRepo(json); // 👈 Make sure it's awaited
  //
  //     // 🔁 Update or Add locally
  //     final index = allCategories.indexWhere((c) => c.categoryId == categoryId);
  //     if (index != -1) {
  //       allCategories[index] = categoryModel; // Update
  //     } else {
  //       allCategories.add(categoryModel); // Add
  //     }
  //
  //     cleanCategoryDetail();
  //     TLoader.successSnackBar(title: 'Category Uploaded!');
  //   } catch (e) {
  //     TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  Future<void> insertCategory() async {
    final MediaController mediaController = Get.find<MediaController>();

    try {
      isUpdating.value = true;
      if (!categoryDetail.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      final categoryModel = CategoryModel(
        categoryId: null,
        categoryName: categoryName.text.trim(),
      );

      final json = categoryModel.toJson(isUpdate: true);

      // Insert and get new category ID
      final categoryId = await categoryRepository.insertCategoryInTable(json);

      await mediaController.imageAssigner(
        categoryId,
        MediaCategory.categories.toString().split('.').last,
        true,
      );

      categoryModel.categoryId = categoryId;
      allCategories.add(categoryModel);

      cleanCategoryDetail();
      TLoader.successSnackBar(
        title: 'Category Added!',
        message: '${categoryName.text} successfully added.',
      );
    } catch (e) {
      TLoader.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> updateCategory(int categoryId) async {
    final MediaController mediaController = Get.find<MediaController>();

    try {
      isUpdating.value = true;

      // Validate the form before proceeding
      if (!categoryDetail.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Prepare the updated category model
      final categoryModel = CategoryModel(
        categoryId: categoryId,
        categoryName: categoryName.text.trim(),
      );

      final json = categoryModel.toJson();

      // Update the category in the repository
      await categoryRepository.updateCategory(json);

      // Assign an image to the category
      await mediaController.imageAssigner(
        categoryId,
        MediaCategory.categories.toString().split('.').last,
        true,
      );

      // Find the index of the category in the list
      final index = allCategories.indexWhere((c) => c.categoryId == categoryId);

      // If the category exists in the list, update it; otherwise, add the new one
      if (index != -1) {
        allCategories[index] = categoryModel; // Update existing category
      } else {
        allCategories.add(categoryModel); // Add new category if not found
      }

      cleanCategoryDetail();

      // Show success message
      TLoader.successSnackBar(
        title: 'Category Updated!',
        message: '${categoryName.text} updated successfully.',
      );
    } catch (e) {
      TLoader.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void setCategoryDetail(CategoryModel category) {
    try {
      categoryName.text = category.categoryName;
      //  productCount.text = category.image.toString(); //Image
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cleanCategoryDetail() {
    try {
      categoryName.clear();
      productCount.clear();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await categoryRepository.fetchCategories();
      allCategories.assignAll(categories);
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

  Future<void> deleteCategory(int categoryId) async {
    try {
      // Call the repository function to delete from the database
      await categoryRepository.deleteCategoryFromTable(categoryId);

      // Find the category in allCategories to get the name
      final categoryToRemove = allCategories.firstWhere(
        (category) => category.categoryId == categoryId,
        orElse: () => CategoryModel.empty(), // Default to avoid error
      );

      if (categoryToRemove.categoryId == -1) {
        throw Exception("Category not found in the list");
      }

      // Remove category from lists
      allCategories
          .removeWhere((category) => category.categoryId == categoryId);
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting category: $e");
        TLoader.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }
}
