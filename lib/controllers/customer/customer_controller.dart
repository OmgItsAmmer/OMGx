

import 'package:admin_dashboard_v3/repositories/customer/customer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../Models/customer/customer_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../repositories/authentication/authicatioon_repository.dart';
import '../../repositories/user/user_repository.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../views/login/login.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  final CustomerRepository customerRepository = Get.put(CustomerRepository());




  final profileLoading = false.obs;

  RxList<CustomerModel> allCustomers = <CustomerModel>[].obs;
  RxList<String> allCustomerNames = <String>[].obs;

  Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;








  @override
  void onInit() {
    super.onInit();

    fetchallCustomers();
  }



  Future<void> fetchallCustomers() async {
    try {

      final customers = await customerRepository.fetchallCustomers();
      allCustomers.assignAll(customers);

      //filter names
      final names = allCustomers.map((user) => user.fullName).toList();
      allCustomerNames.assignAll(names);
      print(allCustomerNames);


    } catch (e) {
      TLoader.errorsnackBar(title: "Oh Snap!", message: e.toString());
    }
  }



}


