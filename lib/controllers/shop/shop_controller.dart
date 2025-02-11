
import 'package:admin_dashboard_v3/Models/shop/shop_model.dart';
import 'package:admin_dashboard_v3/repositories/shop/shop_repository.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';


class ShopController extends GetxController {
  static ShopController get instance => Get.find();
  final ShopRepository shopRepository = Get.put(ShopRepository());

  Rx<ShopModel>? selectedShop = ShopModel.empty().obs;
  @override
  void onInit() {
    fetchShop();

    super.onInit();
  }

  Future<void> fetchShop() async {
    try{
      final shopData = await shopRepository.fetchShopDetails();
      selectedShop?.value = shopData[0];


    }
    catch(e)
    {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());

    }

  }
}
