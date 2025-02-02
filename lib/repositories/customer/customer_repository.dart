import 'dart:io';


import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/customer/customer_model.dart';
import '../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authicatioon_repository.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();



  Future<List<CustomerModel>> fetchallCustomers() async {
    try {
      final data =  await supabase.from('customers').select();
      //print(data);

      final customerList = data.map((item) {
        return CustomerModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(customerList[1].fullName);
      }
      return customerList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }

  }


}