import 'package:admin_dashboard_v3/Models/shop/shop_model.dart';
import 'package:admin_dashboard_v3/repositories/shop/shop_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
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

  final shopName = TextEditingController();
  final taxRate = TextEditingController();
  final shippingFee = TextEditingController();
  final shippingThreshold = TextEditingController();
  final profile1 = TextEditingController();
  final profile2 = TextEditingController();
  final profile3 = TextEditingController();

  // @override
  // void onInit() {
  //   fetchShop();
  //
  //   super.onInit();
  // }

  Future<void> fetchShop({bool fetchImage = true}) async {
    try {
      final shopData = await shopRepository.fetchShopDetails();
      selectedShop?.value = shopData[0];
      shopName.text = selectedShop?.value.shopname ?? ' ';
      taxRate.text = selectedShop?.value.taxrate.toString() ?? ' ';
      shippingFee.text = selectedShop?.value.shippingPrice.toString() ?? ' ';
      shippingThreshold.text =
          selectedShop?.value.thresholdFreeShipping.toString() ?? ' ';
      profile1.text = selectedShop?.value.profile1.toString() ?? ' ';
      profile2.text = selectedShop?.value.profile2.toString() ?? ' ';
      profile3.text = selectedShop?.value.profile3.toString() ?? ' ';
      // productImagesController.setDesiredImage(MediaCategory.shop);

      if (fetchImage == true) {
        productImagesController.setDesiredImage(
            MediaCategory.shop, shopData[0].shopId);
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
