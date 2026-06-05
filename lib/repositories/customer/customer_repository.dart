import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/customer/customer_model.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();

  Future<List<CustomerModel>> fetchAllCustomers() async {
    try {
      final data = await supabase.from('customers').select();
      //print(data);

      final customerList = data.map((item) {
        return CustomerModel.fromJson(item);
      }).toList();

      return customerList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  Future<void> updateCustomer(Map<String, dynamic> json) async {
    try {
      int? customerId = json['customer_id'];
      if (customerId == null) {
        throw Exception('Customer ID is required for update.');
      }

      // Remove customer_id from the update payload to avoid trying to update the primary key
      final updateData = Map<String, dynamic>.from(json)..remove('customer_id');

      await supabase
          .from('customers')
          .update(updateData)
          .eq('customer_id', customerId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Customer Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Customer Repo', message: e.toString());
      rethrow;
    }
  }

  Future<int> insertCustomerInTable(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('customers')
          .insert(json)
          .select('customer_id')
          .single();

      final customerId = response['customer_id'] as int;
      return customerId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Customer Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Customer Repo', message: e.toString());
      rethrow;
    }
  }

  Future<void> deleteCustomerFromTable(int customerId) async {
    try {
      await supabase
          .from('customers')
          .delete()
          .match({'customer_id': customerId});

      TLoaders.successSnackBar(
          title: "Success", message: "Customer deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Customer Repo', message: e.toString());
        print("Error deleting customer: $e");
      }
    }
  }
}
