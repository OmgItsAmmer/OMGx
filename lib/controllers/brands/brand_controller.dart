import 'package:ecommerce_dashboard/Models/brand/brand_model.dart';
import 'package:ecommerce_dashboard/repositories/brand/brand_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();
  final BrandRepository brandRepository = Get.put(BrandRepository());
  final MediaController mediaController = Get.find<MediaController>();

// List of brands (observable)
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  // RxList<String> brandNames = <String>[].obs;

  // Currently selected brand (observable)
  Rx<BrandModel> selectedBrand = BrandModel.empty().obs;

  // Controller for the text field to add a new brand

  RxBool isUpdating = false.obs;
  RxBool isLoading = false.obs;

  //Brand Details
  final TextEditingController brandName = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  GlobalKey<FormState> brandDetail = GlobalKey<FormState>();

  @override
  void onInit() {
    fetchBrands();
    super.onInit();
  }

  // Method to discard changes and navigate back
  void discardChanges() {
    // Clear form fields
    cleanBrandDetail();

    // Navigate back to previous screen
    if (Get.context != null) {
      Navigator.of(Get.context!).pop();
    } else {
      Get.back(); // Fallback if context is null
    }

    // Show snackbar to confirm action
  }

  // Method to check if a brand name already exists
  bool _brandNameExists(String name, {int? excludeBrandId}) {
    final trimmedName = name.trim().toLowerCase();

    return allBrands.any((brand) {
      // Skip the current brand when updating
      if (excludeBrandId != null && brand.brandID == excludeBrandId) {
        return false;
      }

      // Compare names case insensitive after trimming
      final existingName = brand.brandname?.trim().toLowerCase() ?? '';
      return existingName == trimmedName;
    });
  }

  Future<void> insertBrand() async {
    try {
      isUpdating.value = true;

      // Validate form first
      if (!brandDetail.currentState!.validate()) {
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Check for duplicate brand name
      final brandNameText = brandName.text.trim();
      if (_brandNameExists(brandNameText)) {
        TLoaders.errorSnackBar(
          title: "Duplicate Brand",
          message: 'A brand with the name "$brandNameText" already exists.',
        );
        return;
      }

      // Build the brand model
      final brandModel = BrandModel(
        brandID: -1,
        brandname: brandNameText,
        productCount: 0, // Initialize with zero products
        // Add other fields if your BrandModel has more
      );

      final json = brandModel.toJson(isUpdate: true);

      // Insert brand and get ID
      final brandId = await brandRepository.insertBrandInTable(json);

      // Optional: Assign media to this brand
      await mediaController.imageAssigner(
          brandId, MediaCategory.brands.toString().split('.').last, true);

      // Add to local list with the ID assigned
      brandModel.brandID = brandId;
      allBrands.add(brandModel);

      // Force UI update
      update();

      // Clear input fields
      cleanBrandDetail();

      TLoaders.successSnackBar(
        title: 'Brand Added!',
        message: '${brandName.text} added to Database',
      );
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> updateBrand(int brandId) async {
    try {
      isUpdating.value = true;

      // Validate form
      if (!brandDetail.currentState!.validate()) {
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Check for duplicate brand name (excluding the current brand being edited)
      final brandNameText = brandName.text.trim();
      if (_brandNameExists(brandNameText, excludeBrandId: brandId)) {
        TLoaders.errorSnackBar(
          title: "Duplicate Brand",
          message: 'A brand with the name "$brandNameText" already exists.',
        );
        return;
      }

      // Find existing brand to preserve counts
      final existingBrand = allBrands.firstWhere(
        (brand) => brand.brandID == brandId,
        orElse: () => BrandModel.empty(),
      );

      final existingProductCount = existingBrand.productCount ?? 0;

      // Create brand model with preserved counts
      final brandModel = BrandModel(
        brandID: brandId,
        brandname: brandNameText,
        productCount: existingProductCount,
        isVerified: existingBrand.isVerified,
        isFeatured: existingBrand.isFeatured,
      );

      final json = brandModel.toJson(isUpdate: false); // keep ID for update

      // Call repo function to update
      await brandRepository.updateBrand(json);

      // Assign media if needed
      await mediaController.imageAssigner(
        brandId,
        MediaCategory.brands.toString().split('.').last,
        true,
      );

      // Update locally
      final index = allBrands.indexWhere((b) => b.brandID == brandId);
      if (index != -1) {
        allBrands[index] = brandModel;
      } else {
        allBrands.add(brandModel);
      }

      // Force UI update
      update();

      // Clear form
      cleanBrandDetail();

      TLoaders.successSnackBar(
        title: 'Brand Updated!',
        message: '${brandNameText} updated in Database',
      );
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteBrand(int brandId) async {
    try {
      // Find the brand in allBrands to get the name
      final brandToRemove = allBrands.firstWhere(
        (brand) => brand.brandID == brandId,
        orElse: () => BrandModel.empty(), // Default to avoid error
      );

      if (brandToRemove.brandID == -1) {
        throw Exception("Brand not found in the list");
      }

      // Store name for success message
      final brandName = brandToRemove.brandname;

      // Call the repository function to delete from the database
      await brandRepository.deleteBrandFromTable(brandId);

      // Remove brand from local list
      allBrands.removeWhere((brand) => brand.brandID == brandId);

      // Force UI update
      update();

      // Show success message
      TLoaders.successSnackBar(
          title: "Success",
          message: "${brandName ?? 'Brand'} deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting brand: $e");
        TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }

  void setBrandDetail(BrandModel brand) {
    try {
      selectedBrand.value = brand;
      brandName.text = brand.brandname ?? ' ';
      productCount.text = brand.productCount.toString();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cleanBrandDetail() {
    try {
      brandName.text = '';
      productCount.text = '';
      selectedBrand.value = BrandModel.empty();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> fetchBrands() async {
    try {
      final brands = await brandRepository.fetchBrands();
      allBrands.assignAll(brands);

      // Force UI update
      update();

      //Brand names
      final names = allBrands
          .map((brand) =>
              brand.brandname ?? '') // Replace null with empty string
          .toList();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<int> fetchBrandId(String brandName) async {
    try {
      //find it locally first
      int brandId = allBrands.firstWhere(
        (brand) => brand.brandname == brandName,
        orElse: () => BrandModel.empty(),
      ).brandID;
      if (brandId != -1) {
        return brandId;
      }
      //if not found, fetch it from the database
      brandId = await brandRepository.getBrandId(brandName);
      return brandId;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());

      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  // Methods to update product count for brands
  void incrementProductCount(int brandId) async {
    try {
      // Find the brand in our list
      final index = allBrands.indexWhere((brand) => brand.brandID == brandId);
      if (index != -1) {
        // Update the local model
        final brand = allBrands[index];
        final currentCount = brand.productCount ?? 0;
        final newCount = currentCount + 1;

        // Create a new brand model with updated count
        final updatedBrand = BrandModel(
          brandID: brand.brandID,
          brandname: brand.brandname,
          isVerified: brand.isVerified,
          isFeatured: brand.isFeatured,
          productCount: newCount,
        );

        // Update in local list
        allBrands[index] = updatedBrand;

        // Update the database
        await brandRepository.updateBrandProductCount(brandId, newCount);

        // Force UI update to reflect changes immediately
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error incrementing brand product count: $e");
      }
    }
  }

  void decrementProductCount(int brandId) async {
    try {
      // Find the brand in our list
      final index = allBrands.indexWhere((brand) => brand.brandID == brandId);
      if (index != -1) {
        // Update the local model
        final brand = allBrands[index];
        final currentCount = brand.productCount ?? 0;
        if (currentCount <= 0) return; // Prevent negative counts

        final newCount = currentCount - 1;

        // Create a new brand model with updated count
        final updatedBrand = BrandModel(
          brandID: brand.brandID,
          brandname: brand.brandname,
          isVerified: brand.isVerified,
          isFeatured: brand.isFeatured,
          productCount: newCount,
        );

        // Update in local list
        allBrands[index] = updatedBrand;

        // Update the database
        await brandRepository.updateBrandProductCount(brandId, newCount);

        // Force UI update to reflect changes immediately
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error decrementing brand product count: $e");
      }
    }
  }

  // Method to refresh brands data from database
  Future<void> refreshBrands() async {
    try {
      isLoading.value = true;
      await fetchBrands();
      TLoaders.successSnackBar(
        title: 'Refreshed!',
        message: 'Brand list has been updated.',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing brands: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to refresh brands: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
