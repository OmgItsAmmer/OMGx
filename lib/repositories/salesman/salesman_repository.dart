

import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/salesman/salesman_model.dart';

class SalesmanRepository extends GetxController {
  static SalesmanRepository get instance => Get.find();


  Future<int?> saveOrUpdateSalesmanRepo(Map<String, dynamic> json) async {
    try {
      int? salesmanId = json['salesman_id'];

      if (salesmanId != null) {
        // Fetch the salesman with the given salesman_id
        final response = await supabase
            .from('salesman')
            .select()
            .eq('salesman_id', salesmanId)
            .maybeSingle();

        if (response != null) {
          // If the salesman exists, update it
          await supabase.from('salesman').update(json).eq('salesman_id', salesmanId);
        } else {
          // If no existing salesman is found, insert a new one
          json.remove('salesman_id');
          final insertResponse = await supabase.from('salesman').insert(json).select('salesman_id').single();
          salesmanId = insertResponse['salesman_id'];
        }
      } else {
        // If salesman_id is not provided, insert a new salesman
        json.remove('salesman_id');
        final insertResponse = await supabase.from('salesman').insert(json).select('salesman_id').single();
        salesmanId = insertResponse['salesman_id'];
      }

      return salesmanId;
    } on PostgrestException catch (e) {
      TLoader.errorSnackBar(title: 'Salesman Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Salesman Repo', message: e.toString());
      rethrow;
    }
  }


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
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }

  }

Future<int>  insertSalesmanInTable(Map<String, dynamic> json) async {
  try {
    final response = await supabase
        .from('salesman')
        .insert(json)
        .select('salesman_id')
        .single();

    final salesmanId = response['salesman_id'] as int;
    return salesmanId;

  } on PostgrestException catch (e) {
    if (kDebugMode) {
      print(e);
      TLoader.errorSnackBar(title: 'insertSalesmanInTable', message: e.message);
    }
    rethrow;
  } catch (e) {
    if (kDebugMode) {
      print(e);
      TLoader.errorSnackBar(title: 'insertSalesmanInTable', message: e.toString());
    }
    rethrow;
  }

}

  Future<void> updateSalesman(Map<String, dynamic> json) async {
    try {
      int? salesmanId = json['salesman_id'];
      if (salesmanId == null) throw Exception('Salesman ID is required for update.');

      // Remove customer_id from the update payload to avoid trying to update the primary key
      final updateData = Map<String, dynamic>.from(json)..remove('salesman_id');

      await supabase
          .from('salesman')
          .update(updateData)
          .eq('salesman_id', salesmanId);

    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(title: 'updateSalesman', message: e.message);
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(title: 'updateSalesman', message: e.toString());
      }
      rethrow;
    }
  }


  Future<void> deleteSalesmanFromTable(int customerId) async {
    try {

      await supabase
          .from('salesman')
          .delete()
          .match({'salesman_id': customerId});



      TLoader.successSnackBar(title: "Success", message: "Salesman deleted successfully");

    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'deleteSalesmanFromTable', message: e.toString());
        print("Error deleting customer: $e");
      }
    }
  }





}