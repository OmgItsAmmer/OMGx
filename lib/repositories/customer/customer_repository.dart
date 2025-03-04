import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
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
      if (kDebugMode) {
        print(customerList[1].fullName);
      }
      return customerList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  Future<int?> saveOrUpdateCustomerRepo(Map<String, dynamic> json) async {
    try {
      int? customerId = json['customer_id'];

      if (customerId != null) {
        // Fetch the customer with the given customer_id
        final response = await supabase
            .from('customers')
            .select()
            .eq('customer_id', customerId)
            .maybeSingle();

        if (response != null) {
          // If the customer exists, update it
          await supabase.from('customers').update(json).eq('customer_id', customerId);
        } else {
          // If no existing customer is found, insert a new one
          json.remove('customer_id');
          final insertResponse = await supabase.from('customers').insert(json).select('customer_id').single();
          customerId = insertResponse['customer_id'];
        }
      } else {
        // If customer_id is not provided, insert a new customer
        json.remove('customer_id');
        final insertResponse = await supabase.from('customers').insert(json).select('customer_id').single();
        customerId = insertResponse['customer_id'];
      }

      return customerId;
    } on PostgrestException catch (e) {
      TLoader.errorSnackBar(title: 'Customer Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Customer Repo', message: e.toString());
      rethrow;
    }
  }


  Future<void> deleteCustomerFromTable(int customerId) async {
    try {

     await supabase
          .from('customers')
          .delete()
          .match({'customer_id': customerId});



      TLoader.successSnackBar(title: "Success", message: "Customer deleted successfully");

    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Customer Repo', message: e.toString());
        print("Error deleting customer: $e");
      }
    }
  }
}
