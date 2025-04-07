import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/repositories/brand/brand_repository.dart';
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

// List of brands (observable)
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<String> categoriesNames = <String>[].obs;

  // Currently selected brand (observable)
  var selectedCategory = ''.obs;

  // Controller for the text field to add a new brand //Product Detail


  final TextEditingController categoryName = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  GlobalKey<FormState> categoryDetail =
  GlobalKey<FormState>();

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }



  Future<void> saveOrUpdate(int categoryId) async {
    final MediaController mediaController = Get.find<MediaController>();

    try{
      // Validate the form
      if (!categoryDetail.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      final categoryModel = CategoryModel(
        categoryId: categoryId ,
        categoryName: categoryName.text.trim(),


      );
      final json = categoryModel.toJson();
      await mediaController.imageAssigner(categoryId, MediaCategory.categories.toString().split('.').last, true);
      categoryRepository.saveOrUpdateCategoryRepo(json);
      cleanCategoryDetail();


    }
    catch(e){

      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }

  }

  void setCategoryDetail(CategoryModel category) {
    try {
      categoryName.text = category.categoryName ;
    //  productCount.text = category.image.toString(); //Image

    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  void cleanCategoryDetail() {
    try {
      categoryName.text = '';
      productCount.text = '';
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  Future<void> fetchCategories() async {
    try {
      final categories = await categoryRepository.fetchCategories();
      allCategories.assignAll(categories);

      //Brand names
      final names = allCategories
          .map((category) => category.categoryName ?? '') // Replace null with empty string
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
