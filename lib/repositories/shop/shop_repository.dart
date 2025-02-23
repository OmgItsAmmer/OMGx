

import 'package:admin_dashboard_v3/Models/shop/shop_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../main.dart';

import '../../Models/salesman/salesman_model.dart';

class ShopRepository extends GetxController {
  static ShopRepository get instance => Get.find();



  Future<List<ShopModel>> fetchShopDetails() async {
    try {
      final data =  await supabase.from('shop').select();
      print(data);

      final shopList = data.map((item) {
        return ShopModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(shopList[0].shopname);
      }
      return shopList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
      print(e);
      return [];
    }

  }





}