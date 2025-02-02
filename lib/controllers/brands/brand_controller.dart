import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/repositories/brand/brand_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();
  final BrandRepository brandRepository = Get.put(BrandRepository());

// List of brands (observable)
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  RxList<String> brandNames = <String>[].obs;

  // Currently selected brand (observable)
  var selectedBrand = ''.obs;

  // Controller for the text field to add a new brand



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

  Future<void> saveOrUpdate(int? brandId) async {
    try{
      // Validate the form
      if (!brandDetail.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      final brandModel = BrandModel(
        brandID: brandId ?? -1,
        bname: brandName.text.trim(),


      );
      final json = brandModel.toJson();
      brandRepository.saveOrUpdateBrandRepo(json);
      cleanBrandDetail();
      TLoader.successSnackBar(title: 'Brand Uploaded!');

    }
    catch(e){

      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }

  }

  void setBrandDetail(BrandModel brand) {
    try {
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

      brandNames.assignAll(names);


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
