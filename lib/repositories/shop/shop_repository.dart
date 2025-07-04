import 'package:ecommerce_dashboard/Models/shop/shop_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class ShopRepository extends GetxController {
  static ShopRepository get instance => Get.find();

  Future<ShopModel> fetchShopDetails() async {
    try {
      final data = await supabase.from('shop').select();
      if (kDebugMode) {
        print(data);
      }

      final shopList = data.map((item) {
        return ShopModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(shopList.first.shopname);
      }
      return shopList.first;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
        print(e);
      }
      return ShopModel.empty();
    }
  }

  Future<void> updateShopData(Map<String, dynamic> json, int shopId) async {
    try {
      await supabase.from('shop').update(json).eq('shop_id', shopId);
      TLoaders.successSnackBar(
        title: 'Shop Updated',
        message: 'Your shop details have been updated successfully',
      );
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
