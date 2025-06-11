import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import '../../../main.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  //fetch
  Future<List<AddressModel>> fetchAddressTableForSpecificUser(
      int customerId) async {
    try {
      final data =
          await supabase.from('addresses').select().eq('user_id', customerId);

      final addressList = data.map((item) {
        return AddressModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(addressList[1].country);
      }
      return addressList;
    } catch (e) {
      TLoaders.warningSnackBar(title: "Fetch Address", message: e.toString());
      return [];
    }
  }

  //fetch
  Future<List<AddressModel>> fetchAddressTableForSpecificEntity(
      int entityId, String entityName) async {
    try {
      final String columnName;

      // Determine the column name based on the entityName
      switch (entityName) {
        case 'Customer':
          columnName = 'customer_id';
          break;
        case 'User':
          columnName = 'user_id';
          break;
        case 'Salesman':
          columnName = 'salesmanId';
          break;
        default:
          throw Exception('Invalid entity name: $entityName');
      }

      // Fetch data from the 'addresses' table using the appropriate column name
      final data = await supabase
          .from('addresses')
          .select()
          .eq(columnName, entityId); // Filter by the appropriate column

      // Convert the fetched data into a list of AddressModel objects
      final addressList = data.map((item) {
        return AddressModel.fromJson(item);
      }).toList();

      return addressList;
    } catch (e) {
      TLoaders.warningSnackBar(title: "Fetch Address", message: e.toString());
      return [];
    }
  }

  Future<List<AddressModel>> fetchAddressTableForSpecificSalesman(
      int salesmanId) async {
    try {
      final data = await supabase
          .from('addresses')
          .select()
          .eq('salesman_id', salesmanId);

      final addressList = data.map((item) {
        return AddressModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(addressList[1].country);
      }
      return addressList;
    } catch (e) {
      TLoaders.warningSnackBar(title: "Fetch Address", message: e.toString());
      return [];
    }
  }

//update

  Future<void> updateAddressTable(Map<String, dynamic> singleAddressMap) async {
    try {
      await supabase.from('addresses').insert(singleAddressMap);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.warningSnackBar(title: "Address Repo", message: e.toString());
        print(e);
      }
    }
  }
}
