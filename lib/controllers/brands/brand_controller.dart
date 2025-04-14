import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/repositories/brand/brand_repository.dart';
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



  //Brand Details
  final TextEditingController brandName = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  GlobalKey<FormState> brandDetail =
  GlobalKey<FormState>();


  @override
  void onInit() {
    fetchBrands();
    super.onInit();
  }

  // Future<void> saveOrUpdate(int brandId) async {
  //   try {
  //     final MediaController mediaController = Get.find<MediaController>();
  //
  //
  //     // Validate the form
  //     if (!brandDetail.currentState!.validate()) {
  //       TLoader.errorSnackBar(
  //         title: "Empty Fields",
  //         message: 'Kindly fill all the fields before proceeding.',
  //       );
  //       return;
  //     }
  //
  //     final brandModel = BrandModel(
  //       brandID: brandId,
  //       bname: brandName.text.trim(),
  //     );
  //
  //     await mediaController.imageAssigner(
  //         brandId, MediaCategory.brands.toString().split('.').last, true);
  //
  //     final json = brandModel.toJson();
  //     await brandRepository.saveOrUpdateBrandRepo(json); // 🔁 Make sure this is awaited
  //
  //     // 👇 Update or add in the local list
  //     final index = allBrands.indexWhere((b) => b.brandID == brandId);
  //     if (index != -1) {
  //      allBrands[index] = brandModel; // Update existing
  //     } else {
  //       allBrands.add(brandModel); // Add new
  //     }
  //
  //     cleanBrandDetail();
  //     TLoader.successSnackBar(title: 'Brand Uploaded!');
  //   } catch (e) {
  //     if (kDebugMode) {
  //       TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //       print(e);
  //     }
  //   }
  // }
  Future<void> insertBrand() async {
    try {
      isUpdating.value = true;

      // Validate form first
      if (!brandDetail.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Build the brand model
      final brandModel = BrandModel(
        brandID: null,
        bname: brandName.text,

        // Add other fields if your BrandModel has more
      );

      final json = brandModel.toJson(isUpdate: true);

      // Insert brand and get ID
      final brandId = await brandRepository.insertBrandInTable(json);

      // Optional: Assign media to this brand
      await mediaController.imageAssigner(
          brandId, MediaCategory.brands.toString().split('.').last, true);

      // Optionally add address logic if brands also have it (not usually needed)
      // await AddressController.instance.saveAddress(brandId, 'Brand');

      // Add to local list
      brandModel.brandID = brandId;
      allBrands.add(brandModel);

      // Clear input fields
      cleanBrandDetail();

      TLoader.successSnackBar(
        title: 'Brand Added!',
        message: '${brandName.text} added to Database',
      );
    } catch (e) {
      TLoader.errorSnackBar(
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
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Create brand model
      final brandModel = BrandModel(
        brandID: brandId,
        bname: brandName.text,

        // Add other fields if any
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

      // Update locally if needed
      brandModel.brandID = brandId;

      // Clear form
      cleanBrandDetail();

      TLoader.successSnackBar(
        title: 'Brand Updated!',
        message: '${brandName.text} updated in Database',
      );
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }


  Future<void> deleteBrand(int brandId) async {
    try {
      // Call the repository function to delete from the database
      await brandRepository.deleteBrandFromTable(brandId);

      // Find the brand in allBrands to get the name
      final brandToRemove = allBrands.firstWhere(
            (brand) => brand.brandID == brandId,
        orElse: () => BrandModel.empty(), // Default to avoid error
      );

      if (brandToRemove.brandID == -1) {
        throw Exception("Brand not found in the list");
      }

      // Remove brand from lists
      allBrands.removeWhere((brand) => brand.brandID == brandId);

    } catch (e) {
      if (kDebugMode) {
        print("Error deleting brand: $e");
        TLoader.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }



  // Future<void> insertBrand() async {
  //   try {
  //     final MediaController mediaController = Get.find<MediaController>();
  //
  //
  //     // Validate the form
  //     if (!brandDetail.currentState!.validate()) {
  //       TLoader.errorSnackBar(
  //         title: "Empty Fields",
  //         message: 'Kindly fill all the fields before proceeding.',
  //       );
  //       return;
  //     }
  //
  //     final brandModel = BrandModel(
  //       brandID: null,
  //       bname: brandName.text.trim(),
  //     );
  //
  //     await mediaController.imageAssigner(
  //         , MediaCategory.brands.toString().split('.').last, true);
  //
  //     final json = brandModel.toJson(isUpdate: true);
  //     await brandRepository.saveOrUpdateBrandRepo(json); // 🔁 Make sure this is awaited
  //
  //     // 👇 Update or add in the local list
  //     final index = allBrands.indexWhere((b) => b.brandID == brandId);
  //     if (index != -1) {
  //       allBrands[index] = brandModel; // Update existing
  //     } else {
  //       allBrands.add(brandModel); // Add new
  //     }
  //
  //     cleanBrandDetail();
  //     TLoader.successSnackBar(title: 'Brand Uploaded!');
  //   } catch (e) {
  //     if (kDebugMode) {
  //       TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //       print(e);
  //     }
  //   }
  // }

  void setBrandDetail(BrandModel brand) {
    try {
      selectedBrand.value = brand;
      brandName.text = brand.bname ?? ' ';
      productCount.text = brand.productsCount.toString();




    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  void cleanBrandDetail() {
    try {
      brandName.text = '';
      productCount.text = '';
      selectedBrand.value = BrandModel.empty();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }



  Future<void> fetchBrands() async {
    try {
      final brands = await brandRepository.fetchBrands();
      allBrands.assignAll(brands);

  //Brand names
      final names = allBrands
          .map((brand) => brand.bname ?? '') // Replace null with empty string
          .toList();




    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<int> fetchBrandId(String brandName) async {
    try {
      final brandId = await brandRepository.getBrandId(brandName);
      return brandId;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());

      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }


// Add a new brand
// void addBrand(String newBrand) {
//   if (newBrand.trim().isNotEmpty && !brands.contains(newBrand.trim())) {
//     brands.add(newBrand.trim()); // Add the new brand
//     selectedBrand.value = newBrand.trim(); // Select the new brand
//   }
// }
}
