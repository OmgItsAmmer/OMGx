

import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../main.dart';

import '../../Models/salesman/salesman_model.dart';

class SalesmanRepository extends GetxController {
  static SalesmanRepository get instance => Get.find();



  Future<List<SalesmanModel>> fetchAllSalesman() async {
    try {
      final data =  await supabase.from('salesman').select();
      //print(data);

      final salesmanList = data.map((item) {
        return SalesmanModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(salesmanList[1].fullName);
      }
      return salesmanList;
    } catch (e) {
      TLoader.errorsnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }

  }





}