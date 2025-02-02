

import 'package:admin_dashboard_v3/Models/guarantors/guarantors_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../main.dart';


class GuarantorRepository extends GetxController {
  static GuarantorRepository get instance => Get.find();



  Future<List<GuarantorsModel>> fetchSpecificOrderGuarantors(int planId) async {
    try {
      // Fetch the installment plan details using planId
      final installmentPlan = await supabase
          .from('installment_plans')
          .select('guarantor1_id, guarantor2_id')
          .eq('installment_plans_id', planId)
          .single();
    print(installmentPlan);
      // Extract guarantor IDs from the installment plan
      final int? guarantor1Id = installmentPlan['guarantor1_id'] as int?;
      final int? guarantor2Id = installmentPlan['guarantor2_id'] as int?;

      // Check if both guarantor IDs are null
      if (guarantor1Id == null && guarantor2Id == null) {
        if (kDebugMode) {
          print('No guarantors found for the installment plan.');
        }
        return []; // Return an empty list if no guarantors are found
      }

      // Fetch data for the first guarantor (if ID is not null)
      final List<GuarantorsModel> guarantorList = [];

      if (guarantor1Id != null) {
        final data1 = await supabase
            .from('guarantors')
            .select()
            .eq('guarantor_id', guarantor1Id);

        if (data1.isNotEmpty) {
          guarantorList.add(GuarantorsModel.fromJson(data1.first));
        } else {
          // Add an empty guarantor if the first one is not found
          guarantorList.add(GuarantorsModel.empty());
        }
      } else {
        // Add an empty guarantor if the first ID is null
        guarantorList.add(GuarantorsModel.empty());
      }

      // Fetch data for the second guarantor (if ID is not null)
      if (guarantor2Id != null) {
        final data2 = await supabase
            .from('guarantors')
            .select()
            .eq('guarantor_id', guarantor2Id);

        if (data2.isNotEmpty) {
          guarantorList.add(GuarantorsModel.fromJson(data2.first));
        } else {
          // Add an empty guarantor if the second one is not found
          guarantorList.add(GuarantorsModel.empty());
        }
      } else {
        // Add an empty guarantor if the second ID is null
        guarantorList.add(GuarantorsModel.empty());
      }

      // Print the guarantors for debugging (if in debug mode)
      if (kDebugMode) {
        print('Guarantor 1: ${guarantorList[0].fullName}');
        print('Guarantor 2: ${guarantorList[1].fullName}');
      }

      return guarantorList;
    } catch (e) {
      // Handle errors and show a snackbar
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<int>> uploadGuarantors(List<Map<String, dynamic>> guarantors) async {
    try {
      // Insert guarantors into the 'guarantors' table and select the returned IDs
      final insertedData = await supabase
          .from('guarantors')
          .insert(guarantors)
          .select('guarantor_id');

      // Extract guarantor IDs from the inserted data
      List<int> guarantorIds =
      insertedData.map<int>((item) => item['guarantor_id'] as int).toList();

      return guarantorIds;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }





}