

import 'package:admin_dashboard_v3/repositories/customer/customer_repository.dart';
import 'package:admin_dashboard_v3/repositories/salesman/salesman_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


import '../../Models/customer/customer_model.dart';
import '../../Models/salesman/salesman_model.dart';
import '../../common/widgets/loaders/tloaders.dart';

class SalesmanController extends GetxController {
  static SalesmanController get instance => Get.find();
  final  SalesmanRepository salesmanRepository = Get.put(SalesmanRepository());




  final profileLoading = false.obs;

  RxList<SalesmanModel> allSalesman = <SalesmanModel>[].obs;
  RxList<String> allSalesmanNames = <String>[].obs;

  Rx<SalesmanModel>? selectedSalesman;








  @override
  void onInit() {
    super.onInit();

    fetchallSalesman();
  }



  Future<void> fetchallSalesman() async {
    try {

      final salesman = await salesmanRepository.fetchAllSalesman();
      allSalesman.assignAll(salesman);

      //filter names
      final names = allSalesman.map((user) => user.fullName).toList();
      allSalesmanNames.assignAll(names);

      if (kDebugMode) {
        print(allSalesmanNames);
      }


    } catch (e) {
      TLoader.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }



}


