import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import '../../../main.dart';

class AddressRepository extends GetxController {

  static AddressRepository get instance => Get.find();




  //fetch
  Future<List<AddressModel>> fetchAddressTableForSpecificUser(int customerId) async {
    try {
      final data =  await supabase
          .from('addresses')
          .select().eq('user_id', customerId);

      final addressList = data.map((item) {
        return AddressModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(addressList[1].country);
      }
      return addressList;

    } catch (e) {
      TLoader.warningSnackBar(title: "Fetch Address", message: e.toString());
      return [];
    }
  }

  //fetch
  Future<List<AddressModel>> fetchAddressTableForSpecificCustomer(int customerId) async {
    try {
      final data =  await supabase
          .from('addresses')
          .select().eq('customer_id', customerId);

      final addressList = data.map((item) {
        return AddressModel.fromJson(item);
      }).toList();
      // if (kDebugMode) {
      //   print(addressList[1].country);
      // }
      return addressList;

    } catch (e) {
      TLoader.warningSnackBar(title: "Fetch Address", message: e.toString());
      return [];
    }
  }

  Future<List<AddressModel>> fetchAddressTableForSpecificSalesman(int salesmanId) async {
    try {
      final data =  await supabase
          .from('addresses')
          .select().eq('salesman_id', salesmanId);

      final addressList = data.map((item) {
        return AddressModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(addressList[1].country);
      }
      return addressList;

    } catch (e) {
      TLoader.warningSnackBar(title: "Fetch Address", message: e.toString());
      return [];
    }
  }



//update

  Future<void> updateAddressTable(Map<String,dynamic> singleAddressMap) async {
    try {
      await supabase
          .from('addresses')
          .insert(singleAddressMap);

    } catch (e) {
      TLoader.warningSnackBar(title: "Update Address", message: e.toString());

    }
  }


}