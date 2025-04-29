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

  // Method to check if a category name already exists
  bool _categoryNameExists(String name, {int? excludeCategoryId}) {
    final trimmedName = name.trim().toLowerCase();

    return allCategories.any((category) {
      // Skip the current category when updating
      if (excludeCategoryId != null &&
          category.categoryId == excludeCategoryId) {
        return false;
      }

      // Compare names case insensitive after trimming
      final existingName = category.categoryName.trim().toLowerCase();
      return existingName == trimmedName;
    });
  }

  // Methods to update product count for categories
  void incrementProductCount(int categoryId) async {
    try {
      // Find the category in our list
      final index = allCategories
          .indexWhere((category) => category.categoryId == categoryId);
      if (index != -1) {
        // Update the local model
        final category = allCategories[index];
        final currentCount = category.productCount ?? 0;
        final newCount = currentCount + 1;

        // Create a new category model with updated count
        final updatedCategory = CategoryModel(
          categoryId: category.categoryId,
          categoryName: category.categoryName,
          isFeatured: category.isFeatured,
          productCount: newCount,
        );

        // Update in local list
        allCategories[index] = updatedCategory;

        // Update the database
        await categoryRepository.updateCategoryProductCount(
            categoryId, newCount);

        // Force UI update to reflect changes immediately
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error incrementing category product count: $e");
      }
    }
  }

  void decrementProductCount(int categoryId) async {
    try {
      // Find the category in our list
      final index = allCategories
          .indexWhere((category) => category.categoryId == categoryId);
      if (index != -1) {
        // Update the local model
        final category = allCategories[index];
        final currentCount = category.productCount ?? 0;
        if (currentCount <= 0) return; // Prevent negative counts

        final newCount = currentCount - 1;

        // Create a new category model with updated count
        final updatedCategory = CategoryModel(
          categoryId: category.categoryId,
          categoryName: category.categoryName,
          isFeatured: category.isFeatured,
          productCount: newCount,
        );

        // Update in local list
        allCategories[index] = updatedCategory;

        // Update the database
        await categoryRepository.updateCategoryProductCount(
            categoryId, newCount);

        // Force UI update to reflect changes immediately
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error decrementing category product count: $e");
      }
    }
  }

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

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

      // Check for duplicate category name
      final categoryNameText = categoryName.text.trim();
      if (_categoryNameExists(categoryNameText)) {
        TLoader.errorSnackBar(
          title: "Duplicate Category",
          message:
              'A category with the name "$categoryNameText" already exists.',
        );
        return;
      }

      final categoryModel = CategoryModel(
        categoryId: null,
        categoryName: categoryNameText,
        productCount: 0, // Initialize with zero products
      );

      final json = categoryModel.toJson(isUpdate: true);

      // Insert and get new category ID
      final categoryId = await categoryRepository.insertCategoryInTable(json);

      await mediaController.imageAssigner(
        categoryId,
        MediaCategory.categories.toString().split('.').last,
        true,
      );

      // Set the ID in the model and add to local list
      categoryModel.categoryId = categoryId;
      allCategories.add(categoryModel);

      // Force UI update
      update();

      cleanCategoryDetail();
      TLoader.successSnackBar(
        title: 'Category Added!',
        message: '$categoryNameText successfully added.',
      );
      Navigator.of(Get.context!).pop();
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

      // Check for duplicate category name (excluding the current category being edited)
      final categoryNameText = categoryName.text.trim();
      if (_categoryNameExists(categoryNameText,
          excludeCategoryId: categoryId)) {
        TLoader.errorSnackBar(
          title: "Duplicate Category",
          message:
              'A category with the name "$categoryNameText" already exists.',
        );
        return;
      }

      // Find existing category to preserve product counts
      final existingCategory = allCategories.firstWhere(
        (category) => category.categoryId == categoryId,
        orElse: () => CategoryModel.empty(),
      );

      final existingProductCount = existingCategory.productCount ?? 0;

      // Prepare the updated category model
      final categoryModel = CategoryModel(
        categoryId: categoryId,
        categoryName: categoryNameText,
        productCount: existingProductCount,
        isFeatured: existingCategory.isFeatured,
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

      // Force UI update
      update();

      cleanCategoryDetail();

      // Show success message
      TLoader.successSnackBar(
        title: 'Category Updated!',
        message: '$categoryNameText updated successfully.',
      );
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void setCategoryDetail(CategoryModel category) {
    try {
      categoryName.text = category.categoryName;
      productCount.text =
          category.productCount?.toString() ?? '0'; // Show product count in UI
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

      // Force UI update
      update();
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
      // Find the category in allCategories to get the name
      final categoryToRemove = allCategories.firstWhere(
        (category) => category.categoryId == categoryId,
        orElse: () => CategoryModel.empty(), // Default to avoid error
      );

      if (categoryToRemove.categoryId == -1) {
        throw Exception("Category not found in the list");
      }

      // Store category name for success message
      final catName = categoryToRemove.categoryName;

      // Call the repository function to delete from the database
      await categoryRepository.deleteCategoryFromTable(categoryId);

      // Remove category from local list
      allCategories
          .removeWhere((category) => category.categoryId == categoryId);

      // Force UI update
      update();

      // Show success message
      TLoader.successSnackBar(
          title: "Success", message: "$catName deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting category: $e");
        TLoader.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }
}
