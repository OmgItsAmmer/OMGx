import 'package:admin_dashboard_v3/Models/shop/shop_model.dart';
import 'package:admin_dashboard_v3/repositories/shop/shop_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../media/media_controller.dart';
import '../product/product_images_controller.dart';

class ShopController extends GetxController {
  static ShopController get instance => Get.find();
  final ShopRepository shopRepository = Get.put(ShopRepository());
  final MediaController mediaController = Get.find<MediaController>();
  final ProductImagesController productImagesController =
      Get.find<ProductImagesController>();

  Rx<ShopModel>? selectedShop = ShopModel.empty().obs;

  final shopName = TextEditingController().obs;
  final taxRate = TextEditingController();
  final shippingFee = TextEditingController();
  final shippingThreshold = TextEditingController();
  final profile1 = TextEditingController();
  final profile2 = TextEditingController();
  final profile3 = TextEditingController();

  RxBool isUpdating = false.obs;

  // @override
  // void onInit() {
  //   fetchShop();
  //
  //   super.onInit();
  // }

  Future<void> fetchShop({bool fetchImage = true}) async {
    try {
      final shopData = await shopRepository.fetchShopDetails();
      selectedShop?.value = shopData;
      setShopDetail();


      if (fetchImage == true) {
        productImagesController.setDesiredImage(
            MediaCategory.shop, shopData.shopId);
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void setShopDetail() {
    try {
      shopName.value.text = selectedShop?.value.shopname ?? ' ';
      taxRate.text = selectedShop?.value.taxrate.toString() ?? ' ';
      shippingFee.text = selectedShop?.value.shippingPrice.toString() ?? ' ';
      shippingThreshold.text =
          selectedShop?.value.thresholdFreeShipping.toString() ?? ' ';
      profile1.text = selectedShop?.value.profile1.toString() ?? ' ';
      profile2.text = selectedShop?.value.profile2.toString() ?? ' ';
      profile3.text = selectedShop?.value.profile3.toString() ?? ' ';
    //  productImagesController.setDesiredImage(MediaCategory.shop);





    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> updateStore() async {
    try {
      isUpdating.value = true;
      final shopModel = ShopModel(
        shopId: selectedShop?.value.shopId ?? -1,
        shopname: shopName.value.text,
        shippingPrice: double.tryParse(shippingFee.text) ?? 0.0, // Convert String to double
        taxrate: double.tryParse(taxRate.text) ?? 0.0, // Convert String to double
        thresholdFreeShipping: double.tryParse(shippingThreshold.text) ?? 0.0, // Convert String to double
        profile1: double.tryParse(profile1.text) ?? 0.0, // Convert String to double
        profile2: double.tryParse(profile2.text) ?? 0.0, // Convert String to double
        profile3: double.tryParse(profile3.text) ?? 0.0, // Convert String to double
      );

      final json = shopModel.toJson();


      await mediaController.updateEntityId(selectedShop?.value.shopId ?? -1, productImagesController.selectedImage.value!.image_id,MediaCategory.shop.toString().split('.').last);

      await shopRepository.updateShopData(json, selectedShop?.value.shopId ?? -1);


    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString());
        print(e);
      }
    }
    finally {
      isUpdating.value = false;

    }
  }

}
