import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/vendor/vendor_model.dart';

class VendorRepository extends GetxController {
  static VendorRepository get instance => Get.find();

  Future<List<VendorModel>> fetchAllVendors() async {
    try {
      final data = await supabase.from('vendors').select();
      //print(data);

      final vendorList = data.map((item) {
        return VendorModel.fromJson(item);
      }).toList();

      return vendorList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  Future<void> updateVendor(Map<String, dynamic> json) async {
    try {
      int? vendorId = json['vendor_id'];
      if (vendorId == null)
        throw Exception('Vendor ID is required for update.');

      // Remove vendor_id from the update payload to avoid trying to update the primary key
      final updateData = Map<String, dynamic>.from(json)..remove('vendor_id');

      await supabase
          .from('vendors')
          .update(updateData)
          .eq('vendor_id', vendorId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Vendor Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Vendor Repo', message: e.toString());
      rethrow;
    }
  }

  Future<int> insertVendorInTable(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('vendors')
          .insert(json)
          .select('vendor_id')
          .single();

      final vendorId = response['vendor_id'] as int;
      return vendorId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Vendor Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Vendor Repo', message: e.toString());
      rethrow;
    }
  }

  Future<void> deleteVendorFromTable(int vendorId) async {
    try {
      await supabase.from('vendors').delete().match({'vendor_id': vendorId});

      TLoaders.successSnackBar(
          title: "Success", message: "Vendor deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Vendor Repo', message: e.toString());
        print("Error deleting vendor: $e");
      }
    }
  }
}
